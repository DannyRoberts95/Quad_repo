class Threshold_Image {
  float minThresh = 550;
  float maxThresh = 775;
  float a;
  PImage img;

  Threshold_Image() {
    imageMode(CENTER);
    img = createImage(kinect.width, kinect.height, HSB);
  }

  void run() {
    background(0);
    img.loadPixels();

    //minThresh = map(mouseX,0,width, 0, 2048);
    //maxThresh = map(mouseY,0,height, 0, 2048);

    int[] depth = kinect.getRawDepth();
    int skip = 1;
    for (int x = 0; x < kinect.width; x += skip) {
      for (int y = 0; y < kinect.height; y += skip) {
        int offset = x + y * kinect.width;
        int d = depth[offset];

        if (d > minThresh && d < maxThresh) {
          img.pixels[offset] = color(random(255), random(255), random(255));
        } else {
          img.pixels[offset] = color(0);
        }
      }
    }
    img.updatePixels();
    image(img, width/2, height/2, width, height);


    fill(255);
    textSize(12);
    text(minThresh, 20, 20);
    text(maxThresh, 20, 40);
  }
}
