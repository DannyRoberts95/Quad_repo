import processing.sound.*;
import SimpleOpenNI.*;

// Sound Variables
SoundFile sample;
FFT fft;
int bands = 1;
float distortionValue;
float spectrumScaleFactor;
float smoothingFactor;
float[] sum = new float[bands];


//Distorter distorter;

// Kinect Variables
SimpleOpenNI kinect;
// Declaring Child Applets
Element_Distortion video_distortion, video_distortion2;

void settings() {
  size(500, 500, P3D);
  smooth();
}

void setup() {
  //surface.setTitle("Primary sketch");

  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
  kinect.enableDepth();


  //Load and play a soundfile and loop it.
  sample = new SoundFile(this, "song.mp3");
  fft = new FFT(this, 1);
  //distorter = new Distorter(sample, fft, 500);

  distortionValue = 0;


  spectrumScaleFactor = 500;
  smoothingFactor = 0.2;
  sum = new float[bands];
  sample.loop();
  fft.input(sample);




  //Video_Distortion applet object
  video_distortion = new Element_Distortion();
  //video_distortion2 = new Element_Distortion();
}

void draw() {
  background(250);

  kinect.update();


  fft.analyze();
  for (int i = 0; i < bands; i++) {
    distortionValue = fft.spectrum[i]*spectrumScaleFactor+1;
  }
}

void mousePressed() {
}

void mouseDragged() {
}
