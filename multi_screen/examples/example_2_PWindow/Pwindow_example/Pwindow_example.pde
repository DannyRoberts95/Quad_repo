PWindow win;

float green = 255;


public void settings() {
   fullScreen(P2D, 2);
}

void setup() { 
  win = new PWindow(255);
}

void draw() {
  background(255, 255, 0);
  fill(255);
  rect(10, 10, frameCount, 10);
}

void mousePressed() {
  println("mousePressed in primary window");
}  
