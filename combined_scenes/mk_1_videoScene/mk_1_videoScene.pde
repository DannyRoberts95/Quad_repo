import processing.sound.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

SoundFile soundScape;
FFT fft;
DistortManager distortManager;

Scene currentScene;

void settings() {
  fullScreen();
}

void setup() {
  kinect = new SimpleOpenNI(this);
  
  soundScape = new SoundFile(this, "song.mp3");
  fft = new FFT(this, 1);
  distortManager = new DistortManager(soundScape, fft, 500);
  
  currentScene = new VideoScene();
}

void draw() {
  distortManager.run();
  currentScene.runScene();
}
