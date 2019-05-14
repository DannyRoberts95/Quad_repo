import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

void setup() {
  fullScreen(P3D,2);
  colorMode(HSB,360,100,100);
  kinect = new Kinect(this);
  kinect.initDepth();
}

void draw() {
  
}
