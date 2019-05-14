import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.openkinect.freenect.*; 
import org.openkinect.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class kinect_minMaxThreshold extends PApplet {




Kinect kinect;
float minThresh = 550;
float maxThresh = 775;
;
float a;
PImage img;

public void setup() {
  
  kinect = new Kinect(this);
  kinect.initDepth();
  img = createImage(kinect.width, kinect.height, RGB);
}

public void draw() {
  background(0);

  img.loadPixels();

  //minThresh = map(mouseX,0,width, 0, 2048);
  //maxThresh = map(mouseY,0,height, 0, 2048);

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
  image(img, 0, 0, width, height);
  fill(255);
  textSize(12);
  text(minThresh, 20, 20);
  text(maxThresh, 20, 40);
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
public float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0f / ((double)(depthValue) * -0.0030711016f + 3.3309495161f));
  }
  return 0.0f;
}

// Only needed to make sense of the ouput depth values from the kinect
public PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0f / 5.9421434211923247e+02f;
  final double fy_d = 1.0f / 5.9104053696870778e+02f;
  final double cx_d = 3.3930780975300314e+02f;
  final double cy_d = 2.4273913761751615e+02f;

  // Drawing the result vector to give each point its three-dimensional space
  PVector result = new PVector();
  double depth =  rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}
///camera information based on the Kinect v2 hardware
static class CameraParams {
  static float cx = 254.878f;
  static float cy = 205.395f;
  static float fx = 365.456f;
  static float fy = 365.456f;
  static float k1 = 0.0905474f;
  static float k2 = -0.26819f;
  static float k3 = 0.0950862f;
  static float p1 = 0.0f;
  static float p2 = 0.0f;
}
  public void settings() {  fullScreen(P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#000000", "--hide-stop", "kinect_minMaxThreshold" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
