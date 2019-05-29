class RGB_Screen extends PApplet {
  //Visual Variables
  //Scene Vars
  int screenNumber;

  float tx, ty;
  int hOffset = 0;
  PImage capture= kinect.getVideoImage();

  int w = capture.height;
  int h = capture.height;


  //int dw = int(w*1.75);
  //int dh = int(h*1.75);
  int dw = int(w);
  int dh = int(h);  

  float glitchValue;

  //CYCLE VARIABELS
  int currentImageIndex = 0;

  //NOISE SLIt VARS
  int cols;
  int rows;
  float noffX = random(10000);
  float noffXinc = 0.05;
  float res = 5;



  public RGB_Screen(int screenN ) {
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
    background(0);
  }

  public void draw() {

    fill(0, 15);
    rect(0, 0, width*2, height*2);

    tx = (width-w)/2 + w/2;
    ty = (height-h)/2 + h/2;

    glitchValue = distortionValue/2;
    glitchValue = constrain(glitchValue, 0, glitchValueCap);

    pushMatrix();
    translate(tx, ty);
    imageMode(CENTER);






    if (stageNumber != 5 ) {
      captureRenderNoise();
      boxArtefacts();
      if (glitchValue > glitchValueCap*0.25) {
        filter(POSTERIZE, 2 + r(10));
        pngDisplayCycle();
        blendGlitch();
      } else noTint();
    } else {
      noTint();
      image(blueScreen, 0, 0, width, height);
    } 
    popMatrix();
  }



  //------------------------
  //PNG DISPLAY
  //------------------------
  void pngDisplayCycle() {
    currentImageIndex = floor(random(displayImages.length));
    pushMatrix();
    image(displayImages[currentImageIndex], 0, 0, width, height); 
    popMatrix();
  }

  //------------------------
  //NOISE CAPTURE RENDER
  //------------------------
  void captureRenderNoise() {

    //randomSeed(1);
    noiseSeed(1);
    PImage c = capture;
    c.loadPixels();
    float frameW = dw;
    float frameH = dh;
    cols = floor(frameW/ res);
    rows = floor(frameH/ res);
    float xMargin = cols*res/2;
    float yMargin = rows*res/2;

    pushMatrix();
    for (int ii = 0; ii<rows; ii++) {
      float maxOffset = dw;
      float offsetRange = map(glitchValue*0.75, 0, glitchValueCap, 0, maxOffset);
      float ox =  map(noise(noffX), 0, 1, -offsetRange, offsetRange);
      noffX += noffXinc; 
      if (maxOffset*0.75 < (ox)) continue;
      for (int iii =0; iii<cols; iii++) {
        float x = iii * (res);
        float y = ii * (res);
        int pixelX = floor(map(x, 0, frameW, 0, capture.width));
        int pixelY = floor(map(y, 0, frameH, 0, capture.height));
        color col = capture.get(pixelX, pixelY);
        float renderSize = res;
        if (maxOffset*0.5 < ox) {
          color c1 = capture.get(pixelX, pixelY);
          color c2 = color(random(180), 50, random(65, 100));
          float lerpAmm = map(abs(ox), 0, glitchValue*2, 0, 1);
          col = lerpColor(c1, c2, lerpAmm);
          renderSize = random(res*4, res*4);
        }

        pushMatrix();
        translate(-xMargin, -yMargin);
        translate((x+res/2), (y+res/2));
        translate(ox, 0);
        noStroke();
        fill(col);
        rect(0, 0, renderSize, renderSize);
        popMatrix();
      }
    }
    popMatrix();

    //pushMatrix();
    //fill(255);
    //textSize(24);
    //translate(-tx, -ty);
    //text("GLITCH_CAP_%: "+glitchValue/glitchValueCap*100, 50, 75);
    //text("SCALE_FAC: "+spectrumScaleFactor, 50, 125);
    //text("STAGE: "+stageNumber, 50, 175);
    //text("MS: "+m, 50, 275);
    //popMatrix();
  }

  //------------------------
  //BOX ARTEFACTS
  //------------------------

  void boxArtefacts() {
    //Load capture pixels
    capture.loadPixels();  

    //int artefactNumber = floor(glitchValue / 100);
    int artefactNumber = floor(map(glitchValue, 0, glitchValueCap, 0, 15));
    for (int i=0; i<artefactNumber; i++) {
      // find a random pixel in capture
      int x = r(w);
      int y = r(h);
      // get an offset ammount
      int xOff = int(random(-glitchValue/2, glitchValue/2));
      int yOff = int(random(-glitchValue/2, glitchValue/2));
      //define the point on screen where the box artefact will appear 
      int x2 = x + xOff + int(tx-w/2);
      int y2 = y + yOff + int(ty-h/2);

      PImage boxArtefact = capture.get(x, y, int(random(w/2, w)), int(random(w/2, w)));
      // set the pixels at that point 
      set(int(x2-w/2), int(y2-h/2), boxArtefact);
    }
  }

  //------------------------
  //PNG DISPLAY
  //------------------------

  void blendGlitch() {
    int filters[];
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

    if (random(1)>0.5)tint(random(360), 100, 100);

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
}
