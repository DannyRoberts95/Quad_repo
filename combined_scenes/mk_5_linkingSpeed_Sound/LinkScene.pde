
class LinkScene extends Scene {

  int[] depthMap;
  PImage depthFeed, rgbFeed;
  int maxThresh;
  boolean trackingUser = false;
  int skip = 5;
  int cols, rows;
  
  ArrayList<Particle> particles;
  int linkDistance = 50;
  float particleSpawnChance = 0.02;

  LinkScene() {
    setupScene();
  }

  void setupScene() {
    colorMode(HSB, 360, 100, 100, 100);
    imageMode(CENTER);

    kinect.enableDepth();

    particles = new ArrayList<Particle>();

    cols = kinect.depthImage().width/ skip;
    rows = kinect.depthImage().height/ skip;
    maxThresh = 1300;
  }

  void runScene() {
    //background(0,15);
    fill(0,25);
    rect(0,0,width,height);
    
    kinect.update();


    spawnParticles();

    updateParticles();
    flow.updateField();
  }
  void spawnParticles() {

    for (int x=0; x< kinect.depthImage().width; x+= skip) {
      for (int y=0; y< kinect.depthImage().height; y+=skip) {

        int offset =  x + y * kinect.depthImage().width;

        float d = kinect.depthMap()[offset];

        float r = random(1);
        if ( d > maxThresh || d == 0 || r > particleSpawnChance) continue;


        float posX = map(x, 0, kinect.depthImage().width, 0, width);
        float posY = map(y, 0, kinect.depthImage().height, 0, height);

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

      if (particles.size() <= 0) break;

      Particle p = particles.get(i);

      if (p.age > p.lifeSpan) {
        particles.remove(i);
        continue;
      }

      for (int ii = i+1; ii < particles.size(); ii++) {     
        Particle p2 = particles.get(ii);
        float d = dist(p.location.x, p.location.y, p2.location.x, p2.location.y);
        //if (d > random(linkDistance*0.5, linkDistance*1.5) || p == p2) continue;
        if (d > linkDistance || p == p2) continue;
        float range =  map(p.age, 0, (p.lifeSpan+p2.lifeSpan)/2, 1, 25);
        float a = map(d, 0, linkDistance, 0, range);
        float sw = map(d, 0, linkDistance, 0.1, 2);
        stroke(255, a);
        strokeWeight(sw);
        line(p.location.x, p.location.y, p2.location.x, p2.location.y);
      }

      p.run();
      //p.render();
    }
  }//END OF UPDATE PARTICLES

}
