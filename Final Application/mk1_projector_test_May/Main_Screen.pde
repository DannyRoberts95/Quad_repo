class Main_Screen extends PApplet {

  //Scene Vars
  int screenNumber;
  float glitchValue;
  float minThresh = 500;
  float maxThresh = 1800;
  float currentMinThresh = 0;
  float currentMaxThresh = 0;
  PImage img;

  int sketchNumber = 2;

  public Main_Screen(int screenN ) {
    super();
    screenNumber = screenN;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    if (FS) {
      fullScreen(P2D, screenNumber);
    } else {
      size(500, 500, P2D);
    }
  }

  public void setup() { 
    colorMode(HSB, 360, 100, 100, 100);
    imageMode(CENTER);
    rectMode(CENTER);
    img = createImage(kinect.width, kinect.height, RGB);
  }

  public void draw() {

    background(pinkCol);

    pushMatrix();
    fill(255);
    text(distortionValue, 50, 50);
    popMatrix();    

    glitchValue = distortionValue;

    int glitchCap = 2000;
    float gv = constrain(glitchValue, 0, glitchCap);
    currentMaxThresh = map(gv, 0, glitchCap, maxThresh/2, maxThresh);
    //currentMaxThresh = 750;

    if (sketchNumber == 1) {
      displayThresholdImage();
    } else if (sketchNumber == 2) {
      displayRGBOffsetImage();
    }
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
          color interCol = lerpColor(color(pinkCol, 100), color(blueCol, 100), lerpAmm);
          img.pixels[offset] = interCol;
        } else {
          img.pixels[offset] = color(0, 0);
        }
      }
    }
    img.updatePixels();
    image(img, width/2, height/2, width, height);
  }



  //------------------------
  //RECT OFFSET IMAGE
  //------------------------

  void displayRGBOffsetImage() {
    randomSeed(1);
    int[] depth = kinect.getRawDepth();


    int glitchCap = 2000;
    float gv = constrain(glitchValue, 0, glitchCap);

    int  skip = floor(map(gv, 0, glitchCap, 8, 20));
    float contChance = map(gv, 0, glitchCap, 0, 0.75);
    float offsetPos = map(gv, 0, glitchCap, 0, 150);

    for (int i=0; i<kinect.width; i+=skip) {

      float r1 = random(1);
      if (r1 < contChance/2) continue;

      for (int ii=0; ii<kinect.height; ii+=skip) {

        int offset =  i + ii * kinect.width;    
        int d = depth[offset];
        if (d >= minThresh && d <= currentMaxThresh) {

          float tileSize = map(d, minThresh, currentMaxThresh, 25, 1);

          //float x = map(i, 0, kinect.width, 0, width) + random(-offsetPos, offsetPos);
          //float y = map(ii, 0, kinect.height, 0, height)+ random(-offsetPos, offsetPos);

          float x = map(i, 0, kinect.width, 0, width) + randomGaussian()* offsetPos;
          float y = map(ii, 0, kinect.height, 0, height)+ randomGaussian()* offsetPos;

          float h = hue(kinect.getVideoImage().pixels[offset]);
          float s = saturation(kinect.getVideoImage().pixels[offset]);
          float b = blue(kinect.getVideoImage().pixels[offset]);

          pushMatrix();
          translate(x-skip/2, y-skip/2);
          strokeWeight(tileSize/6);
          stroke(hue(blueCol), s, b);
          noFill();
          rect(0, 0, tileSize, tileSize);
          popMatrix();
        }
      }
    }
  }

  void mousePressed() {
    sketchNumber++;
    if (sketchNumber < 2) {
      sketchNumber = 1;
    }
  }
}
