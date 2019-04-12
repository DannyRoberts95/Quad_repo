
class ProjectorSketch extends PApplet {
  void settings() {
    size(displayWidth/2, displayHeight/2, JAVA2D);
    smooth(4);
 
    println("Inner's sketchPath: \t\"" + sketchPath("") + "\"");
    println("Inner's dataPath: \t\"" + dataPath("") + "\"\n");
  }
 
  void setup() {
    removeExitEvent(getSurface());
 
    frameRate(1);
    stroke(#FFFF00);
    strokeWeight(5);
  }
 
  void draw() {
    background(red,0,0);
    line(width, 0, 0, height);
 
  }
 
  @ Override void exit() {
  }
}
