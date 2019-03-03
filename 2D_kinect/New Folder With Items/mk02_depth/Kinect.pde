//PImage  getDepthImage() 
//          Get the depth image (does not make a new object, use get() if you need a copy)
// int[]  getRawDepth() 
//          Get the raw depth values from the Kinect.
// float  getTilt() 
//          Get the tilt angle of the Kinect.
// PImage  getVideoImage() 
//          Get the video image (does not make a new object, use get() if you need a copy)
// int  numDevices() 
//          Returns the number of Kinect devices detected
// void  setColorDepth(boolean b) 
//          Enable mapping depth values to color image (instead of grayscale)
// void  setDevice(int n) 
//          Set the active device
// void  setIR(boolean b) 
//          Enable IR image (instead of RGB video)
// void  startDepth() 
//          Start getting depth from Kinect (available as raw array or mapped to image)
// void  startVideo() 
//          Start getting RGB video from Kinect.
// void  stopDepth() 
//          Stop getting depth from Kinect.
// void  stopVideo() 
//          Stop getting RGB video from Kinect.
// void  tilt(float deg) 
//          Set the tilt angle of the Kinect.
// void  toggleDepth() 
//          Toggle depth (start or stop depending on whether it's active or not.)
// void  toggleVideo() 
//          Toggle RGB video (start or stop depending on whether it's active or not.)

void kinectSetup() {
  kinect.initVideo();
  kinect.initDepth();
}

void drawDepthImage() {
  PImage feed = kinect.getVideoImage();
  feed.loadPixels();
  int[] depthValues = kinect.getRawDepth();
  int skip = 5;
  int minThresh = 0;
  int maxThresh = 750;
  for (int i=0; i<kinect.width-1; i+=skip) {
    for (int ii=0; ii<kinect.height-1; ii+=skip) {
      int offset =  i + ii * kinect.width;    
      float d = depthValues[offset];
      if (d >= minThresh && d <= maxThresh) {
        float x = map(i, 0, kinect.width, 0, width);
        float y = map(ii, 0, kinect.height, 0, height);
        float radius = map(d, minThresh, maxThresh, 8, 2);
        //float r = red(feed.pixels[offset]);
        //float g = green(feed.pixels[offset]);
        //float b = blue(feed.pixels[offset]);
        float b = map(d,minThresh, maxThresh,255,0);
        noStroke();
        fill(b);
        ellipse(x, y, radius*2, radius*2);
      }
    }
  }
}

void drawRgb() {
  image(kinect.getVideoImage(), 0, 0, width, height);
}

//================================================================================
//  HARD CODED VALUES FORKINECT HARDWARE DO NOT ALTER
//  These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
//================================================================================
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

///camera information based on the Kinect v2 hardware
static class CameraParams {
  static float cx = 254.878f;
  static float cy = 205.395f;
  static float fx = 365.456f;
  static float fy = 365.456f;
  static float k1 = 0.0905474;
  static float k2 = -0.26819;
  static float k3 = 0.0950862;
  static float p1 = 0.0;
  static float p2 = 0.0;
}
