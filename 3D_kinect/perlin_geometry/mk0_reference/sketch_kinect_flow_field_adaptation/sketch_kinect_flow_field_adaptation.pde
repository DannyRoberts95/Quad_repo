import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

FlowField           flowField;
ArrayList<Particle> particles;
float               particlesIncrement = 4;
float        particleSpacing = 1.8;
float        particleSpacing2 = 1.9;

float particlesIncrement2 = 2;

float zTranslate = 1000;
float xPadding = 0;
float maxDepth = 750;
float subtractZ = 0;

color col = color(255,100,100);
color particleCol = color(255,100,100);

boolean onBeat;

Kinect                kinect;

void setup() {
  fullScreen(P3D);
  //size(1200,1200,P3D);
  background(0);
  flowField = new FlowField(10);
  particles = new ArrayList<Particle>();
  xPadding = width / 10;

  kinect = new Kinect(this);
  kinect.initDepth();


}

void draw() {
  translate(
    xPadding, 
    0, 
    zTranslate
    );

  background(255);
  flowField.updateField();

  int[] depth = kinect.getRawDepth();

  for (int x = 0; x < kinect.width; x += particlesIncrement) {
    for (int y = 0; y < kinect.height; y += particlesIncrement) {
      int offset = x + y * kinect.width;
      int z = depth[offset];
      if (z > maxDepth || z == 0) {
        continue;
      }
      
      float posX = map(x,0,kinect.width,0,width);
      float posY = map(y,0,kinect.height,0,height);

      Particle particle = new Particle(
        posX, 
        posY, 
        subtractZ - z,
        particleCol
        );
      particles.add(particle);
    }
  }


  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).update();
    particles.get(i).render();
    if (particles.get(i).age > particles.get(i).lifeSpan) {
      particles.remove(i);
    }
  }
  
  for (int x = 0; x < kinect.width; x += particlesIncrement2) {
    for (int y = 0; y < kinect.height; y += particlesIncrement2) {
      int offset = x + y * kinect.width;
      int z = depth[offset];
      if (z > maxDepth || z == 0) {
        continue;
      }
      
      float posX = map(x,0,kinect.width,0,width);
      float posY = map(y,0,kinect.height,0,height);
  
      stroke(255,100,100);
      strokeWeight(2);
      point(
        posX, 
        posY, 
        subtractZ - z
        );
    }
  }
}


class Particle {
  PVector location;
  PVector velocity;

  float speed;
  float lifeSpan;
  float age;
  
  color col;


  Particle (float x, float y, float z, color c) {
    location = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    col = c;
    lifeSpan = random(5, 15);
    speed    = random(10, 25);
  }

  void update() {
    // get current velocity
    if (!onBeat) {
      velocity = flowField.lookupVelocity(location);
      velocity.mult(speed);
      location.add(velocity);
      age++;
    }
  }

  void render() {
    stroke(particleCol);
    strokeWeight(1.5);
    point(location.x, location.y, location.z);
  }
}

class FlowField {
  PVector[][] grid;
  int   cols, rows;
  int   resolution;
  float zNoise = 0.0;

  FlowField (int res) {
    resolution = res;
    rows = height/resolution;
    cols = width/ resolution;
    grid = new PVector[cols][rows];
  }

  void updateField() {
    float xNoise = 0;
    for (int i = 0; i < cols; i++) {
      float yNoise = 0;
      for (int j = 0; j < rows; j++) {
        // TODO: play around with angles to make it prettier?
        //float angle = radians((noise(xNoise, yNoise, zNoise)) *700) + noise(frameCount);
        //sin(noise(xNoise, yNoise, zNoise) * frameCount) * cos(noise(xOff, yOff, zOff));
        //map(noise(xNoise, yNoise, zNoise), 0, 1, 0, radians(360));
        float angle = radians((noise(xNoise, yNoise, zNoise)) * 700);
        grid[i][j] = PVector.fromAngle(angle);
        yNoise += 0.03;
      }
      xNoise += 0.03;
    }
    zNoise += 0.05;
  }

  PVector lookupVelocity(PVector particleLocation) {
    int column = int(
      constrain(
      particleLocation.x / resolution, 
      0, 
      cols - 1)
      );
    int row = int(
      constrain(
      particleLocation.y / resolution, 
      0, 
      rows - 1)
      );
    return grid[column][row].copy();
  }
}
