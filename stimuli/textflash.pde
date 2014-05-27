ControlP5 cp5;
Chart myChart;

import java.util.regex.*;

int baseline; //baseline reading speed

int text_i = 0; //index of current word;
float nextUpdate;

float displaySpeeds[] = new float[2001]; // we use this for condition 1 - autoregressive process of order 1

String txtarray[]; //array of all texts
String txtflash;  // string containing the text we use for the trial

void setupText() {
  txtarray = txtflash.split(" ");
  
  if (condition == 1) {
    getSpeedsArray(baseline);
  }
}

void drawChartScreen() {
  
  if (keyPressed == true) {
    if (key == 'k' || key == 'K') {
      is_connected = true;
      cp5.getController("hello").remove();
      nextUpdate = millis() + 5000;
    }
  }
}

void drawTextFlashScreen() {
  fill(255);
  textSize(30);
  String w = getCurrentWord();
  float x_offset = textWidth(w) *.1;
  text(getCurrentWord(),(displayWidth/2)-x_offset,displayHeight/2);
}

String getCurrentWord() {
  if (showNewWord()) {
    text_i++;
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
  
  
  
    if (entropies.size() < deque_size)
      return baseline;
      
  float next_update = baseline;
  try {
    float normalized_entropy = normalize(entropies, entropy);
     next_update = baseline*(1 + (-0.2*normalized_entropy));
  } catch (Exception e) { println(e); }
  
    // push this value to the chart
    myChart.push("speed",next_update);

  // entropy-using condition
  if (condition == 0) {    
    return next_update;

  }
  
  // auto-regressive process of the order 1 -- we generate an array in setupText()
  if (condition == 1) {
    next_update = displaySpeeds[text_i];
    
    return next_update;
  }
  
  if (condition == 2) {
    return baseline;
  }
  
  return -1;
 
}


float normalize(Deque input_vector, float s) {
  float sum = findSum(input_vector);

  float average = sum/input_vector.size();
  float sd = findStandardDev(input_vector, average);

  float normalized = (s-average)/sd;
 
  return normalized;
 
}

float findStandardDev(Deque deq, float average) {
  Object[] arr = deq.toArray();
  float[] vector = new float[arr.length]; 

  for (int i=0; i<arr.length;i++)
  {
      vector[i] = (float)Math.pow((Float)arr[i] - average, 2);
  }
  
  // get average of vector
  float vector_avg = findSumAverage(vector);
  
  return (float)Math.sqrt(vector_avg);
}

float findSum(Deque deq) {
  Object[] arr = deq.toArray();
  float sum = 0;
  for (int i = 0; i<arr.length;i++) {
    float x = (Float)arr[i];
    sum+= x;
  } return sum;
}

float findSumAverage(float[] arr) {
  float sum = 0;
  for (int i = 0; i<arr.length;i++) {
    sum+= arr[i];
  } return sum/arr.length;
}





// get autoregressive speeds
void getSpeedsArray(float baseline) {
   
   try {
     
   // run the bash script (which in turn runs the python script
   // that delivers us our entropy value)
   Process proc= new ProcessBuilder("bash", sketchPath + "/ar1.sh", Float.toString(baseline)).start();

        BufferedReader stdInput = new BufferedReader(new 
             InputStreamReader(proc.getInputStream()));

        BufferedReader stdError = new BufferedReader(new 
             InputStreamReader(proc.getErrorStream()));

        // read the output from the command
        String s = null;
        while ((s = stdInput.readLine()) != null) {
          
             // now we have a string of a python array (i.e. "[25,3020,2110,300]"   
             // first, find everything inside square brackets
             Matcher m = Pattern.compile("\\[([^)]+)\\]").matcher(s);
             while (m.find()) {
               // now get all values by splitting at the commas
               String[] speeds = m.group(1).split(", ");
               
               //now we put these values in displaySpeeds
               for (int i = 0; i < speeds.length;i++) {
                 displaySpeeds[i] = Float.parseFloat(speeds[i]);
               }
             }

            
        }
        
        // read any errors from the attempted command
        while ((s = stdError.readLine()) != null) {
            System.out.println(s);
        }
   
   } catch (Exception e) { println(e); }
   
   
 }
