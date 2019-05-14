import processing.video.*;
import SimpleOpenNI.*;
import processing.serial.*;

//KINECT VARS
SimpleOpenNI kinect;
int[] depthMap;
PImage depthFeed, rgbFeed;
int minThresh, maxThresh;
boolean trackingUser = false;

int skip = 5;
int cellSize = 5;
int cellPadding = 2;
int cols, rows;
float [][] forceField;

int amp = 100;
float noiseOffX = random(1000);
float noiseOffY = random(1000);

void settings() {
  fullScreen(P2D);
  //size(1200,1200);
}

void setup() { 
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser();
  kinect.setMirror(false);

  cols = kinect.depthImage().width/ skip;
  rows = kinect.depthImage().height/ skip;
  
  forceField = new float[cols][rows];
  
  for (int i=0; i<cols; i++) {
    noiseOffX += 0.05;
    for (int ii=0; ii<rows; ii++) {
      forceField[i][ii] = map(noise(noiseOffX, noiseOffY),0,1,0,amp);
      noiseOffY += 0.05;
    }
    
  }

  minThresh = 500;
  maxThresh = 1250;
}

void draw() {
  randomSeed(1);
  background(0);
  kinect.update();
  renderDistortedImage();
}//END OF DRAW



void renderDistortedImage() {

  for (int i=0; i<cols; i++) {
    for (int ii=0; ii<rows; ii++) {

      int x = i*(skip);
      int y = ii*(skip);

      int offset =  x + y * kinect.depthImage().width;

      float d = kinect.depthMap()[offset];
      if (d > minThresh && d < maxThresh) {

        float posX = map(x, 0, kinect.depthImage().width, 0, width);
        float posY = map(y, 0, kinect.depthImage().height, 0, height);

        float offsetPos = random(-mouseX, mouseX);
        float rFactor = map(mouseY, 0, height, 0, 0.5);
        float r = random(1);

        float rad = map(d, minThresh, maxThresh, cellSize*3, cellSize*0.5);

        noFill();
        stroke(255);
        strokeWeight(0.5);
        if (r < rFactor) {
          ellipse(posX+offsetPos, posY, rad*2, rad*2);
        } else if (r < rFactor*2) {
          ellipse(posX, posY+offsetPos, rad*2, rad*2);
        } else ellipse(posX, posY, rad*2, rad*2);
      }
    }
  }
}
