import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import processing.video.*;

//Capture video;

Kinect kinect;
PImage kinectImg;
float deg;

PImage img;       // The source image
int cellsize = 4;
float cellpad = 0;
int columns, rows;   // Number of columns and rows in our system
float aor;

void setup() { 
  fullScreen(P3D);
  kinectSetup();
  img = kinect.getVideoImage();
  //img = loadImage("kells.jpg"); 
  columns = img.width / cellsize;  
  rows = img.height / cellsize;
}

void draw() {

  //displayDebug();
  background(255);

  //cellpad = abs(map(mouseX, 0, width, -0, 10));

  float tX = width-(width-img.width)/2;
  float tY = height-(height-img.height)/2;
  float tZ = -tY/2;

  translate(tX, tY, tZ);

  //translate to the img center, rotate it, then translate back
  translate(-img.width/2, 0);
  rotateY(aor);
  translate(img.width/2, 0);

  //translate(-img.width/2-(cellpad*rows), 0);
  translate(-img.width, -img.height);
  for ( int i = 0; i < columns; i++) {
    for ( int j = 0; j < rows; j++) {
      int x = i*cellsize + cellsize/2;  
      int y = j*cellsize + cellsize/2;  
      int loc = x + y*img.width;

      //img.set(x, y, int(brightness(img.pixels[loc])));

      color c = img.pixels[loc];

      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (mouseX / float(width/2)) * brightness(img.pixels[loc]) - 20.0;

      //only if pixels are set to black and white
      //float zMap = map(img.pixels[loc], 0, 255, 0, tZ);
      //float z = map(mouseX, 0, width, -zMap, zMap);

      x += cellpad*i;
      y += cellpad*j;

      //float z = map(mouseY, 0, height, -int(brightness(img.pixels[loc])), int(brightness(img.pixels[loc])));

      pushMatrix();
      translate(x, y, z);
      fill(c, 200);
      noStroke();
      rectMode(CENTER);
      //rect(0, 0, cellsize, cellsize);
      box(cellsize, cellsize, max(abs(z), 10));
      //box(cellsize, cellsize, 10);
      translate(-cellpad, -cellpad, 0);
      popMatrix();
    }
  }
  aor += 0.01;
  if (aor > 360) {
    aor*=0;
  }
}
void keyPressed() {
  adjustKinectTilt();
}
