class Main_Screen extends PApplet {
 
  //Visual Variables
  PImage capture;
  //Scene Vars
  int screenNumber;
  Thresh mainScreen;
  
  public Main_Screen(int screenN ) {
    super();
    screenNumber = screenN;
    mainScreen = new Main_Screen(2);
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    fullScreen(P2D, screenNumber);
    //size(900, 900, P2D);
  }
  public void setup() { 
    colorMode(HSB, 360, 100, 100, 100);
   
  }

  public void draw() {
    mainScreen.run();
  }
}
