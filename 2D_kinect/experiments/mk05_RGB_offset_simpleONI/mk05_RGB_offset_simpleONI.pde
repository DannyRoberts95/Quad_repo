import processing.video.*;
import SimpleOpenNI.*;
import processing.serial.*;

//Generate a SimpleOpenNI object
SimpleOpenNI kinect;
//depth array
int[] depthMap;
PImage depthFeed, rgbFeed;
int minThresh, maxThresh;
boolean trackingUser = false;

void settings() {
  fullScreen(P2D);
}

void setup() { 
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser();
  kinect.setMirror(false);
  minThresh = 500;
  maxThresh = 1500;
}

void draw() {
  background(0);
  kinect.update();
  renderDistortedImage();
  getHandsLocations();

  
  if (trackingUser) {
    stroke(100);  
    fill(0, 255, 0);
    ellipse(width/2, 50, 25, 25);
  }
}

void renderDistortedImage() {
  //rgbFeed.loadPixels();
  int skip = 5;
  for (int i=0; i<kinect.depthWidth()-1; i+=skip) {
    for (int ii=0; ii<kinect.depthHeight()-1; ii+=skip) {
      int offset =  i + ii * kinect.depthWidth();    
      float d = kinect.depthMap()[offset];
      if (d >= minThresh && d <= maxThresh) {
        float rad = map(d, minThresh, maxThresh, 5, 1);
        float x = map(i, 0, kinect.depthWidth(), 0, width);
        float y = map(ii, 0, kinect.depthHeight(), 0, height);
        float r = red(kinect.rgbImage().pixels[offset]);
        float g = green(kinect.rgbImage().pixels[offset]);
        float b = blue(kinect.rgbImage().pixels[offset]);
        //float a = map(d, minThresh, maxThresh, 255, 0);
        strokeWeight(rad);
        blendMode(HARD_LIGHT);
        stroke(r, 0, 0);
        point(x+5, y);
        stroke(0, g, 0);
        point(x-5, y);
        stroke(0, 0, b);
        point(x, y+5);
      }
    }
  }
}

void getHandsLocations() {
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    //If we detect one user we have to draw it
    if ( kinect.isTrackingSkeleton(userId)) {
      fill(255, 25);
      stroke(0, 0, 255);
      strokeWeight(5);
      line(getJointLocation(userId, SimpleOpenNI.SKEL_LEFT_HAND).x, getJointLocation(userId, SimpleOpenNI.SKEL_LEFT_HAND).y, 
        getJointLocation(userId, SimpleOpenNI.SKEL_RIGHT_HAND).x, getJointLocation(userId, SimpleOpenNI.SKEL_RIGHT_HAND).y);
      ellipse(getJointLocation(userId, SimpleOpenNI.SKEL_LEFT_HAND).x, getJointLocation(userId, SimpleOpenNI.SKEL_LEFT_HAND).y, 25, 25);
      ellipse(getJointLocation(userId, SimpleOpenNI.SKEL_RIGHT_HAND).x, getJointLocation(userId, SimpleOpenNI.SKEL_RIGHT_HAND).y, 25, 25);
    }
  }
}
