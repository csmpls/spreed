import processing.serial.*;
import mindset.*;
import java.io.*;


int participantNumber;
  
void setup() {
  
  // participant number290
  participantNumber = 9;
  
  // baseline reading speed
  baseline = 250;
  
  size(displayWidth,displayHeight);
  smooth();

  setupText();
  
}

void draw() {
  
  background(0);

 drawTextFlashScreen();

  
}

boolean sketchFullScreen() {
  return true;
}

