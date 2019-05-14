String[] code;

void settings(){
size(1000,1000);
}

void setup(){
  code = loadStrings("code.txt");
}
void draw(){
  background(0);
  fill(255);
  
  text(code[0],0,0,width, height);
}
