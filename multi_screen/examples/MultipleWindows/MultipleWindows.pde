// Based on code by GeneKao (https://github.com/GeneKao)

ChildApplet child;
boolean mousePressedOnParent = false;
Arcball arcball, arcball2;  

void settings() {
  fullScreen(P3D,1);
  smooth();
}

void setup() {
  surface.setTitle("Main sketch");
  arcball = new Arcball(this, 300);
  child = new ChildApplet();
}

void draw() {
  background(250);
  arcball.run();
  if (mousePressed) {
    fill(0);
    text("Mouse pressed on parent.", 10, 10);
    fill(0, 240, 0);
    ellipse(mouseX, mouseY, 60, 60);
    mousePressedOnParent = true;
  } else {
    fill(20);
    ellipse(width/2, height/2, 60, 60);
    mousePressedOnParent = false;
  }
  box(100);
  if (child.mousePressed) {
    text("Mouse pressed on child.", 10, 30);
  }
}

void mousePressed() {
  arcball.mousePressed();
}

void mouseDragged() {
  arcball.mouseDragged();
}
