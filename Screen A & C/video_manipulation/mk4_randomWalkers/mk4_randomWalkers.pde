import SimpleOpenNI.*;

ArrayList<Walker> walkers;
int pop = 10000;

SimpleOpenNI kinect;
PImage capture;
int res = 20;
int cols;
int rows;

int maxThresh = 1500;

void settings() {
  //fullScreen(P2D);
  size(displayHeight,displayHeight);
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);
  background(0);

  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
  kinect.enableDepth();

  cols = width/ res;
  rows = height/ res;

  walkers = new ArrayList<Walker>();
  for (int i = 0; i<pop; i++) {
    walkers.add(new Walker(
      random(width), 
      random(height), 
      random(0.5,1), 
      random(5,25)));
  }
}

void draw() {
  fill(0, 15);
  noStroke();
  rect(0, 0, width*2, height*2);
  kinect.update();
  capture = kinect.rgbImage();
  capture.loadPixels();
  for (int i = walkers.size()-1; i > 0; i--) {
    Walker w = walkers.get(i);
    w.run();
  }
}
