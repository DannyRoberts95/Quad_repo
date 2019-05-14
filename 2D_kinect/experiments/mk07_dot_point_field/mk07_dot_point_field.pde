import processing.video.*;
import SimpleOpenNI.*;
import processing.serial.*;

//KINECT VARS
SimpleOpenNI kinect;
int[] depthMap;
PImage depthFeed, rgbFeed;
int minThresh, maxThresh;
boolean trackingUser = false;

int skip = 10;
int cellSize = 5;
int cellPadding = 2;
int cols, rows;

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

  minThresh = 500;
  maxThresh = 2000;
}

void draw() {
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
        
        float posX = map(x,0,rgbFeed.width,0,width);
        float posY = map(y,0,rgbFeed.height,0,height);

        float r = random(1);
        if (r < 0.25) {
          fill(255);
          ellipse(posX, posY, cellSize*2, cellSize*2);
        } else if (r < .5) {
          fill(255, 0, 0);
          rect(posX, posY, cellSize, cellSize);
        } else if (r < .75) {
          noFill();
          strokeWeight(1);
          stroke(255);
          ellipse(posX, posY, cellSize, cellSize);
        }else{
          
        }
      }
    }
  }
}
