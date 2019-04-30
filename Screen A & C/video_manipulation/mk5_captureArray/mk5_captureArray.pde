import SimpleOpenNI.*;

SimpleOpenNI kinect;
PImage capture;
ArrayList<PImage> captureArray;


void settings() {
  size(displayHeight, displayHeight, P2D);
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  imageMode(CENTER);
  blendMode(DIFFERENCE);
  captureArray = new ArrayList<PImage>();
  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
}

void draw() {
  kinect.update();
  capture = kinect.rgbImage();

  captureArray.add(capture);

  int maxFrames = 20;
  float dec = 0.90;
  for (int i = captureArray.size()-1; i > 0; i--) {
    PImage c = captureArray.get(i);
    float w = map(i, 0, maxFrames, 10, width*1.25);
    float h = map(i, 0, maxFrames, 10, height*1.25);
    pushMatrix();
    translate(width/2, height/2);  
    rotate(radians(5*i));
    tint(i*10, 100, 100, 75);
    image(c, 0, 0, w, h);    
    popMatrix();
  }
  if (captureArray.size() > maxFrames) {
    captureArray.remove(captureArray.size()-1);
  }

  println(captureArray.size());
}
