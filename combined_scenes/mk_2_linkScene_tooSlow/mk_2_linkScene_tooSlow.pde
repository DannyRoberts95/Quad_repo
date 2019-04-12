import processing.sound.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

SoundFile soundScape;
FFT fft;
DistortManager distortManager;

Scene currentScene;


//shouldnt be here but won't work otherwise
FlowField flow;


void settings() {
  fullScreen();
}

void setup() {
  kinect = new SimpleOpenNI(this);

  soundScape = new SoundFile(this, "glitches.mp3");
  //soundScape = new SoundFile(this, "song.mp3");
  fft = new FFT(this, 1);
  distortManager = new DistortManager(soundScape, fft, 500);

  flow = new FlowField(10);    

  currentScene = new VideoScene();
  currentScene = new LinkScene();
}

void draw() {

  if (frameCount%10==0)println(frameRate);
  distortManager.run();
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

      if (currentScene instanceof VideoScene) {
        currentScene = new LinkScene();
      } else if (currentScene instanceof LinkScene) {
        currentScene = new VideoScene();
      }
    }
  }
}
