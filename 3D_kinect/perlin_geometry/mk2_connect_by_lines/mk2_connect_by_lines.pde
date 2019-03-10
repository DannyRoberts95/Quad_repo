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

float particleSpawnChance = 0.025;

Kinect kinect;

float rotY = radians(0);

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
  
  //rotateY(rotY);
  //rotY += 0.1f;
  
  flowField.updateField();
  
  
  //SPAWNING THE PERLIN PARTICLES
  int[] depth = kinect.getRawDepth();
  for (int x = 0; x < kinect.width; x += skip) {
    for (int y = 0; y < kinect.height; y += skip) {
      int offset = x + y * kinect.width;
      int z = depth[offset];
      float r = random(1);
      if (z > maxDepth || z == 0 || r > particleSpawnChance) continue;
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
    Particle p = particles.get(i);
    if (p.age > p.lifeSpan) {
      particles.remove(i);
      continue;
    }
    for (int ii = 0; ii < particles.size(); ii++) {     
      Particle p2 = particles.get(ii);
      float d = dist(p.location.x,p.location.y,p.location.z,p2.location.x, p2.location.y,p2.location.z);
      if(d > 35 || p == p2) continue;
      float a = map(p.age,0,p.lifeSpan,0,25);
      stroke(255,a);
      strokeWeight(1);
      line(p.location.x,p.location.y,p.location.z,p2.location.x, p2.location.y,p2.location.z);
    }
    p.update();
    //p.render();
    
  }

  //DRAWING THE POINTS FROM THE POINT CLOUD
  //for (int x = 0; x < kinect.width; x += skip2) {
  //  for (int y = 0; y < kinect.height; y += skip2) {
  //    int offset = x + y * kinect.width;
  //    int z = depth[offset];
  //    if (z > maxDepth || z == 0) {
  //      continue;
  //    }

  //    float posX = map(x, 0, kinect.width, 0, width);
  //    float posY = map(y, 0, kinect.height, 0, height);

  //    stroke(255,10);
  //    strokeWeight(1);
  //    point(
  //      posX + random(-1, 1), 
  //      posY + random(-1, 1), 
  //      subtractZ - z
  //      );
  //  }
  //}
}
