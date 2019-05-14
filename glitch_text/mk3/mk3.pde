String[] code;

int fontSize = 12;
float leading = fontSize*1.25;

float tbWidth = 0;
float tbHeight = 0;
float tbInc = fontSize/2;

int padding = 50;

String [] errMessages;
PFont myFont;

boolean reversed = false;

void settings() {
  size(1000, 1000, P2D);
}

void setup() {
  code = loadStrings("code.txt");
  myFont = createFont("MonoSpaced", fontSize);

  errMessages = new String [8];
  errMessages[0] = "ERROR: Null pointer exception [SECRET] ";
  errMessages[1] = "ERROR: Array index out of bounds ";
  errMessages[2] = "ERROR: Asset could not be loaded because I hate you ";
  errMessages[3] = "ERROR: Process Succeeded ";
  errMessages[4] = "ERROR: Try again when I feel like it ";
  errMessages[5] = "ERROR: Update Drivers - [vroom vroom} ";
  errMessages[6] = "ERROR: JavaRutime Error: relaunch Applet ";
  errMessages[7] = "ERROR: I'm dreaming of electric sheep ";
}
void draw() {
  randomSeed(1);  
  background(0);
  textFont(myFont, fontSize);

  pushMatrix();
  translate(padding, padding);
  int ri1 = floor(random(code.length*0.5));
  int ri2 = floor(random(ri1, code.length));

  if (frameCount % 5 == 0 && !reversed) {
    tbWidth += tbInc;
    tbHeight += tbInc;
  } else if (frameCount % 5 == 0 && reversed) {
    tbWidth -= tbInc*(10);
    tbHeight -= tbInc*(10);
  }

  if (tbWidth > width - padding*2) {
    reversed = true;
  } else if (tbWidth < 0) {
    tbWidth = 0;
    reversed = false;
  }

  float penTipX = 0;
  float penTipY = 0;

  for (int i = ri1; i < ri2; i++) { 

    float r = random(1);

    if (r <= 0.1) {
      String err = errMessages[floor(random(errMessages.length))];
      fill(255, 0, 0);
      noStroke();
      rect(0, penTipY, min(penTipX, textWidth(err)), leading);

      if (penTipX > textWidth(err)) {
        fill(255);
        textAlign(LEFT, CENTER);
        text(err, 0, penTipY+fontSize/2);
      }
    } else if (r < 0.15) {
      penTipY += leading;
      continue;
    } 

    for (int ii = 0; ii < code[i].length(); ii++) {
      String c = str(code[i].charAt(ii));
      fill(255);
      textAlign(LEFT, LEFT);
      text(c, penTipX, penTipY, width, height);
      penTipX += textWidth(c);
      
      if (penTipX >= tbWidth) {
        penTipX = 0;
        if (r < 0.5) {
          penTipY += leading*floor(random(3));
        } else penTipY += leading;
        //if (penTipY < tbHeight) break;
      }
    }
  }
  popMatrix();
}
