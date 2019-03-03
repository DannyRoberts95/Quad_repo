import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import processing.video.*;
Kinect kinect;
float tiltAngle;

void setup() { 
  //fullScreen(P2D);
  size(1000,1000,P2D);
  kinect = new Kinect(this);
  tiltAngle = kinect.getTilt();
  kinectSetup();
}

void draw() {
  background(0);
  drawDepthImage();
}
