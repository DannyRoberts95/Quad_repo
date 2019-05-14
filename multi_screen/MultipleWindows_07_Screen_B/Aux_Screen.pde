class Aux_Screen extends PApplet {
  
 
  //Visual Variables
  PImage capture;
  //Scene Vars
  int screenNumber;
  ElementDistortEffect elementDistortEffect;

  public Aux_Screen(int screenN ) {
    super();
    screenNumber = screenN;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    fullScreen(P2D, screenNumber);
    //size(900, 900, P2D);
  }
  public void setup() { 
    colorMode(HSB, 360, 100, 100, 100);
    background(0);  
    imageMode(CENTER);
    rectMode(CENTER);
    elementDistortEffect = new ElementDistortEffect();
  }

  public void draw() {
    elementDistortEffect.run();
  }

  //**********************************************
  // Effect Class
  //**********************************************

  class ElementDistortEffect {
    float tx, ty;
    int hOffset = 0;
    PImage capture= kinect.getVideoImage();
    int w=capture.height;
    int h = capture.height;

    float glitchValue;
    int[] filters;

    ElementDistortEffect( ) {
      imageMode(CENTER);
      //frameRate(30);

      filters = new int[14];
      filters[0] = BLEND; 
      filters[1] = ADD;
      filters[2] = SUBTRACT;
      filters[3] = LIGHTEST;
      filters[4] = DARKEST;
      filters[5] = DIFFERENCE;
      filters[6] = EXCLUSION;
      filters[7] = MULTIPLY;
      filters[8] = SCREEN;
      filters[9] = OVERLAY;
      filters[10] = HARD_LIGHT;
      filters[11] = SOFT_LIGHT;
      filters[12] = DODGE;
      filters[13] = BURN;
    }

   void run() {
      fill(0, 15);
      rect(0, 0, width*2, height*2);

      capture = kinect.getVideoImage();
      tx = (width-w)/2 + w/2;
      ty = (height-h)/2 + h/2;

      glitchValue = distortionValue;

      pushMatrix();
      translate(tx, ty);
      scale(1.5);
      imageMode(CENTER);
      image(capture, 0, 0, w, h);

      if (glitchValue > 25) {
        filter(POSTERIZE, 2 + r(10));
        if (glitchValue > 10 && frameCount % 10 == 0) {
          blendGlitch();
          randomFilter();
        }

        horizontalSlitGlitch();
        boxArtefacts();
        //bogey effect
        //multiBoxGlitch();

        if (glitchValue > 100) {
          filter(POSTERIZE, 2 + r(10));
          tint(random(360), 100, 100);
        } else noTint();
      }

      popMatrix();
    }

    void horizontalSlitGlitch() {

      int glitchNum = int( glitchValue/100);
      glitchNum = constrain(glitchNum, 1, 5); 

      for (int x=0; x<=glitchNum; x++) {
        hOffset = 0;

        int position = int(random(h));
        int verticleSteps = int(r(h));

        for (int v=position; v<verticleSteps; v++) {
          float distortRange = glitchValue / 5;
          hOffset += int(random(-distortRange/2, distortRange/2));
          //hOffset += int(random(-4, 4));
          PImage linea = createImage(w, 1, RGB);

          int vFixed = (v >= h ? v - h : v);

          linea.copy(capture, 0, vFixed, w, 1, 0, 0, w, 1);      
          image(linea, hOffset, vFixed-h/2);
        }
      }
    }

    void multiBoxGlitch() {
      int x = r(w);
      int y = r(h);
      int w1 = int(random(w/2));
      int h1 = int(random(h/2));
      PImage artefact = capture.get(x, y, w1, h1); 

      int xPos = floor(random(tx, width-tx));
      int yPos = floor(random(ty, height-ty));

      for (int i = 0; i<10; i++) {
        image(artefact, xPos-tx, yPos-ty);
        xPos += w1*0.1;
        yPos += h1*0.1;
      }
    }

    void boxArtefacts() {
      //Load capture pixels
      capture.loadPixels();  

      for (int i=0; i<glitchValue / 10; i++) {
        // find a random pixel in capture
        int x = r(w);
        int y = r(h);
        // get an offset ammount
        int xOff = int(random(-glitchValue/2, glitchValue/2));
        int yOff = int(random(-glitchValue/2, glitchValue/2));
        //define the point on screen where the box artefact will appear 
        int sx = x + xOff + int(tx-w/2);
        int sy = y + yOff + int(ty-h/2);

        PImage boxArtefact = capture.get(x, y, int(random(glitchValue/2, glitchValue)), int(random(glitchValue/2, glitchValue)));
        // set the pixels at that point 
        set(sx, sy, boxArtefact);
      }
    }

    void blendGlitch() {

      int x = r(w);
      int y = r(h);
      int wi = r(w-x);
      int he = r(h-y);
      PImage el = capture.get(x, y, wi, he);
      int offsetx = r(w - wi) + int(tx) - w/2;
      int offsety = r(h - he) + int(ty)- h/2;
      int rndfilter = r(14);
      blend(el, 0, 0, wi, he, offsetx, offsety, wi, he, filters[rndfilter]);
    }

    int r(int a) {
      return int(random(a));
    }

    void randomFilter() {

      int rv = floor(random(7));

      if (rv == 1 || rv == 0) {
        filter(POSTERIZE, 2 + r(10));
      } else if (rv == 2) {
        filter(DILATE);
      } else if (rv == 3 ) {
        filter(ERODE);
      } else if (rv == 4) {
        filter(GRAY);
      } else if (rv == 5 || rv == 6) {
        filter(THRESHOLD);
      }
    }
  }
}
