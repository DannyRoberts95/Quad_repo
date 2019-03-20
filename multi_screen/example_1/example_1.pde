PWindow win;
PGraphics pg;
 
public void settings() {
  size(displayWidth, displayHeight);
}
 
void setup() { 
  win = new PWindow();
  pg = createGraphics(width, height);
  println(width, height);
}
 
void draw() {
  pg.beginDraw();
  pg.background(255, 0, 0);
  pg.fill(255);
  pg.rect(10, 10, abs(sin(frameCount*.02)*width), 10);
  pg.endDraw();
  image(pg, 0, 0, width, height);
  win.setPG(pg);
}
 
void mousePressed() {
  println("mousePressed in primary window");
}  
 
class PWindow extends PApplet {
  PGraphics pg1;
 
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
 
  void settings() {
    size(320, 240);
  }
 
  void setup() {
    background(150);
    pg1 = createGraphics(width, height);
    println(width, height);
  }
 
  void setPG(PGraphics pg1) {
    pg1.beginDraw();
    this.pg1=pg1;
    pg1.endDraw();
  }
 
  void draw() {
    image(pg1, 0, 0, width, height);
  }
 
  void mousePressed() {
    println("mousePressed in secondary window");
  }
}
