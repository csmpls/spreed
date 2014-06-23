import processing.serial.*;
import mindset.*;
import controlP5.*;
import java.io.*;
import java.lang.ProcessBuilder;
import java.util.Deque;
import java.util.LinkedList;
import java.lang.Math;


void setup() {
  
  // participant number
  participantNumber = 26;
  
  // baseline reading speed
  baseline = 260;
  
  // text number
  txtflash = txt[0];
  
  //condition code
  condition = 0;
  
  
  
  
  
  // raise baseline by 10%
  baseline = int(baseline + (baseline*.10));

  size(displayWidth, displayHeight);
  smooth();
  cp5 = new ControlP5(this);
  myChart = cp5.addChart("hello")
               .setPosition(10, 10)
               .setSize(100, 100)
               .setRange(baseline-(baseline*.2), baseline+(baseline*.2))
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;

  myChart.getColor().setBackground(color(255, 100));
  
    myChart.addDataSet("speed");
    myChart.setColors("speed", color(255,0,255),color(255,0,0));
    myChart.setData("speed", new float[50]);
    myChart.setStrokeWeight(2.5);
 
 
 String timestamp = day() + "-" + month() + "-" + year() + "_" + hour() + ":" + minute();
 
 entropyLogName = "bsr/" + participantNumber + "-" + condition + "-" + timestamp + ".txt";
 rawLogName = "bsr/" + participantNumber + "-" + condition + "-" + timestamp + "-raw.txt";

  
  mindset = new MindSet(this);
  mindset.connect("/dev/tty.MindWave");  
  raws = new float[sample_size];
  
  entropies = new LinkedList<Float>();
  
  setupText();
  
}

void draw() {
  
  background(0);
  
  if (!is_connected) {
    drawChartScreen();
  } else { 
    drawTextFlashScreen();
  }
  
  
}

boolean sketchFullScreen() {
  return true;
}


