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

float        zoomF =0.3f;
// by default rotate the hole scene 180deg around the x-axis, 
// the data from openni comes upside down
float rotX = radians(180);  
float rotY = radians(0);
float scaleFactor = 2;

void settings() {
  fullScreen(P3D);
}

void setup() { 
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser();
  kinect.setMirror(false);
  minThresh = 500;
  maxThresh = 1800;

  perspective();
}

void draw() {
  kinect.update();

  background(0);

  // Eye position: width/2, height/2, (height/2) / tan(PI/6)
  //Scene center: width/2, height/2, 0
  //Upwards axis: 0, 1, 0
  //When written in code, this looks like:
  //camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);


  camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);

  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);


  renderImage();
}


void renderImage() {

  PVector[] realWorldMap = kinect.depthMapRealWorld();

  int skip = 5;


  strokeWeight(1);
  stroke(100);
  beginShape(POINTS);

  for (int i=0; i<kinect.depthWidth()-1; i+=skip) {
    for (int ii=0; ii<kinect.depthHeight()-1; ii+=skip) {
      int offset =  i + ii * kinect.depthWidth();    
      PVector point = realWorldMap[offset];
      if (point.z >= minThresh && point.z <= maxThresh) {
        vertex(point.x*scaleFactor, point.y*scaleFactor, point.z*scaleFactor);
      }
    }
  }
  endShape();
  kinect.drawCamFrustum();
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
