import SimpleOpenNI.*;

SimpleOpenNI kinect;
PImage capture;
ArrayList<PImage> captureArray;


void settings() {
  size(1000, 1000, P2D, "2");        
}

void setup() {
  colorMode(HSB,360,100,100,100);
  rectMode(CENTER);
  
  captureArray = new ArrayList<PImage>();
  
  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();

}

void draw() {
  kinect.update();
  capture = kinect.rgbImage();
  
  
  
  image(capture, 0, 0, 480, 480);
}
