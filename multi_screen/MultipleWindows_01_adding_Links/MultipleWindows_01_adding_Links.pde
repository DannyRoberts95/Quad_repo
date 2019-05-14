// Sound Variables
SoundFile sample;
FFT fft;
int bands = 1;
Distorter distorter;

// Kinect Variables
SimpleOpenNI kinect;

//Still shouldn't be here...
FlowField flow;

// Declaring Child Applets
Video_Distortion video_distortion, video_distortion2;
Links links;

void settings() {
  size(500, 500, P3D);
  smooth();
}
import processing.sound.*;
import SimpleOpenNI.*;

void setup() {
  //surface.setTitle("Primary sketch");

  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
  kinect.enableDepth();


   //Load and play a soundfile and loop it.
  sample = new SoundFile(this, "song.mp3");
  fft = new FFT(this, 1);
  distorter = new Distorter(sample, fft, 500);
  
  
  

  //Video_Distortion applet object
  video_distortion = new Video_Distortion(1);
  //video_distortion2 = new Video_Distortion(2);
  links = new Links(1);
}

void draw() {
  background(250);
  //distorter.run();
  kinect.update();

  background(0);
  fill(255);
  text(frameRate, 25, 25);
}

void mousePressed() {
}

void mouseDragged() {
}
