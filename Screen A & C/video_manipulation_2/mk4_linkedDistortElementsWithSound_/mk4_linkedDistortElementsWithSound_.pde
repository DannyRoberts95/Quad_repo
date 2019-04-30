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

//Scene Vars
int sceneNumber = 2;
NoiseDistortEffect noiseDistortEffect;
ElementDistortEffect elementDistortEffect;


void settings() {
  fullScreen();
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  background(0);  
  imageMode(CENTER);
  rectMode(CENTER);

  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
  capture = kinect.rgbImage();

  // Load and play a soundfile and loop it.
  sample = new SoundFile(this, "song.mp3");
  //sample = new SoundFile(this, "glitches.mp3");
  fft = new FFT(this, 1);
  distorter = new Distorter(sample, fft, 500);

  noiseDistortEffect = new NoiseDistortEffect();
  elementDistortEffect = new ElementDistortEffect();
}

void draw() {

  
  distorter.run();
  kinect.update();
  capture = kinect.rgbImage();

//println(distorter.distortionValue);

  if (sceneNumber == 0) {
    image(capture, width/2, height/2);
  } else if (sceneNumber == 1) {
    noiseDistortEffect.run();
  } else if (sceneNumber == 2) {
    elementDistortEffect.run();
  }
}

int r(int a) {
  return int(random(a));
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      background(0);
      sceneNumber++;
      println(sceneNumber);
    } else if (keyCode == DOWN) {
      background(0);
      sceneNumber--;
      println(sceneNumber);
    }
  }

  if (key == 'w' || key == 'W') {
    distorter.spectrumScaleFactor+=50;
    println(distorter.spectrumScaleFactor);
  } else if (key == 's' || key == 's') {
    distorter.spectrumScaleFactor-=50;
    println(distorter.spectrumScaleFactor);
  }
}
