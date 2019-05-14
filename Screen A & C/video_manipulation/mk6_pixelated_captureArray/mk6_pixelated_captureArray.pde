import SimpleOpenNI.*;

SimpleOpenNI kinect;
PImage capture;
ArrayList<PImage> captureArray;
int maxFrames = 1;

float frameSize = 100;

int res = 10;
float padding = 0;
int cols;
int rows;

float aor = 0;

float randomValue = 0;

void settings() {
  //size(displayHeight, displayHeight);
  fullScreen();
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  imageMode(CENTER);
  rectMode(CENTER);
  blendMode(BLEND);
  captureArray = new ArrayList<PImage>();
  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
}

void draw() {
  randomSeed(1);
  background(0);
  kinect.update();
  capture = kinect.rgbImage();
  captureArray.add(capture);

  padding = floor(map(mouseX, 0, width, 1, 10));

  for (int i = captureArray.size()-1; i > 0; i--) {
    
      //padding = i * randomValue;

    PImage c = captureArray.get(i);

    float frameW = map(i, 0, maxFrames, frameSize, height/2);
    float frameH = map(i, 0, maxFrames, frameSize, height/2);

    cols = floor(frameW/ res);
    rows = floor(frameH/ res);

    float xMargin = cols*(res)/2;
    float yMargin = rows*(res)/2;

    pushMatrix();
    translate(width/2, height/2);

    //rotate(radians(aor*i));
    translate(-padding*cols/2, -padding*rows/2);


    c.loadPixels();

    for (int ii = 0; ii<cols; ii++) {
      for (int iii =0; iii<rows; iii++) {


        float x = ii * (res);
        float y = iii * (res);

        int pixelX = floor(map(x, 0, frameW, 0, capture.width));
        int pixelY = floor(map(y, 0, frameH, 0, capture.height));

        x += padding*ii;
        y += padding*iii;

        color col = capture.get(pixelX, pixelY);

        float r = random(100);

        //if(r < randomValue) continue;

        pushMatrix();
        translate(-xMargin, -yMargin);
        translate((x+res/2), (y+res/2));
        if(r < randomValue) rotate(random(-randomValue, randomValue));
        
        noStroke();

        float offsetX = random(-randomValue, randomValue);
        float offsetY = random(-randomValue, randomValue);
        
        fill(hue(col), saturation(col), brightness(col), 100-i*5);
        rect(offsetX, offsetY, res, res);

        popMatrix();
      }
    }
    popMatrix();
    aor += 0.025;
  }

  while (captureArray.size() > maxFrames) {
    captureArray.remove(captureArray.size()-1);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      maxFrames ++;
      maxFrames = constrain(maxFrames, 1, 10);
      println(maxFrames);
    } else if (keyCode == DOWN) {
      maxFrames --;
      maxFrames = constrain(maxFrames, 1, 10);
      println(maxFrames);
    } else if (keyCode == RIGHT) {
      res += 5;
      res = constrain(res, 5, 100);
    } else if (keyCode == LEFT) {
      res -= 5;
      res = constrain(res, 5, 100);
    }
  } else if (keyPressed) {
    if (key == 'w' || key == 'W') {
      randomValue+=5;
      println(randomValue);
    } else if (key == 's' || key == 's') {
      randomValue-=5;
      println(randomValue);
    }
  }
}
