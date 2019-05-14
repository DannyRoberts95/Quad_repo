class Main_Screen extends PApplet {

  //Scene Vars
  int screenNumber;
  float glitchValue;
  float minThresh = 500;
  float maxThresh = 1800;
  float currentMinThresh = 0;
  float currentMaxThresh = 0;
  PImage img;

  int sketchNumber = 1;

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
  }

  public void draw() {

    pushMatrix();
    fill(255);
    text(distortionValue, 50, 50);
    popMatrix();    

    int glitchCap = 2000;
    float gv = constrain(glitchValue, 0, glitchCap);
    currentMaxThresh = map(gv, 0, glitchCap, maxThresh/2, maxThresh);

    glitchValue = distortionValue;



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

  void displayRectImage() {
    background(backgroundCol);
    int[] depth = kinect.getRawDepth();
    int skip = 5;
    for (int i=0; i<kinect.width; i+=skip) {
      for (int ii=0; ii<kinect.height; ii+=skip) {
        int offset =  i + ii * kinect.width;    
        int d = depth[offset];
        if (d >= minThresh && d <= currentMaxThresh) {
          float rad = map(d, minThresh, maxThresh, 10, 1);
          float x = map(i, 0, kinect.width, 0, width);
          float y = map(ii, 0, kinect.height, 0, height);
          float r = red(kinect.getVideoImage().pixels[offset]);
          float g = green(kinect.getVideoImage().pixels[offset]);
          float b = blue(kinect.getVideoImage().pixels[offset]);
          strokeWeight(rad);
          stroke(r, g, b);
          point(x, y);
          //stroke(0, g, 0);
          //point(x-5, y);
          //stroke(0, 0, b);
          //point(x, y+5);
        }
      }
    }
  }

  //------------------------
  //RGB OFFSET IMAGE
  //------------------------

  void displayRGBOffsetImage() {
    background(backgroundCol);
    int[] depth = kinect.getRawDepth();
    int skip = 5;
    for (int i=0; i<kinect.width; i+=skip) {
      for (int ii=0; ii<kinect.height; ii+=skip) {
        int offset =  i + ii * kinect.width;    
        int d = depth[offset];
        if (d >= minThresh && d <= currentMaxThresh) {
          float rad = map(d, minThresh, maxThresh, 10, 1);
          float x = map(i, 0, kinect.width, 0, width);
          float y = map(ii, 0, kinect.height, 0, height);
          float r = red(kinect.getVideoImage().pixels[offset]);
          float g = green(kinect.getVideoImage().pixels[offset]);
          float b = blue(kinect.getVideoImage().pixels[offset]);
          strokeWeight(rad);
          stroke(r, g, b);
          point(x, y);
          //stroke(0, g, 0);
          //point(x-5, y);
          //stroke(0, 0, b);
          //point(x, y+5);
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
