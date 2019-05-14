import SimpleOpenNI.*;
import milchreis.imageprocessing.*;


SimpleOpenNI kinect;
PImage capture;

void settings(){
  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
  size(kinect.rgbImage().width,kinect.rgbImage().height);
}

void setup(){
  
}

void draw(){
  background(0);
  
  kinect.update();
  capture = kinect.rgbImage();
  
  image(capture,0,0);
}
