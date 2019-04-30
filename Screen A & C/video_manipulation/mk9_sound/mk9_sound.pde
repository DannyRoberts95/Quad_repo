import processing.sound.*;
import SimpleOpenNI.*;


//Visual Variables
SimpleOpenNI kinect;
PImage capture;
ArrayList<PImage> captureArray;
int maxFrames = 1;
float frameSize;
float res = 5;
int cols;
int rows;
float noffX = random(10000);
float noffXinc = 0.05;
float distortionValue = 10;

//Sound Variables
// Declare the sound source and FFT analyzer variables
SoundFile sample;
FFT fft;
// Define how many FFT bands to use (this needs to be a power of two)
int bands = 1;
float spectrumScaleFactor = 1000;
float smoothingFactor = 1;
// Create a vector to store the smoothed spectrum data in
float[] sum = new float[bands];



void settings() {
  fullScreen();
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  imageMode(CENTER);
  rectMode(CENTER);

  captureArray = new ArrayList<PImage>();
  frameSize = height/2;

  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();

  // Load and play a soundfile and loop it.
  sample = new SoundFile(this, "song.mp3");
  sample.loop();
  
   // Create the FFT analyzer and connect the playing soundfile to it.
  fft = new FFT(this, bands);
  fft.input(sample);
}

void draw() {
  background(0);
  
   // Perform the analysis
  fft.analyze();
  
   for (int i = 0; i < bands; i++) {
    // Smooth the FFT spectrum data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
    //println(sum[i]);
    //distortionValue += fft.spectrum[i] - distortionValue;
    distortionValue = fft.spectrum[i]*spectrumScaleFactor;
    println(distortionValue );
  }
  
  kinect.update();
  capture = kinect.rgbImage();
  captureArray.add(capture);
  
  randomSeed(1);
  noiseSeed(1);
  for (int i = captureArray.size()-1; i > 0; i--) {
    PImage c = captureArray.get(i);
    c.loadPixels();

    float frameW = map(i, 0, maxFrames, frameSize, height/2);
    float frameH = map(i, 0, maxFrames, frameSize, height/2);

    cols = floor(frameW/ res);
    rows = floor(frameH/ res);

    float xMargin = cols*res/2;
    float yMargin = rows*res/2;

    pushMatrix();
    translate(width/2, height/2);

    for (int ii = 0; ii<rows; ii++) {

      float ox =  map(noise(noffX), 0, 1, -distortionValue, distortionValue);
      noffX += noffXinc;

      float rowAlpha =  map(abs(ox), 0, distortionValue, 0, 100);

      if (50 < (ox)) continue;

      for (int iii =0; iii<cols; iii++) {

        float x = iii * (res);
        float y = ii * (res);

        int pixelX = floor(map(x, 0, frameW, 0, capture.width));
        int pixelY = floor(map(y, 0, frameH, 0, capture.height));

        color col = capture.get(pixelX, pixelY);
        float renderSize = res;

        if (15 < ox) {
          color c1 = capture.get(pixelX, pixelY);
          color c2 = color(random(180), 50, random(65, 100), rowAlpha);
          float lerpAmm = map(abs(ox), 0, distortionValue, 0, 1);
          col = lerpColor(c1, c2, lerpAmm);

          renderSize = random(res*4, res*4);
        }

        pushMatrix();
        translate(-xMargin, -yMargin);
        translate((x+res/2), (y+res/2));
        translate(ox, 0);
        noStroke();
        //fill(hue(c1), saturation(c1), brightness(c1), 75);
        fill(col);
        rect(0, 0, renderSize, renderSize);
        popMatrix();
      }
    }
    popMatrix();
  }

  while (captureArray.size() > maxFrames) {
    captureArray.remove(captureArray.size()-1);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      noffXinc += 0.1;
      println(noffXinc);
    } else if (keyCode == DOWN) {
      noffXinc -= 0.1;
      println(noffXinc);
    } else if (keyCode == RIGHT) {
      res += 1;
      res = constrain(res, 1, 100);
    } else if (keyCode == LEFT) {
      res -= 1;
      res = constrain(res, 1, 100);
    }
  } else if (keyPressed) {
    if (key == 'w' || key == 'W') {
      spectrumScaleFactor+=50;
      println(distortionValue);
    } else if (key == 's' || key == 's') {
      spectrumScaleFactor-=50;
      println(distortionValue);
    }
  }
}
