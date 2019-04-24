class Links extends PApplet {
  int screenNumber;

  //FlowField flow;

  int[] depthMap;
  PImage depthFeed, rgbFeed;
  int maxThresh;
  boolean trackingUser = false;
  int skip = 10;
  int cols, rows;
  ArrayList<Particle> particles;
  int linkDistance = 50;
  float particleSpawnChance = 0.0125;

  float xOff, yOff, zOff;
  float xInc, yInc, zInc;

  public Links(int sn ) {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    screenNumber = sn;
  }

  public void settings() {
    //fullScreen(P2D, screenNumber);
    //size(900, 900, P2D);
    size(displayWidth, displayHeight, P2D);
    smooth();
  }


  public void setup() { 

    //frameRate(10);// So as not to melt the computer
    surface.setTitle("Child sketch");
    background(0);
    colorMode(HSB, 360, 100, 100, 100);
    imageMode(CENTER);

    particles = new ArrayList<Particle>();

    cols = kinect.depthImage().width/ skip;
    rows = kinect.depthImage().height/ skip;
    maxThresh = 1300;

    xOff = random(10000);
    yOff = random(10000);
    zOff = random(10000);

    xInc = 0.03;
    yInc = 0.03;
    zInc = 0.01;
  }

  public void draw() {
    //fill(0, 25);
    //rect(0, 0, width, height);
    background(0);
    
    fill(255);
    text(frameRate,25,25);
    
    if(frameCount % 10 == 0) println(particles.size());
    spawnParticles();
    updateParticles();
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
        //float range =  map(p.age, 0, (p.lifeSpan+p2.lifeSpan)/2, 1, 25);
        //float a = map(d, 0, linkDistance, 0, range);
        //float sw = map(d, 0, linkDistance, 0.1, 2);
        stroke(255, 25);
        strokeWeight(1);
        line(p.location.x, p.location.y, p2.location.x, p2.location.y);
      }

      p.run(noise(xOff,yOff,zOff));
      xOff += xInc;
      yOff += yInc;
      zOff += zInc;
     
    }
  }//END OF UPDATE PARTICLES
}
