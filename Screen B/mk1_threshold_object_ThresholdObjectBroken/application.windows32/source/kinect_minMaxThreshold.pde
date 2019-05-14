import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
float minThresh = 550;
float maxThresh = 775;
;
float a;
PImage img;

void setup() {
  fullScreen(P3D);
  kinect = new Kinect(this);
  kinect.initDepth();
  img = createImage(kinect.width, kinect.height, RGB);
}

void draw() {
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
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

// Only needed to make sense of the ouput depth values from the kinect
PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  // Drawing the result vector to give each point its three-dimensional space
  PVector result = new PVector();
  double depth =  rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}
