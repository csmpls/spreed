

int baseline; //baseline reading speed
String[] txtarray;

int text_i = 0; //index of current word;
float nextUpdate=5000;


void setupText() {
  txtarray = txtflash.split(" ");
}


void drawTextFlashScreen() {
  
  if (keyPressed) {
    if (keyCode == LEFT) { // slower
      baseline+=5;
    } else if (keyCode == RIGHT) { //faster
      baseline-=5;
    }
    
    baseline = constrain(baseline,80,350);
    println(baseline);
  }
  
  fill(255);
  textSize(30);
  String w = getCurrentWord();
  float x_offset = textWidth(w) *.1;
  text(getCurrentWord(),(displayWidth/2)-x_offset,displayHeight/2);
}

String getCurrentWord() {
  if (showNewWord()) {
    text_i++;
    writeLog();
  }
  String word="";
  try {
    word = txtarray[text_i];
  } catch (Exception e) {
    exit();
  }
  
 return word;
}

boolean showNewWord() {
  if (millis() > nextUpdate) {
    nextUpdate = millis() + getNextUpdateTime();
    return true;
  }
  return false;
}

float getNextUpdateTime() {
  
  return baseline;

}

