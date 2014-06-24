import processing.serial.*;
import mindset.*;
import java.io.*;


int participantNumber;

int nextLog = 500;
  
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

 if (millis() > nextLog) {
 	writeLog();
 	nextLog += 500;
 }

  
}

boolean sketchFullScreen() {
  return true;
}


void writeLog() {

 String timestamp = day() + "-" + month() + "-" + year() + "_" + hour() + ":" + minute();
 String fname = "bsr/" + participantNumber + "-calibration-" + timestamp + ".txt";

 String logline = System.currentTimeMillis() + "," + nextUpdate + "," + getCurrentWord();

 writeToFile(fname,logline);
 

}

void writeToFile(String filename,String line) {
  
  try {

	FileWriter fstream = new FileWriter(filename, true);
	BufferedWriter rawOut = new BufferedWriter(fstream);
	rawOut.write(line);
	rawOut.newLine(); 
	rawOut.close();}catch(Exception e){}
}
