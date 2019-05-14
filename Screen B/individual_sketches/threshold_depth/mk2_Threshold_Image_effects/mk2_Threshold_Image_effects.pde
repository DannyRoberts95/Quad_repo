import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
Main_Screen mainScreen; 

void setup() {
  size(150,150,P2D);
  colorMode(HSB,360,100,100);
  kinect = new Kinect(this);
  kinect.initDepth();
  
  mainScreen = new Main_Screen(1);
  mainScreen = new Main_Screen(2);
  
  background(0,100,100);
}

void draw() {
  
}
