import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import gab.opencv.*;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

Kinect kinect;
float minThresh = 550;
float maxThresh = 775;
float a;

PImage img, dst;
OpenCV opencv;

void setup() {
  fullScreen(P2D);
  //frameRate(1);
  kinect = new Kinect(this);
  kinect.initDepth();
  img = createImage(kinect.width, kinect.height, RGB);
  
}

void draw() {
  background(0);

  img.loadPixels();
  int[] depth = kinect.getRawDepth();
  int skip = 1;
  for (int x = 0; x < kinect.width; x += skip) {
    for (int y = 0; y < kinect.height; y += skip) {
      int offset = x + y * kinect.width;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh) {
        img.pixels[offset] = color(255, 0, 0);
      } else {
        img.pixels[offset] = color(0);
      }
    }
  }
  img.updatePixels();
  
  opencv = new OpenCV(this, img);
  opencv.gray();
  opencv.threshold(70);
  contours = opencv.findContours();
    
  for (Contour contour : contours) {
    stroke(0, 255, 0);
    contour.draw();
  }
  
}
