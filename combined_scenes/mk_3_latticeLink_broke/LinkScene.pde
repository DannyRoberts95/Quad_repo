FlowField flow;

class LinkScene extends Scene {

  int[] depthMap;
  PImage depthFeed, rgbFeed;
  int maxThresh;
  boolean trackingUser = false;
  int skip = 4;
  int cols, rows, colsLattice, rowsLattice;

  ArrayList<Particle> particles;

  ArrayList<Particle>[][] grid;
  int maxParticleNumber = 1700;
  int linkDistance = 100;
  int nRadius = 1;
  int latticeSkip = skip*4;

  LinkScene() {
    setupScene();
  }

  void setupScene() {
    colorMode(HSB, 360, 100, 100, 100);
    imageMode(CENTER);

    kinect.enableDepth();

    maxThresh = 1300;

    flow = new FlowField(20);    
    particles = new ArrayList<Particle>();

    cols = kinect.depthImage().width/ skip;
    rows = kinect.depthImage().height/ skip;

    colsLattice = width/ latticeSkip;
    rowsLattice = height/ latticeSkip;
    // Initialize grid as 2D array of empty ArrayLists
    grid = new ArrayList[colsLattice][rowsLattice];
    for (int i = 0; i < colsLattice; i++) {
      for (int j = 0; j < rowsLattice; j++) {
        grid[i][j] = new ArrayList<Particle>();
      }
    }
  }

  void runScene() {
    background(0);
    kinect.update();

    // Every time through draw clear all the lists
    for (int i = 0; i < colsLattice; i++) {
      for (int j = 0; j < rowsLattice; j++) {
        grid[i][j].clear();
      }
    }

    if (particles.size() < maxParticleNumber) spawnParticles();

    updateParticles();
    flow.updateField();
  }
  void spawnParticles() {

    for (int x=0; x< kinect.depthImage().width; x+= skip) {
      for (int y=0; y< kinect.depthImage().height; y+=skip) {

        int offset =  x + y * kinect.depthImage().width;

        float d = kinect.depthMap()[offset];

        float r = random(1);
        if ( d > maxThresh || d == 0 || r > 0.005) continue;


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

    //LATTICE SUBDIVIOSION

    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      if (p.age > p.lifeSpan) {
        particles.remove(p);
      }else p.run();
    }

    // Register every Thing object in the grid according to it's position
    for (Particle p : particles) {
      int x = int(p.location.x) / latticeSkip; 
      int y = int (p.location.y) /latticeSkip;
      // It goes in 9 cells, i.e. every Thing is tested against other Things in its cell
      // as well as its 8 neighbors 
      for (int n = -nRadius; n <= nRadius; n++) {
        for (int m = -nRadius; m <= nRadius; m++) {
          if (x+n >= 0 && x+n < colsLattice && y+m >= 0 && y+m< rowsLattice) grid[x+n][y+m].add(p);
        }
      }
    }

    // Run through the Grid
    stroke(255);
    for (int i = 0; i < colsLattice; i++) {
      //line(i*scl,0,i*scl,height);
      for (int j = 0; j < rowsLattice; j++) {
        //line(0,j*scl,width,j*scl);

        // For every list in the grid
        ArrayList<Particle> temp = grid[i][j];
        // Check every Thing
        for (Particle p : temp) {
          // Against every other Thing
          for (Particle other : temp) {
            // As long as its not the same one
            if (other != p) {
              float d = dist(p.location.x, p.location.y, other.location.x, other.location.y);
              if (d <= linkDistance) {
                float range =  map(p.age, 0, p.lifeSpan, 0, 25);
                float a = map(d, 0, linkDistance, 0, range);
                float sw = map(d, 0, linkDistance, 0.1, 1);
                stroke(255, a);
                strokeWeight(sw);
                line(p.location.x, p.location.y, other.location.x, other.location.y);
              }
            }
          }
        }
      }
    }
    
  }//END OF UPDATE PARTICLES
}
