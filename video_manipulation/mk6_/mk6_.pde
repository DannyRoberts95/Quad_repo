import SimpleOpenNI.*;

SimpleOpenNI kinect;
PImage capture;
ArrayList<PImage> captureArray;
int maxFrames = 5;

float frameSize = 100;

int res = 5;
int cols;
int rows;

void settings() {
  size(1000, 1000, P2D);
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  imageMode(CENTER);
  rectMode(CENTER);
  blendMode(BLEND);
  captureArray = new ArrayList<PImage>();
  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
}

void draw() {
  kinect.update();
  capture = kinect.rgbImage();
  captureArray.add(capture);


  for (int i = captureArray.size()-1; i > 0; i--) {

    PImage c = captureArray.get(i);

    float w = map(i, 0, maxFrames, frameSize, width);
    float h = map(i, 0, maxFrames, frameSize, height);

    cols = floor(w/ res);
    rows = floor(h/ res);

    float xMargin = cols*res/2;
    float yMargin = rows*res/2;

    pushMatrix();
    translate(width/2, height/2);
    
    c.loadPixels();

    for (int ii = 0; ii<cols; ii++) {
      for (int iii =0; iii<rows; iii++) {

        float x = ii * res;
        float y = iii * res;

        int pixelX = floor(map(x, 0, w, 0, capture.width));
        int pixelY = floor(map(y, 0, h, 0, capture.height));

        color col = capture.get(pixelX, pixelY);

        pushMatrix();
        translate(x+res/2-xMargin, y+res/2-yMargin);
        noStroke();
        fill(col);
        rect(0, 0, res, res);
        popMatrix();
      }
    }



    //image(c, 0, 0, w, h);    
    popMatrix();
  }
  if (captureArray.size() > maxFrames) {
    captureArray.remove(captureArray.size()-1);
  }
}
