import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import processing.video.*;

Capture video;
Kinect kinect;
PImage kinectImg;
PImage kinectDepthImg;
float deg;

void setup() { 
  size(1200, 800);
  kinectSetup();
  deg = kinect.getTilt();
}

void draw() {
  drawKinectImage();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      deg++;
    } else if (keyCode == DOWN) {
      deg--;
    }
    deg = constrain(deg, 0, 30);
    kinect.setTilt(deg);
  }
}
