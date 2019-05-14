import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import processing.sound.*;

// Sound Variables
SoundFile sample;

FFT fft;
int bands = 1;
float distortionValue;
float spectrumScaleFactor;
float smoothingFactor;
float[] sum = new float[bands];


//Distorter distorter;
Kinect kinect;

// Declaring Child Applets (SCREENS)
Aux_Screen SCREEN_A, SCREEN_C;
Main_Screen SCREEN_B; 


void settings() {
  size(500, 500, P2D);
  smooth();
}

void setup() {

  kinect = new Kinect(this);
  kinect.initDepth(); 
  kinect.initVideo();
  
  //SCREEN_A = new Aux_Screen(1);
  SCREEN_B = new Main_Screen(2);
  //SCREEN_C = new Aux_Screen(3);

  //Load and play a soundfile and loop it.
  sample = new SoundFile(this, "glitches.mp3");
  fft = new FFT(this, 1);
  distortionValue = 0;
  spectrumScaleFactor = 500;
  smoothingFactor = 0.2;
  sum = new float[bands];
  sample.loop();
  fft.input(sample);

  
}

void draw() {
  
  background(250);
  fft.analyze();
  for (int i = 0; i < bands; i++) {
    float reading = fft.spectrum[i]*spectrumScaleFactor+1;
    float v = reading /10;
    distortionValue = v*v;
  }
}

void mousePressed() {
}

void mouseDragged() {
}
