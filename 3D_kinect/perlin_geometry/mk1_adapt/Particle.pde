class Particle {
  PVector location;
  PVector prevLocation;
  PVector velocity;
  float speed;
  float lifeSpan;
  float age;
  color col;


  Particle (float x, float y, float z, color c) {
    location = new PVector(x, y, z);
    prevLocation = location.copy();
    velocity = new PVector(0, 0, 0);
    col = c;
    lifeSpan = random(15, 20);
    speed    = random(5, 10);
    
  }

  void update() {
    // get current velocity
    
    velocity = flowField.lookupVelocity(location);
    velocity.mult(speed);
    location.add(velocity);
    age++;
  }

  void render() {
    stroke(particleCol);
    strokeWeight(1.5);
    point(location.x, location.y, location.z);
   
    
  }
}
