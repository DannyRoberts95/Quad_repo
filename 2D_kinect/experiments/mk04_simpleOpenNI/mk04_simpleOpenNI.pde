import processing.video.*;
import SimpleOpenNI.*;
import processing.serial.*;

//Generate a SimpleOpenNI object
SimpleOpenNI kinect;
//depth array
int[] depthMap;

void settings() {
  fullScreen(P2D);
}

void setup() { 
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser();
  kinect.setMirror(false);
  depthMap = kinect.depthMap();
}
void draw() {
  background(0);
  kinect.update();
  image(kinect.rgbImage(), 0, 0, width, height);
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
