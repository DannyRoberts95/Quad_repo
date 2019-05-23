class Main_Screen extends PApplet {

  //Scene Vars
  int screenNumber;
  float glitchValue;
  float minThresh = 500;
  float maxThresh = 1800;
  float currentMinThresh = 0;
  float currentMaxThresh = 0;
  PImage img;




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
    img = createImage(kinect.width, kinect.height, RGB);

    //WALKER VARIABLES
    particles = new ArrayList<Particle>();

    background(hue(cols[0]), saturation(cols[0]), brightness(cols[0]));
  }

  public void draw() {

    background(cols[0]);
    //background(0, 0, 100);

    pushMatrix();
    fill(255);
    text(distortionValue, 50, 50);

    fill(255);
    text(frameRate, 50, 100);
    popMatrix();    

    glitchValue = distortionValue;

    int glitchCap = 2000;
    float gv = constrain(glitchValue, 0, glitchCap);
    //currentMaxThresh = map(gv, 0, glitchCap, maxThresh/2, maxThresh);
    currentMaxThresh = 750;

    if (stageNumber == 1) {
      displayThresholdImage();
    } else if (stageNumber == 2) {
      displayRectRender();
    } else if (stageNumber == 3) {
      displayWalkerImage();
    } else if (stageNumber == 4) {
      displayRectRender();
      displayWalkerImage();
    }

    //displayThresholdImage();
    //displayRectRender();
    //displayWalkerImage();
  }

  //------------------------
  //THRESHOLD IMAGE
  //------------------------
  void displayThresholdImage() {
    img.loadPixels();
    int[] depth = kinect.getRawDepth();
    int skip = 1;
    for (int x = 0; x < kinect.width; x += skip) {
      for (int y = 0; y < kinect.height; y += skip) {
        int offset = x + y * kinect.width;
        int d = depth[offset];
        if (d > minThresh && d < currentMaxThresh) {
          float lerpAmm = map(d, minThresh, currentMaxThresh, 1, 0);
          color interCol = lerpColor(color(cols[3], 100), color(cols[2], 100), lerpAmm);
          img.pixels[offset] = interCol;
        } else {
          img.pixels[offset] = color(hue(cols[0]), saturation(cols[0]), brightness(cols[0]), 0);
        }
      }
    }
    img.updatePixels();
    image(img, width/2, height/2, width, height);
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
        if (d >= minThresh && d <= currentMaxThresh) {
          float tileSize = map(d, minThresh, currentMaxThresh, 25, 1);
          float x = map(i, 0, kinect.width, 0, width) + randomGaussian()* offsetPos;
          float y = map(ii, 0, kinect.height, 0, height)+ randomGaussian()* offsetPos;
          float h = hue(kinect.getVideoImage().pixels[offset]);
          float s = saturation(kinect.getVideoImage().pixels[offset]);
          float b = blue(kinect.getVideoImage().pixels[offset]);
          pushMatrix();
          translate(x-skip/2, y-skip/2);
          strokeWeight(tileSize/6);
          stroke(hue(cols[2]), s, 100);
          noFill();
          rect(0, 0, tileSize, tileSize);
          popMatrix();
        }
      }
    }
  }

  //------------------------
  //THRESHOLD IMAGE
  //------------------------
  void displayWalkerImage() {
    float particleSpawnChance = 0.25;
    img.loadPixels();
    int[] depth = kinect.getRawDepth();
    int skip = 5;
    for (int x = 0; x < kinect.width; x += skip) {
      for (int y = 0; y < kinect.height; y += skip) {
        int offset = x + y * kinect.width;
        int d = depth[offset];
        if (d > minThresh && d < currentMaxThresh) {
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
      stroke(hue(col), saturation(col),brightness(col), a);
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
}
//CLASSES
