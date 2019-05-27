class Main_Screen extends PApplet {
  //Scene Vars
  int screenNumber;

  float glitchValue;
  int glitchValueCap = 2000;

  float minThresh = 0;
  float maxThresh = 750;
  PImage thresholdImage;

  //WALKER VARIABLES
  ArrayList<Particle> particles;

  public Main_Screen(int screenN ) {
    super();
    screenNumber = screenN;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    if (FS) {
      fullScreen(P2D, screenNumber);
    } else {
      size(900, 900, P2D);
    }
  }

  public void setup() { 
    colorMode(HSB, 360, 100, 100, 100);
    imageMode(CENTER);
    rectMode(CENTER);
    thresholdImage = createImage(kinect.width, kinect.height, RGB);

    //WALKER VARIABLES
    particles = new ArrayList<Particle>();

    background(hue(cols[0]), saturation(cols[0]), brightness(cols[0]));
  }

  public void draw() {


    background(cols[0]);

    glitchValue = distortionValue;
    glitchValue = constrain(glitchValue, 0, glitchValueCap);

    if (stageNumber == 1) {

      displayThresholdImage();
      horizontalSlitGlitch();
      boxArtefacts();
      randomFilter();
      //displayRectRender();
      //displayWalkerImage();
    } else if (stageNumber == 2) {
      displayRectRender();
    } else if (stageNumber == 3) {
      displayWalkerImage();
    } else if (stageNumber == 4) {
      displayThresholdImage();
      displayRectRender();
      displayWalkerImage();
    }


    pushMatrix();
    fill(0);
    text("DIST_VAL: "+distortionValue, 50, 50);
    text("GLITCH_VAL: "+glitchValue, 50, 75);
    text("SCALE_FAC: "+spectrumScaleFactor, 50, 100);
    
    text("FR: "+frameRate, 50, 150);
    popMatrix();
  }

  //------------------------
  //THRESHOLD IMAGE
  //------------------------
  void displayThresholdImage() {
    thresholdImage.loadPixels();
    int[] depth = kinect.getRawDepth();
    int skip = 1;
    for (int x = 0; x < kinect.width; x += skip) {
      for (int y = 0; y < kinect.height; y += skip) {
        int offset = x + y * kinect.width;
        int d = depth[offset];
        if (d > minThresh && d < maxThresh) {
          if (glitchValue > glitchValueCap * 0.75) {
            thresholdImage.pixels[offset] = color(random(360), 100, 75);
          } else {

            //float lerpAmm = map(d, minThresh, maxThresh, 1, 0);
            //color interCol = lerpColor(color(cols[3], 100), color(cols[2], 100), lerpAmm);
            //thresholdImage.pixels[offset] = interCol;
            //thresholdImage.pixels[offset] = color(random(360), 100,75);

            float h = map(d, minThresh, maxThresh, 0, 360);
            h = constrain(h, 0, 360);
            float b = map(d, minThresh, maxThresh, 100, 0);
            b = constrain(h, 0, 100);

            thresholdImage.pixels[offset] = color(h, 100, b);
          }
        } else {

          thresholdImage.pixels[offset] = color(hue(cols[0]), saturation(cols[0]), brightness(cols[0]), 0);
        }
      }
    }
    thresholdImage.updatePixels();
    noTint();
    image(thresholdImage, width/2, height/2, width, height);
  }

  //------------------------
  //FILTER EFFECT
  //------------------------
  void randomFilter() {
    int r = floor(random(4));

    if (r == 1) {
      filter(ERODE);
    } else if (r == 1) {
      filter(POSTERIZE, 100);
    } else if (r == 3) {
      filter(DILATE);
    }
  }

  //------------------------
  //BOX ARTEFACTS
  //------------------------
  void boxArtefacts() {
    //Load capture pixels
    thresholdImage.loadPixels();  

    float tx = (width-thresholdImage.width)/2 + thresholdImage.width/2;
    float ty = (height-thresholdImage.height)/2 + thresholdImage.height/2;

    pushMatrix();
    translate(tx, ty); 

    int artefactNumber = floor(glitchValue / 100);

    for (int i=0; i<artefactNumber; i++) {
      // find a random pixel in capture
      int x = floor(random(thresholdImage.width));
      int y = floor(random(thresholdImage.height));
      // get an offset ammount
      int xOff = int(random(-glitchValue, glitchValue));
      int yOff = int(random(-glitchValue, glitchValue));
      //define the point on screen where the box artefact will appear 
      int sx = x + xOff + int(tx-floor(random(thresholdImage.width))/2);
      int sy = y + yOff + int(ty-floor(random(thresholdImage.height))/2);

      int boxWidth = floor(map(glitchValue, 0, glitchValueCap, 0, width/2));

      PImage boxArtefact = thresholdImage.get(x, y, int(random(boxWidth/2, boxWidth)), int(random(boxWidth/2, boxWidth)));
      // set the pixels at that point 
      set(sx, sy, boxArtefact);
    }
    popMatrix();
    thresholdImage.updatePixels();
  }

  void horizontalSlitGlitch() {
    float tx = (width-thresholdImage.width)/2 + thresholdImage.width/2;
    float ty = (height-thresholdImage.height)/2 + thresholdImage.height/2;

    pushMatrix();
    translate(tx, ty); 

    for (int x=0; x<=1; x++) {
      float hOffset = 0;

      int position = int(random(thresholdImage.height));
      int verticleSteps = floor(random(thresholdImage.height));

      for (int v=position; v<verticleSteps; v++) {
        float distortRange = glitchValue / 5;
        hOffset += int(random(-distortRange, distortRange));
        //hOffset += int(random(-4, 4));
        PImage linea = createImage(thresholdImage.width, 1, RGB);

        int vFixed = (v >= thresholdImage.height ? v - thresholdImage.height : v);

        linea.copy(thresholdImage, 0, vFixed, thresholdImage.width, 1, 0, 0, thresholdImage.width, 1);
        //tint(cols[floor(random(cols.length))]);

        float posX = hOffset;
        float posY=  map(vFixed-thresholdImage.height/2, 0, thresholdImage.height, 0, height);

        image(linea, posX, posY, width, random(3));
      }
    }
    popMatrix();
  }


  //------------------------
  //RECT OFFSET IMAGE
  //------------------------
  void displayRectRender() {
    randomSeed(1);
    int[] depth = kinect.getRawDepth();
    int glitchCap = 2000;
    float gv = constrain(glitchValue, 0, glitchCap);
    int  skip = floor(map(gv, 0, glitchCap, 8, 20));
    float contChance = map(gv, 0, glitchCap, 0, 0.75);
    float offsetPos = map(gv, 0, glitchCap, 0, 100);
    for (int i=0; i<kinect.width; i+=skip) {
      float r1 = random(1);
      if (r1 < contChance/2) continue;
      for (int ii=0; ii<kinect.height; ii+=skip) {
        int offset =  i + ii * kinect.width;    
        int d = depth[offset];
        if (d >= minThresh && d <= maxThresh) {
          float tileSize = map(d, minThresh, maxThresh, 25, 1);
          float x = map(i, 0, kinect.width, 0, width) + randomGaussian()* offsetPos;
          float y = map(ii, 0, kinect.height, 0, height)+ randomGaussian()* offsetPos;
          float h = hue(kinect.getVideoImage().pixels[offset]);
          float s = saturation(kinect.getVideoImage().pixels[offset]);
          float b = blue(kinect.getVideoImage().pixels[offset]);
          pushMatrix();
          translate(x-skip/2, y-skip/2);
          strokeWeight(tileSize/6);
          stroke(hue(cols[3]), s, 100);
          noFill();
          rect(0, 0, tileSize, tileSize);
          popMatrix();
        }
      }
    }
  }

  //------------------------
  //WALKER IMAGE
  //------------------------
  void displayWalkerImage() {
    float particleSpawnChance = 0.25;
    thresholdImage.loadPixels();
    int[] depth = kinect.getRawDepth();
    int skip = 5;
    for (int x = 0; x < kinect.width; x += skip) {
      for (int y = 0; y < kinect.height; y += skip) {
        int offset = x + y * kinect.width;
        int d = depth[offset];
        if (d > minThresh && d < maxThresh) {
          if (random(1)>particleSpawnChance)continue;
          float posX = map(x, 0, kinect.width, 0, width);
          float posY = map(y, 0, kinect.height, 0, height);
          Particle particle = new Particle(
            //posX + random(-skip*2, skip*2), 
            //posY +random(-skip*2, skip*2), 
            posX, 
            posY, 
            skip
            );
          particles.add(particle);
        }
      }
    }



    for (int i = 0; i < particles.size(); i++) {
      if (particles.size() <= 0) continue;
      Particle p = particles.get(i);

      if (p.age > p.lifeSpan) {
        particles.remove(i);
        continue;
      } else p.run();
    }
  }

  //************************
  //CLASSES 
  //************************

  class Particle {
    PVector location, origin;
    PVector prevLocation;
    PVector velocity;
    PVector acceleration;
    float speed;
    float lifeSpan;
    float age;
    color col;


    Particle (float x, float y, float s) {
      location = new PVector(x, y);
      origin = location.copy();
      prevLocation = location.copy();
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
      age = 0;
      lifeSpan = random(15);
      speed    = s;

      int r = floor(random(cols.length));
      col = cols[r];
    }

    void run() {
      update();
      display();
    }

    void update() {

      updatePrev();
      float r = random(1);
      if (r<0.25) {
        location.x += speed;
      } else if (r<0.5) {
        location.x -= speed;
      } else if (r<0.75) {
        location.y -= speed;
      } else {
        location.y += speed;
      }

      glitchValue = distortionValue;
      int glitchCap = 2000;
      float gv = constrain(glitchValue, 0, glitchCap);
      speed = map(gv, 0, glitchCap, 1, 100);

      age++;
    }

    void display() {
      int posX = floor(map(location.x, 0, width, 0, kinect.width));
      int posY = floor(map(location.y, 0, height, 0, kinect.height));

      //float h = hue(kinect.getVideoImage().get(floor(posX), floor(posY)));
      //float s = saturation(kinect.getVideoImage().get(floor(posX), floor(posY)));
      float b = brightness(kinect.getVideoImage().get(floor(posX), floor(posY)));

      //float od = dist(location.x, location.y, origin.x, origin.y);
      //float a = map(od, 0, width/2, 100, 0);
      //float sw = map(od, 0, width/2, 10, 0);

      float sw = map(age, 0, lifeSpan, 12, 0);
      float a = map(age, 0, lifeSpan, 100, 0);
      strokeCap(PROJECT);
      stroke(hue(col), saturation(col), brightness(col), a);
      strokeWeight(sw);


      //point(location.x, location.y);
      line(location.x, location.y, prevLocation.x, prevLocation.y);
    }

    void updatePrev() {
      prevLocation.x = location.x;
      prevLocation.y = location.y;
    }

    void applyForce(PVector force) {
      acceleration.add(force);
    }
  }


  void keyPressed() {
    if (key == CODED) {
      if (keyCode == UP) {
        spectrumScaleFactor += 25;
        println(spectrumScaleFactor);
      } else if (keyCode == DOWN) {
        spectrumScaleFactor -= 25;
        println(spectrumScaleFactor);
      } else if (keyCode == LEFT) {
        //spectrumScaleFactor -= 25;
      } else if (keyCode == RIGHT) {
        //spectrumScaleFactor -= 25;
      }
    }
  }
} // END OF MAIN SCREEN OBJECT
