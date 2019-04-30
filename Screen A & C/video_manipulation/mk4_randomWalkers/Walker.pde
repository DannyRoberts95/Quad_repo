class Walker {
  float x, y, prevX, prevY, r, s;
  float xoff, yoff;
  Walker(float _x, float _y, float _r, float _s) {
    x=_x;
    y=_y;
    r =_r;
    s = _s;

    xoff = random(1000);
    yoff = random(1000);
  }
  void run() {
    move();
    edges();
    display();
  }

  void display() {
    int px = int(map(x, 0, width, 0, capture.width));
    int py = int(map(y, 0, height, 0, capture.height));
    color col = capture.get(int(px), int(py));
    float b = brightness(col);
    //stroke(b);
    stroke(col);
    strokeWeight(r);
    line(prevX, prevY, x, y);
  }

  void move() {
    prevX = x;
    prevY = y;
    x += map(noise(xoff), 0, 1, -s, s);
    y += map(noise(yoff), 0, 1, -s, s);
    
    //float r = random(1);
    //if(r > 0.5){
    //x += random(-s,s);
    //}else     y += random(-s,s);

    xoff += 0.05;
    yoff += 0.02;
  }

  void edges() {
    if (x < 0) {
      x = width;
      prevX = x;
      prevY = y;
    } else if (x > width) { 
      x = 0;
      prevX = x;
      prevY = y;
    } else if (y < 0) {
      y = height;
      prevX = x;
      prevY = y;
    } else if (y > height) { 
      y = 0;
      prevX = x;
      prevY = y;
    }
  }
}
