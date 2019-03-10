import processing.video.*;
import SimpleOpenNI.*;
import processing.serial.*;

//Generate a SimpleOpenNI object
SimpleOpenNI kinect;
//depth array
int[] depthMap;
PImage depthFeed, rgbFeed;
int minThresh, maxThresh;

float xOff, yOff, xInc, yInc, waveAmp, distortX, distortY;
boolean trackingUser = false;

void settings() {
  //fullScreen(P2D);
  size(1200,1200);
}

void setup() { 
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser();
  kinect.setMirror(false);
  
  minThresh = 500;
  maxThresh = 2000;
  
  xOff = random(10000);
  yOff = random(10000);
  xInc = 0.05;
  yInc = 0.02;
}

void draw() {
  background(0);
  kinect.update();
  renderDistortedImage();

  if (trackingUser) {
    updateWave();
  }
}//END OF DRAW

void updateWave() {
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    float handDist = dist(getRighthandLocation().x, getRighthandLocation().y, getLefthandLocation().x, getLefthandLocation().y);
    waveAmp = map(abs(handDist), 0, width, 0, 1000);
    waveAmp = constrain(waveAmp,0,1000);
    distortX = noise(xOff)*waveAmp;
    distortY = noise(yOff)*waveAmp;
  }
  xOff += xInc;
  xOff += yInc;
}




void renderDistortedImage() {
  int skip = 5;
  for (int i=0; i<kinect.depthWidth()-1; i+=skip) {
    for (int ii=0; ii<kinect.depthHeight()-1; ii+=skip) {
      int offset =  i + ii * kinect.depthWidth();    



      float d = kinect.depthMap()[offset];
      if (d >= minThresh && d <= maxThresh) {
        float rad = map(d, minThresh, maxThresh, 10, 2);
        float x = map(i, 0, kinect.depthWidth(), 0, width);
        float y = map(ii, 0, kinect.depthHeight(), 0, height);
        float r = red(kinect.rgbImage().pixels[offset]);
        float g = green(kinect.rgbImage().pixels[offset]);
        float b = blue(kinect.rgbImage().pixels[offset]);

        strokeWeight(rad);
        stroke(r, 0, 0);
        
        
        point(x+distortX, y+distortY);
        stroke(0, g, 0);
        point(x-distortX, y-distortY);
        stroke(0, 0, b);
        point(x-distortX, y+distortX);
      }
    }
  }
}
