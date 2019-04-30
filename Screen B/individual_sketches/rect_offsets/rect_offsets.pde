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
int cellSize = 8;
int cellPadding = 2;
int cols, rows;
PVector [][] forceField;

float amp = 1;
float noiseOffX = random(1000);
float noiseOffY = random(1000);
float noiseOffZ = random(1000);
float xInc = 0.00005;
float yInc = 0.00005;
float zInc = 0.00005;

void settings() {
  fullScreen(P2D);
  //size(1200,1200);
}

void setup() { 
  colorMode(HSB,360,100,100,100);
    
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser();
  kinect.setMirror(false);

  cols = kinect.depthImage().height/ skip;
  rows = kinect.depthImage().width/ skip;
  
  forceField = new PVector[rows][cols];

  for (int i=0; i<rows; i++) {
    for (int ii=0; ii<cols; ii++) {
      float theta = map(noise(noiseOffX, noiseOffY, noiseOffZ), 0, 1, 0, 360);
      PVector a = PVector.fromAngle(degrees(theta));
      a.normalize();
      a.mult(amp);
      forceField[i][ii] = a;
      noiseOffX += xInc;
    }
    noiseOffY += yInc;
  }
  noiseOffZ += zInc;

  minThresh = 500;
  maxThresh = 1250;
}

void draw() {
  //noiseSeed(100);
  background(0);
  kinect.update();

  amp = map(mouseX, 0, width, 0, 100);

  for (int i=0; i<rows; i++) {
    
    for (int ii=0; ii<cols; ii++) {
      float theta = map(noise(noiseOffX, noiseOffY, noiseOffZ), 0, 1, 0, 360);
      PVector a = PVector.fromAngle(degrees(theta));
      a.normalize();
      a.mult(amp);
      forceField[i][ii] = a;
      noiseOffX += xInc;
    }
    noiseOffY += yInc;
  }
  noiseOffZ += zInc;
  
  renderDistortedImage();
  
}//END OF DRAW



void renderDistortedImage() {

  for (int i=0; i<rows; i++) {
    //if(random(1)< 0.025) continue;
    for (int ii=0; ii<cols; ii++) {
      if(random(1)< 0.025) continue;
      
      int x = i*(skip);
      int y = ii*(skip);

      int offset =  x + y * kinect.depthImage().width;

      float d = kinect.depthMap()[offset];
      if (d > minThresh && d < maxThresh) {

        float h = hue(kinect.rgbImage().pixels[offset]);
        float s = saturation(kinect.rgbImage().pixels[offset]);
        float b = brightness(kinect.rgbImage().pixels[offset]);

        float posX = map(x, 0, kinect.depthImage().width, 0, width);
        float posY = map(y, 0, kinect.depthImage().height, 0, height);

        float xOffset = forceField[i][ii].x;
        float yOffset = forceField[i][ii].y;

        float rad = cellSize;
        
        float mag = forceField[i][ii].mag();

        noStroke();
        if (mag > amp*0.75) {
          noFill();
          stroke(h, s, b);
          strokeWeight(1);
          rect(posX+xOffset, posY+yOffset, rad, rad);
        } 
        else {
          fill(h, s, b);
          rect(posX+xOffset, posY+yOffset, rad, rad);
        }
      }
    }
  }
}
