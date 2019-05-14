class Main_Screen extends PApplet {

  //Scene Vars
  int screenNumber;
  float glitchValue;
  float minThresh = 550;
  float maxThresh = 775;
  PImage img;

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
    background(0);  
    imageMode(CENTER);
    rectMode(CENTER);
    img = createImage(kinect.width, kinect.height, RGB);
  }

  public void draw() {

    pushMatrix();
    fill(255);
    text(distortionValue, 50, 50);
    popMatrix();    

    glitchValue = distortionValue;
    displayThresholdImage();
  }

  //**********************************************
  // Effect Class
  //**********************************************

  void displayThresholdImage() {
    img.loadPixels();
    int[] depth = kinect.getRawDepth();
    int skip = 1;
    for (int x = 0; x < kinect.width; x += skip) {
      for (int y = 0; y < kinect.height; y += skip) {
        int offset = x + y * kinect.width;
        int d = depth[offset];

        float cRange = glitchValue;

        color c1 = color(0, 0, 100);

        float h = cRange+random(360);
        if (h > 360) h -= 360;

        color c2 = color(cRange, 100, 100);



        if (d > minThresh && d < maxThresh) {

          if (glitchValue > 25 ) {
            float lerpAmm = map(d, minThresh, maxThresh, 0, 1);
            color interCol = lerpColor(c1, c2, lerpAmm);
            img.pixels[offset] = interCol;
          } 
        } else {
          img.pixels[offset] = color(0, 0);
        }
      }
    }
    img.updatePixels();
    image(img, width/2, height/2, width, height);
  }
}
