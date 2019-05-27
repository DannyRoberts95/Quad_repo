import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import processing.sound.*;

//fullscreen
// false = 3 900x900px sketchs
// true = 3 fullscreen sketchs on each display
boolean FS = true;

// Sound Variables
SoundFile sample;

FFT fft;
int bands = 1;
float distortionValue;
float spectrumScaleFactor;
float smoothingFactor;
float[] sum = new float[bands];

color[] cols = new color[5];

int[] stageTiming = new int[11];

PImage[] displayImages;

//Distorter distorter;
Kinect kinect;

// Declaring Child Applets (SCREENS)
Aux_Screen SCREEN_A, SCREEN_C;
Main_Screen SCREEN_B; 

int stageNumber = 0;

void settings() {
  size(500, 500, P2D);
  smooth();
}

void setup() {

  colorMode(HSB, 360, 100, 100, 100);

  kinect = new Kinect(this);
  kinect.initDepth(); 
  kinect.initVideo();

  //sample = new SoundFile(this, "glitches.mp3");
  sample = new SoundFile(this, "scape.wav");

  //sample = new SoundFile(this, "scape_10.wav");

  //load the displayImages
  displayImages = new PImage[91];
  for (int i =0; i<displayImages.length; i ++) {
    displayImages[i] = loadImage("data/images/"+i+".png");
  }

  // crete the FFT analyser object 
  fft = new FFT(this, 1);
  distortionValue = 0;
  spectrumScaleFactor = 2500;
  smoothingFactor = 0.2;
  sum = new float[bands];
  sample.loop();
  fft.input(sample);

  //Colors
  cols[0]=color(0, 0, 100);
  cols[1]=color(285, 15, 90);
  cols[2]=color(328, 100, 100, 100);
  cols[3]= color(285, 48, 100, 100);
  cols[4]=color(175, 75, 100, 100);

  stageTiming[0] = 20500;
  stageTiming[1] = 39500;
  stageTiming[2] = 50500;
  stageTiming[3] = 62000;
  stageTiming[4] = 66000;
  stageTiming[5] = 80000;
  stageTiming[6] = 104000;
  stageTiming[7] = 123000;
  stageTiming[8] = 145000;
  stageTiming[9] = 166000;
  stageTiming[10] = 176500;


  // NUMBERS IN BRACKETS CORRESPOND TO THE SCREEN THE SKECTH WILL DISPLAY ON
  //SCREEN_A = new Aux_Screen(1); // screen 1  
  SCREEN_B = new Main_Screen(1); // screen 2
  //SCREEN_C = new Aux_Screen(3); // screen 3
}

void draw() {

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

  int m = millis() % 186000;
  println(m);
  if (m < 20500) {
    stageNumber=0;
  }
  if (m > 20500) {
    stageNumber=1;
  }  
  if (m > 39500) {
    stageNumber=2;
  }  
  if (m > 50500) {
    stageNumber=3;
  }  
  if (m > 62000) {
    stageNumber=4;
  }  
  if (m > 66000) {
    stageNumber=5;
  }  
  if (m > 80000) {
    stageNumber=6;
  }  
  if (m > 104000) {
    stageNumber=7;
  }  
  if (m > 123000) {
    stageNumber=8;
  }  
  if (m > 145000) {
    stageNumber=9;
  }  
  if (m >166000) {
    stageNumber=10;
  }  
  if (m > 176500) {
    stageNumber=11;
  }
}
