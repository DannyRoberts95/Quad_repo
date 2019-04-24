String[] code;

int fontSize = 12;
float leading = fontSize*1.25;

void settings(){
size(1000,1000);
}

void setup(){
  code = loadStrings("code.txt");
}
void draw(){
  background(0);
  fill(255);
  for(int i=0; i < code.length; i++){
  if(code[i] == "" || code[i] == " " || code[i] == "n/") continue; 
  text(code[i].toUpperCase(,0,i*leading,width, height);
  }
  
}
