import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

float a;

void setup() {
  //size(640, 480, P3D);
  fullScreen(P3D);
  kinect = new Kinect(this);
  //start using dpeth imaging no need to init device
  kinect.initDepth();
  //angle of rotation
  a = 0.0015;
}

void draw() {
  background(0);

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 4;
  float factor = 1000;

 
  int minthresh = 0;
  int maxthresh = 750;

  // Translate and rotate
  translate(width/2, height/2, 25);
  rotateX(-18.56);
  rotateY(-a);

  // Nested for loop that initializes x and y pixels and, for those less than the
  // maximum threshold and at every skiping point, the offset is caculated to map
  // them on a plane instead of just a line
  for (int x = 0; x < kinect.width; x += skip) {
    for (int y = 0; y < kinect.height; y += skip) {
      int offset = x + y * kinect.width;

      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];

      if (rawDepth > minthresh && rawDepth < maxthresh) {
        PVector point = depthToWorld(x, y, rawDepth);
        float r = map(rawDepth,0,2047,1,10);
        stroke(255);
        strokeWeight(r);
        pushMatrix();
        beginShape(POINTS);
        translate(point.x*factor, point.y*factor, factor-point.z*factor);
        vertex(0, 0);
        endShape();
        popMatrix();
      }
    }
  }

  // Rotate
  a += 0.015f;
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
