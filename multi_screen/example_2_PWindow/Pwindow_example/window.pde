class PWindow extends PApplet {
  
  float red;
  
  PWindow(float r) {
    super();
    red = r;
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    fullScreen(P2D, 1);
  }

  void setup() {
    background(red,green,100);
  }

  void draw() {
    ellipse(random(width), random(height), random(50), random(50));
  }

  void mousePressed() {
    println("mousePressed in secondary window");
  }
}
