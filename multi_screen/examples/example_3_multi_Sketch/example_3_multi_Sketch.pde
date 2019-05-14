 //* Multi-Monitor Sketch (v2.21)
 //* by GoToLoop (2015/Jun/28)
 //*
 //* forum.Processing.org/two/discussion/12319/
 //* using-papplet-runsketch-to-create-multiple-windows-in-a-sketch
 //* 
 //* forum.Processing.org/two/discussion/11304/
 //* multiple-monitors-primary-dragable-secondary-fullscreen
 //*
 //* forum.Processing.org/two/discussion/10937/multiple-sketches
 //*/
 
ProjectorSketch projector, projector2;

float red = 255;
float blue = 255;
float green = 255;
 
void settings() {
  size(displayWidth/2, displayHeight/2, JAVA2D);
  smooth(4);
 
  println("Main's  sketchPath: \t\"" + sketchPath("") + "\"");
  println("Main's  dataPath: \t\"" + dataPath("") + "\"\n");
}
 
void setup() {
  noLoop();
  frameRate(60);
  stroke(-1);
  strokeWeight(1.5);
 
  runSketch( new String[] {
    "--display=1", 
    "--location=" + (displayWidth>>2) + ',' + (displayHeight>>3), 
    "--sketch-path=" + sketchPath(""), 
    "" }
    , projector = new ProjectorSketch() );
    
      runSketch( new String[] {
    "--display=1", 
    "--location=" + (displayWidth>>2) + ',' + (displayHeight>>3), 
    "--sketch-path=" + sketchPath(""), 
    "" }
    , projector2 = new ProjectorSketch() );
}
 
void draw() {
  background(0);
  line(0, 0, width, height);
}
 
void mousePressed() {
  projector.getSurface().setVisible(true);
}
 
static final void removeExitEvent(final PSurface surf) {
  final java.awt.Window win
    = ((processing.awt.PSurfaceAWT.SmoothCanvas) surf.getNative()).getFrame();
 
  for (final java.awt.event.WindowListener evt : win.getWindowListeners())
    win.removeWindowListener(evt);
}
 
