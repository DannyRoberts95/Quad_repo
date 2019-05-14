import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import processing.video.*;
import SimpleOpenNI.*;
import milchreis.imageprocessing.*;

Capture video;

void settings() {
  size(640, 480);
}

void setup() {
  video = new Capture(this, 640, 480, 30);
  video.start();
  //printArray(Capture.list());
}

void draw() {
  background(0);
 
  if (video.available()) {
    video.read();
  }

  image(Glitch.apply(video,5), 0, 0);
  
  
}
