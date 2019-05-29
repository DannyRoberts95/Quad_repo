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
    if (FS) {
      fullScreen(P2D, screenNumber);
    } else {
      size(900, 900, P2D);
    }
  }

  public void setup() { 
    colorMode(HSB, 360, 100, 100, 100);
    frameRate(6);

    imageMode(CENTER);
    rectMode(CENTER);
    elementDistortEffect = new ElementDistortEffect();

    background(0);
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
    int glitchValueCap = 2000;
    int[] filters;

    //CYCLE VARIABELS
    int currentImageIndex = 0;
    int switchCount = 0;



    ElementDistortEffect() {
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
      fill(0, 20);
      rect(width/2, height/2, width, height);

      capture = kinect.getVideoImage();
      tx = (width-w)/2 + w/2;
      ty = (height-h)/2 + h/2;

      glitchValue = distortionValue;
      glitchValue = constrain(glitchValue, 0, glitchValueCap);

      pushMatrix();
      translate(tx, ty);
      if (FS)scale(2);
      imageMode(CENTER);
      image(capture, 0, 0, w, h);

      if (glitchValue > glitchValueCap*0.75) {
        filter(POSTERIZE, 2 + r(10));
        if (glitchValue > 10 && frameCount % 10 == 0) {
          blendGlitch();
          randomFilter();
        }


        horizontalSlitGlitch();
        //boxArtefacts();
        //pngDisplayCycle();



        if (glitchValue > glitchValueCap*0.5) {
          filter(POSTERIZE, 2 + r(10));
          tint(random(360), 100, 100);
        } else noTint();
      }

      popMatrix();

      pushMatrix();
      fill(255);
      text("DIST_VAL: "+distortionValue, 50, 50);
      text("GLITCH_VAL: "+ glitchValue, 50, 75);
      text("SCALE_FAC: "+spectrumScaleFactor, 50, 100);
      text("STAGE: "+stageNumber, 50, 125);

      text("FR: "+frameRate, 50, 150);
      popMatrix();
    }

    //------------------------
    //PNG DISPLAY
    //------------------------
    void pngDisplayCycle() {
      float threshold = glitchValueCap*0.25;
      if (glitchValue > threshold) {
        float switchRate = map(glitchValue, threshold, glitchValueCap, 3, 1);
        switchCount ++;
        if (switchCount > switchRate) {
          blendMode(floor(random(15)));
          switchCount = 0;
          currentImageIndex = floor(random(displayImages.length));
        } else blendMode(NORMAL);

        pushMatrix();
        translate(width/2, height/2);
        tint(255,10);
        image(displayImages[currentImageIndex], 0, 0, width, height); 
        popMatrix();
      }
    }

    //------------------------
    //SLIT GLITCH
    //------------------------
    void horizontalSlitGlitch() {

      int glitchNum = int( glitchValue/100);
      glitchNum = constrain(glitchNum, 1, 5); 

      for (int x=0; x<=glitchNum; x++) {
        hOffset = 0;

        int position = int(random(h));
        int verticleSteps = int(r(h));

        for (int v=position; v<verticleSteps; v++) {
          float distortRange = glitchValue / 10;
          hOffset += int(random(-distortRange, distortRange));
          PImage linea = createImage(w, 1, RGB);

          int vFixed = (v >= h ? v - h : v);
          linea.copy(capture, 0, vFixed, w, 1, 0, 0, w, 1);

          float posX = hOffset;
          float posY= vFixed-h/2;

          image(linea, posX, posY, width, random(3));
          
        }
      }
    }

    //------------------------
    //BOX ARTEFACTS
    //------------------------

    void boxArtefacts() {
      //Load capture pixels
      capture.loadPixels();  

      int artefactNumber = floor(glitchValue / 100);
      for (int i=0; i<artefactNumber; i++) {
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

    //------------------------
    //PNG DISPLAY
    //------------------------

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
    int r(int a) {
      return int(random(a));
    }
  }// end of element distort object
}
