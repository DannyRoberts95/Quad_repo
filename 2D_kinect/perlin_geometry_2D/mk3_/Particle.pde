class Particle {
  PVector location;
  PVector prevLocation;
  PVector velocity;
  PVector acceleration;
  float speed;
  float lifeSpan;
  float age;
  color col;


  Particle (float x, float y) {
    location = new PVector(x, y);
    prevLocation = location.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    lifeSpan = random(10, 15);
    speed    = random(1,10);
  }
  
  void run(){
   getFlowForce();
   update();
   //display();
   
   
  }
  
  void update(){
    velocity.add(acceleration);
    velocity.limit(speed);
    location.add(velocity);
    acceleration.mult(0);
    age++;
    
  }

  void getFlowForce() {
    // get current velocity
    PVector force = flowField.lookupVelocity(location);
    force.mult(speed);
    applyForce(force);
    
  }

  void display() {
    stroke(255);
    strokeWeight(1.5);
    point(location.x, location.y);

  }
  
  // defines the previous locationition of a particle so that a line acan be dra between the two points
  void updatePrev() {
    prevLocation.x = location.x;
    prevLocation.y = location.y;
  }
  
  //applys a force passes into the fuction to the acceleration of the particle
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  
}
