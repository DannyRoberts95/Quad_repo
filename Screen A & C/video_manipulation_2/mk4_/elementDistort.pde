class ElementDistortEffect {
  float tx, ty;
  int hOffset = 0;
  int w = capture.width;
  int h = capture.height;

  float glitchValue;
  int[] filters;

  ElementDistortEffect() {
    imageMode(CENTER);
    frameRate(30);

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
    fill(0, 100);
    rect(0, 0, width*2, height*2);

    tx = (width-w)/2 + w/2;
    ty = (height-h)/2 + h/2;

    glitchValue = distorter.distortionValue;

    pushMatrix();
    translate(tx, ty);
    //scale(1.5);
    imageMode(CENTER);
    image(capture, 0, 0);

    if (glitchValue > 0) {
      filter(POSTERIZE, 2 + r(10));
      if (glitchValue > 0 && frameCount % 10 == 0) {
        blendGlitch();
        randomFilter(); 
      }
      horizontalSlitGlitch();
      boxArtefacts();
      if(glitchValue > 100){
        tint(random(360),100,100);
      }else noTint();
    }

    popMatrix();
  }


  void horizontalSlitGlitch() {
    int glitchNum = int( glitchValue/100);
    glitchNum = constrain(glitchNum, 0, 10); 

    int h2 = int(glitchValue / 10);
    h2 = max(h2, 1);

    for (int x=0; x<=glitchNum*h2; x+= h2) {
      hOffset = 0;
      int position = int(random(h));
      int verticleSteps = int(r(h));
      for (int v=position; v<verticleSteps; v++) {
        float distortRange = glitchValue / 5;
        hOffset += int(random(-distortRange/2, distortRange/2));
        PImage linea = createImage(w, h2, HSB);
        int vFixed = (v >= h ? v - h : v);
        linea.copy(capture, 0, vFixed, w, h2, 0, 0, w, h2);
        image(linea, hOffset, -h/2+vFixed);
      }
    }
  }

  void boxArtefacts() {
    //Load capture pixels
    capture.loadPixels();  
    
    for (int i=0; i<glitchValue / 10; i++) {
      // find a random pixel in cpature
      int x = r(w);
      int y = r(h);
      // get an offset ammount
      int xOff = int(random(-glitchValue/2, glitchValue/2));
      int yOff = int(random(-glitchValue/2, glitchValue/2));
      //define the point on screen where the box artefact will appear 
      int sx = x + xOff + int(tx-w/2);
      int sy = y + yOff + int(ty-h/2);

      PImage boxArtefact = capture.get(x, y, int(random(glitchValue/2,glitchValue)), int(random(glitchValue/2,glitchValue)));
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



  void randomFilter() {

    int rv = floor(random(7));

    if (rv == 0) {
      filter(BLUR, 5);
    } else if (rv == 1) {
      filter(POSTERIZE, 2 + r(10));
    } else if (rv == 2) {
      filter(DILATE);
    } else if (rv == 3 ) {
      filter(ERODE);
    } else if (rv == 4) {
      filter(GRAY);
    }
    else if (rv == 5) {
      filter(THRESHOLD);
    }
    else if (rv == 6) {
      filter(INVERT);
    }
  }
}
