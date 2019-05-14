class Particle {
  PVector location;
  PVector prevLocation;
  PVector velocity;
  float speed;
  float lifeSpan;
  float age;
  color col;


  Particle (float x, float y) {
    location = new PVector(x, y);
    prevLocation = location.copy();
    velocity = new PVector(0, 0, 0);
    lifeSpan = random(15, 20);
    speed    = random(1,3);
  }

  void update() {
    // get current velocity

    velocity = flowField.lookupVelocity(location);
    velocity.mult(speed);
    location.add(velocity);
    age++;
  }

  void render() {
    stroke(255);
    strokeWeight(1.5);
    point(location.x, location.y);

  }

  
}
