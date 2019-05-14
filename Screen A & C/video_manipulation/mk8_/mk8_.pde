import SimpleOpenNI.*;

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

float randomValue = 10;

void settings() {
  //size(displayHeight, displayHeight);
  fullScreen();
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  imageMode(CENTER);
  rectMode(CENTER);

  captureArray = new ArrayList<PImage>();

  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();

  frameSize = height/2;
}

void draw() {
  randomSeed(1);
  noiseSeed(1);
  background(0);
  kinect.update();

  capture = kinect.rgbImage();
  captureArray.add(capture);

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

      float ox =  map(noise(noffX), 0, 1, -randomValue, randomValue);
      noffX += noffXinc;
      
      float rowAlpha =  map(abs(ox), 0, randomValue,0,100);
      
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
          color c2 = color(random(180), 50, random(65, 100),rowAlpha);
          float lerpAmm = map(abs(ox), 0, randomValue, 0, 1);
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
      randomValue+=10;
      println(randomValue);
    } else if (key == 's' || key == 's') {
      randomValue-=10;
      println(randomValue);
    }
  }
}
