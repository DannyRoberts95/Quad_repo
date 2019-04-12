import processing.sound.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

SoundFile soundScape;
FFT fft;
DistortManager distortManager;

Scene currentScene;

//FlowField flowField;


void settings() {
  fullScreen();
}

void setup() {
  kinect = new SimpleOpenNI(this);

  ////soundScape = new SoundFile(this, "glitches.mp3");
  //soundScape = new SoundFile(this, "song.mp3");
  //fft = new FFT(this, 1);
  //distortManager = new DistortManager(soundScape, fft, 500);

  //currentScene = new VideoScene();
  currentScene = new LinkScene();
}

void draw() {
  //distortManager.run();
  currentScene.runScene();
  }

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
    } else if (keyCode == DOWN) {
    }
  } else if (keyPressed) {
    if (key == 'w' || key == 'W') {
    } else if (key == 's' || key == 's') {
    }
  }
}
