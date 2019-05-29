import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import processing.sound.*;

//fullscreen
// false = 3 900x900px sketchs
// true = 3 fullscreen sketchs on each display
boolean FS = false;

float playbackSpeed = 1;

// Sound Variables
SoundFile sample;

FFT fft;
int bands = 1;
float distortionValue;
float spectrumScaleFactor;
float smoothingFactor;
float[] sum = new float[bands];

color[] cols = new color[5];

float m;
float startUpTime = 0;

PImage[] displayImages;
PImage blueScreen;

Kinect kinect;
int kinectTiltAngle = 17;

// Declaring Child Applets (SCREENS)
RGB_Screen SCREEN_A, SCREEN_C;
Depth_Screen SCREEN_B; 

int stageNumber = 0;

float minThresh = 0;
//float maxThresh = 925;
float maxThresh = 725;
  int glitchValueCap = 3000;


void settings() {
  size(500, 500, P2D);
  smooth();
}

void setup() {

  colorMode(HSB, 360, 100, 100, 100);

  kinect = new Kinect(this);
  kinect.initDepth(); 
  kinect.initVideo();

  //Load the sound assets
  sample = new SoundFile(this, "soundscape/scape.wav");

  //load the Image Assets
  displayImages = new PImage[142];
  for (int i =0; i<displayImages.length; i ++) {
    displayImages[i] = loadImage("data/images/"+i+".png");
  }

  blueScreen = loadImage("data/blueScreen.png");

  // crete the FFT analyser object 
  fft = new FFT(this, 1);
  distortionValue = 0;
  spectrumScaleFactor = 0;
  smoothingFactor = 0.2;
  sum = new float[bands];
  sample.loop();

  //comment me out 
  sample.rate(playbackSpeed);

  fft.input(sample);

  //Colors
  cols[0]=color(0, 0, 100);
  cols[1]=color(285, 15, 90);
  cols[2]=color(328, 100, 100, 100);
  cols[3]= color(285, 48, 100, 100);
  cols[4]=color(175, 75, 100, 100);

  // NUMBERS IN BRACKETS CORRESPOND TO THE SCREEN THE SKECTH WILL DISPLAY ON
  //SCREEN_A = new Camera_Screen(1); // screen 1  
   SCREEN_A = new RGB_Screen(1); // screen 1  
  //SCREEN_B = new Depth_Screen(1); // screen 2
  //SCREEN_C = new Camera_Screen(3); // screen 3

  startUpTime = millis();
  println("PROGRAM START UP TIME: " + startUpTime);
}

void draw() {

  //println(millis());

  background(cols[0]);
  fill(0, 0, 0);
  text(stageNumber, 25, 25);
  text(distortionValue, 25, 50);
  text(spectrumScaleFactor, 25, 75);

  fft.analyze();
  for (int i = 0; i < bands; i++) {
    float reading = fft.spectrum[i]*spectrumScaleFactor+1;
    float v = reading / 5;
    distortionValue = v*v;
  }

  m = (millis() - startUpTime) % 186903;

  //println(m);
  if (m < 20500) {
    stageNumber=0;
    spectrumScaleFactor = 450;
  }
  if (m > 20500) {
    stageNumber=1;
    spectrumScaleFactor = 550;
  }  
  if (m > 39300) {
    stageNumber=2;
    spectrumScaleFactor = 750;
  }  
  if (m > 46300) {
    stageNumber=3;
    spectrumScaleFactor = 1050;
  }  
  if (m > 50500) {
    spectrumScaleFactor = 1250;
    stageNumber=4;
  }  
  if (m > 62100) {
    spectrumScaleFactor = 750;
    stageNumber=5;
  }  
  if (m > 66350) {
    spectrumScaleFactor = 1150;
    stageNumber=6;
  }  
  if (m > 74900) {
    spectrumScaleFactor = 1650;
    stageNumber=7;
  }  
  if (m > 86500) {
    spectrumScaleFactor = 1950;
    stageNumber=8;
  }  
  if (m > 105950) {
    spectrumScaleFactor = 550;
    stageNumber=9;
  }  
  if (m >115740) {
    spectrumScaleFactor = 1750;
    stageNumber=10;
  }  
  if (m > 123150) {
    spectrumScaleFactor = 850;
    stageNumber=11;
  }
  if (m > 128830) {
    spectrumScaleFactor = 750;
    stageNumber=12;
  }
  if (m > 146750) {
    spectrumScaleFactor = 1250;
    stageNumber=13;
  }
  if (m > 154690) {
    spectrumScaleFactor = 1850;
    stageNumber=14;
  }
  if (m > 163520) {
    spectrumScaleFactor = 2500;
    stageNumber=15;
  }
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      kinectTiltAngle++;
    } else if (keyCode == DOWN) {
      kinectTiltAngle--;
    }
    kinectTiltAngle = constrain(kinectTiltAngle, 0, 30);
    println(kinectTiltAngle);
    kinect.setTilt(kinectTiltAngle);
  }
}
