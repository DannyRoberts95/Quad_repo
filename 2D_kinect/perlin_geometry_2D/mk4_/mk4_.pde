import processing.video.*;
import SimpleOpenNI.*;
//import processing.serial.*;

//KINECT VARS
SimpleOpenNI kinect;
int[] depthMap;
PImage depthFeed, rgbFeed;
int minThresh, maxThresh;
boolean trackingUser = false;

int skip = 4;
int cols, rows;

FlowField flowField;
ArrayList<Particle> particles;
int maxParticleNumber = 2750;
int linkDistance = 50;

void settings() {
  fullScreen(P2D,2);
  //size(1200,1200);
}

void setup() { 
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  //kinect.enableRGB();
  //kinect.enableUser();
  //kinect.setMirror(false);

  flowField = new FlowField(10);
  particles = new ArrayList<Particle>();

  cols = kinect.depthImage().width/ skip;
  rows = kinect.depthImage().height/ skip;

  maxThresh = 1500;
}

void draw() {
  background(0);
  kinect.update();


  if (particles.size() < maxParticleNumber) spawnParticles();

  updateParticles();
  //linkParticles();
  flowField.updateField();
}//END OF DRAW



void spawnParticles() {

  for (int x=0; x< kinect.depthImage().width; x+= skip) {
    for (int y=0; y< kinect.depthImage().height; y+=skip) {

      int offset =  x + y * kinect.depthImage().width;

      float d = kinect.depthMap()[offset];

      float r = random(1);
      if ( d > maxThresh || d == 0 || r > 0.015) continue;


      float posX = map(x, 0, kinect.depthImage().width, 0, width);
      float posY = map(y, 0, kinect.depthImage().height, 0, height);
      //float posX = x*2.25;
      //float posY = y*2.25;

      Particle particle = new Particle(
        posX + random(-skip, skip), 
        posY +random(-skip, skip)
        );
      particles.add(particle);
    }
  }
} // END OF SPAWN PARTICLE

void updateParticles() {
  for (int i = 0; i < particles.size(); i++) {

    if (particles.size() <= 0) continue;

    Particle p = particles.get(i);

    if (p.age > p.lifeSpan) {
      particles.remove(i);
      continue;
    }

    for (int ii = 0; ii < particles.size(); ii++) {     
      Particle p2 = particles.get(ii);
      float d = dist(p.location.x, p.location.y, p2.location.x, p2.location.y);
      if (d > linkDistance || p == p2) continue;
      //float a = map(p.age, 0, p.lifeSpan, 0, 25);
      float range =  map(p.age, 0, p.lifeSpan, 1, 25);
      float a = map(d, 0, linkDistance, 0, range);
      float sw = map(d, 0, linkDistance, 0.1, 1);
      stroke(255, a);
      strokeWeight(sw);
      line(p.location.x, p.location.y, p2.location.x, p2.location.y);
    }

    p.run();
    //p.render();
  }
}//END OF UPDATE PARTICLES

void linkParticles() {
  int connectionDistance = 50;
  for (int i = 0; i < particles.size(); i++) {
    if (particles.size() <= 0) continue;
    Particle p = particles.get(i);
  }
}
