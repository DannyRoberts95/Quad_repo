import SimpleOpenNI.*;

SimpleOpenNI kinect;
PImage capture;
int w = 640;
int h = 480;
float tx, ty;
int hOffset = 0;

void settings() {
  size(displayWidth, displayHeight, P2D);
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);

  kinect = new SimpleOpenNI(this);
  kinect.enableRGB();
}

void draw() {
  kinect.update();
  capture = kinect.rgbImage();

  tx = (width-capture.width)/2;
  ty = (height-capture.height)/2;

  pushMatrix();
  translate(tx, ty);
  image(capture, 0, 0);
  randomFilter();
  
      for (int x=0; x<=3; x++) {
        hOffset = 0;

        int position = int(r(h)/2) + int(r(h)/2);
        int duration = int(r(h) / 1.15);
    
        for (int v=position; v<duration; v++) {
            hOffset += int(random(-4, 4));
            PImage linea = createImage(w, 1, RGB);
      
            int vFixed = (v >= h ? v - h : v);

            linea.copy(capture, 0, vFixed, w, 1, 0, 0, w, 1);      
            image(linea, hOffset, vFixed);
        }
    } 

  //box artefacts
  //getSetGlitch3();
  
  //randomLines
  //elementGlitch2();
  
  
  elementGlitch4();
  popMatrix();
}
void getSetGlitch3() {
  capture.loadPixels();  
  for (int i=0; i<12; i++) {
    int x = r(w);
    int y = r(h);
    int xOff = int(random(-50, 50));
    int yOff = int(random(-50, 50));
    set(x + xOff +int(tx), y + yOff +int(ty), capture.get(x, y, r(100), r(100)));
  }
}

void elementGlitch2() {
  if (frameCount % (r(250) + 1) == 0) {
    int lineDensity = int(noise(frameCount) * width);
    for (int i=0; i<700*1.5; i+=lineDensity) {
      stroke(0);
      strokeWeight(1);
      line(0, i, i, 0);
    }
  }
}

void elementGlitch4() {
  if (frameCount % 10 == 0) {
    int x = r(20);
    int y = r(20);
    int wi = r(capture.width/2);
    int he = r(capture.height/3);

    PImage el = capture.get(x, y, wi, he);

    int offsetx = r(w - wi);
    int offsety = r(h - he);

    int[] filters = new int[14];
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

    int rndfilter = r(14);

    blend(el, 0, 0, wi, he, offsetx, offsety, wi, he, filters[rndfilter]);
    //tint(1, 255, 10);
    //image(el, offsetx, offsety);
    //noTint();
  }
}

int r(int a) {
  return int(random(a));
}

void randomFilter() {
  int rnd = 2 + r(50);

  if (rnd <= 7) {
    filter(BLUR, 1 + r(6));
  } else if (rnd > 7 && rnd <= 13) {
    filter(POSTERIZE, 2 + r(200));
  } else if (rnd > 13 && rnd <= 20) {
    filter(DILATE);
  } else if (rnd > 20 && rnd <= 25 ) {
    filter(ERODE);
  } else if (rnd > 25 && rnd <= 28) {
    filter(GRAY);
  }
}
