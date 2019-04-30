class ChildApplet extends PApplet {
  //JFrame frame;

  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    //fullScreen(P3D,2);
    size(100,100,P3D);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Child sketch");
    arcball2 = new Arcball(this, 300);
  }

  public void draw() {
    background(0);
    arcball2.run();
    if (mousePressed) {
      fill(240, 0, 0);
      ellipse(mouseX, mouseY, 20, 20);
      fill(255);
      text("Mouse pressed on child.", 10, 30);
    } else {
      fill(255);
      ellipse(width/2, height/2, 20, 20);
    }

    box(100, 200, 100);
    if (mousePressedOnParent) {
      fill(255);
      text("Mouse pressed on parent", 20, 20);
    }
  }

  public void mousePressed() {
    arcball2.mousePressed();
  }

  public void mouseDragged() {
    arcball2.mouseDragged();
  }
}
