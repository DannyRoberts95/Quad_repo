import SimpleOpenNI.*;

SimpleOpenNI kinect;
PImage capture;
int res = 20;
int cols;
int rows;

void settings() {
  size(displayWidth, displayHeight, P2D);        
}

void setup() {
  colorMode(HSB,360,100,100,100);
  rectMode(CENTER);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();

  cols = width/ res;
  rows = height/ res;
}

void draw() {
  kinect.update();
  capture = kinect.rgbImage();
  
  res = int(map(mouseX,0,width,10,100));
    
  capture.loadPixels();
  for (int x =0; x<width; x+=res) {
    for (int y =0; y<height; y+=res) {
      
      int pX = floor(map(x,0,width,0,capture.width));
      int pY = floor(map(y,0,height,0,capture.height));
      
      color col = capture.get(pX,pY);
      
      pushMatrix();
      translate(x+res/2, y+res/2);
      //rotate(45);      
      noStroke();
      fill(col);
      rect(0, 0, res, res);
      popMatrix();
    }
  }

  //image(capture, 0, 0);
}
