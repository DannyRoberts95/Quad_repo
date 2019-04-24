import processing.sound.*;
import SimpleOpenNI.*;


//Visual Variables
SimpleOpenNI kinect;
PImage capture;

//Sound Variables
// Declare the sound source and FFT analyzer variables
SoundFile sample;
FFT fft;
int bands = 1;
Distorter distorter;

NoiseDistortEffect noiseDistortEffect;


void settings() {
  fullScreen();
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  imageMode(CENTER);
  rectMode(CENTER);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();

  // Load and play a soundfile and loop it.
  //sample = new SoundFile(this, "song.mp3");
  sample = new SoundFile(this, "glitches.mp3");
  fft = new FFT(this, 1);
  distorter = new Distorter(sample, fft, 500);
  
  noiseDistortEffect = new NoiseDistortEffect();

}

void draw() {
  background(0);

  distorter.run();
  kinect.update();
  capture = kinect.rgbImage();
  
  noiseDistortEffect.run();
  //image(capture,width/2,height/2);
}

void keyPressed() {
  if (key == CODED) {
    
  } else if (keyPressed) {
    if (key == 'w' || key == 'W') {
      distorter.spectrumScaleFactor+=50;
    } else if (key == 's' || key == 's') {
      distorter.spectrumScaleFactor-=50;
    }
  }
}
