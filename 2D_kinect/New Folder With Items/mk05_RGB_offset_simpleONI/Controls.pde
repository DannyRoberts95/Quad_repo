void keyPressed() {
switch(keyCode)
  {
  case LEFT:
    minThresh += 25;
    println(minThresh);
    break;
  case RIGHT:
    minThresh -= 25;
    println(minThresh);
    break;
  case UP:
    maxThresh += 25;
    println(maxThresh);
    break;
  case DOWN:
    maxThresh -= 25;
    println(maxThresh);
    break;
  }
}
