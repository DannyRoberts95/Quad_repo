import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

FlowField           flowField;
ArrayList<Particle> particles;

float skip = 4;
float skip2 = skip/2;

float zTranslate = 1100;
float xPadding = 0;
float maxDepth = 900;
float subtractZ = 0;

color col = color(255);
color particleCol = color(255);

Kinect kinect;

void setup() {
  fullScreen(P3D);
  //size(1200,1200,P3D);
  background(0);
  flowField = new FlowField(10);
  particles = new ArrayList<Particle>();
  
  
  kinect = new Kinect(this);
  kinect.initDepth();
}

void draw() {
  translate(
    xPadding, 
    0, 
    zTranslate
    );

  background(0);
  flowField.updateField();
  
  
  //SPAWNING THE PERLIN PARTICLES
  int[] depth = kinect.getRawDepth();
  for (int x = 0; x < kinect.width; x += skip) {
    for (int y = 0; y < kinect.height; y += skip) {
      int offset = x + y * kinect.width;
      int z = depth[offset];
      float r = random(1);
      if (z > maxDepth || z == 0 || r < 0.5) {
        continue;
      }

      float posX = map(x, 0, kinect.width, 0, width);
      float posY = map(y, 0, kinect.height, 0, height);

      Particle particle = new Particle(
        posX, 
        posY, 
        subtractZ - z, 
        particleCol
        );
      particles.add(particle);
    }
  }
  //UPDATING THE PERLIN NOISE PARTICLES 
  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).update();
    particles.get(i).render();
    if (particles.get(i).age > particles.get(i).lifeSpan) {
      particles.remove(i);
    }
  }

  //DRAWING THE POINTS FROM THE POINT CLOUD
  for (int x = 0; x < kinect.width; x += skip2) {
    for (int y = 0; y < kinect.height; y += skip2) {
      int offset = x + y * kinect.width;
      int z = depth[offset];
      if (z > maxDepth || z == 0) {
        continue;
      }

      float posX = map(x, 0, kinect.width, 0, width);
      float posY = map(y, 0, kinect.height, 0, height);

      stroke(col);
      strokeWeight(2);
      point(
        posX + random(-1, 1), 
        posY + random(-1, 1), 
        subtractZ - z
        );
    }
  }
}
