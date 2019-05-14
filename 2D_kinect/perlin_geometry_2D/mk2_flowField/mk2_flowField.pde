import processing.video.*;
import SimpleOpenNI.*;
import processing.serial.*;

//KINECT VARS
SimpleOpenNI kinect;
int[] depthMap;
PImage depthFeed, rgbFeed;
int minThresh, maxThresh;
boolean trackingUser = false;

int skip = 5;
int cellSize = 5;
int cellPadding = 2;
int cols, rows;

FlowField flowField;
ArrayList<Particle> particles;

void settings() {
  fullScreen(P2D);
  //size(1200,1200);
}

void setup() { 
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser();
  kinect.setMirror(false);

  flowField = new FlowField(10);
  particles = new ArrayList<Particle>();

  cols = kinect.depthImage().width/ skip;
  rows = kinect.depthImage().height/ skip;
  
  maxThresh = 1500;
}

void draw() {
  randomSeed(1);
  background(0);
  kinect.update();
  
  spawnParticles();
  updateParticles();
  flowField.updateField();
  
  println(particles.size());
}//END OF DRAW



void spawnParticles() {

  for (int i=0; i<cols; i++) {
    for (int ii=0; ii<rows; ii++) {

      int x = i*(skip);
      int y = ii*(skip);

      int offset =  x + y * kinect.depthImage().width;

      float d = kinect.depthMap()[offset];

      float r = random(1);
      if ( d < maxThresh || d == 0 || r > 0.025) continue;

      float posX = map(x, 0, kinect.depthImage().width, 0, width);
      float posY = map(y, 0, kinect.depthImage().height, 0, height);

      Particle particle = new Particle(
        posX, 
        posY
        );
      particles.add(particle);
    }
  }
} // END OF SPAWN PARTICLE

void updateParticles() {
  for (int i = particles.size()-1; i < 0; i--) {
    
    if (particles.size() <= 0) continue;
    
    Particle p = particles.get(i);

    if (p.age > p.lifeSpan) {
      particles.remove(i);
    }else {
      p.update();
      p.render();
    }

    for (int ii = 0; ii < particles.size(); ii++) {     
      Particle p2 = particles.get(ii);
      float d = dist(p.location.x, p.location.y, p2.location.x, p2.location.y);
      if (d > 35 || p == p2) continue;
      float a = map(p.age, 0, p.lifeSpan, 0, 25);
      stroke(255, a);
      strokeWeight(1);
      line(p.location.x, p.location.y, p2.location.x, p2.location.y);
    }
  }
 
}//END OF UPDATE PARTICLES

void linkParticles(){
  
  for (int i = 0; i < particles.size(); i++) {
    if (particles.size() <= 0) continue;
    Particle p = particles.get(i);
    
    for (int ii = 0; ii < particles.size(); ii++) {     
      Particle p2 = particles.get(ii);
      float d = dist(p.location.x, p.location.y, p2.location.x, p2.location.y);
      if (d > 35 || p == p2) continue;
      float a = map(p.age, 0, p.lifeSpan, 0, 25);
      stroke(255, a);
      strokeWeight(1);
      line(p.location.x, p.location.y, p2.location.x, p2.location.y);
    }
  }

}
