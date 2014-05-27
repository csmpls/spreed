
MindSet mindset;

// experiment stuff
String entropyLogName;
String rawLogName;
int participantNumber;
BufferedWriter entropyOut;  
BufferedWriter rawOut;  
boolean is_connected = false;
int condition;

//entropy stuff
float[] raws;
int raws_i;
int sample_size = 128;
float entropy;
//deque for moving window - we use this for normalizing
Deque<Float> entropies;
int deque_size = 20;



void mindSetRawEvent(MindSet ms){
  try {
    raws_i++;
    if (raws_i > sample_size) {
      
      
      // this
      issue_python_command(get_cli_argument(raws));
      // ----
      
      raws = new float[sample_size];
      raws_i = 0;
      
      
      // LOG ENTROPIES
      if (is_connected) {
          
            FileWriter fstream = new FileWriter(entropyLogName, true);
            BufferedWriter entropyOut = new BufferedWriter(fstream);
            float up = getNextUpdateTime();
            // add date here
            entropyOut.write(System.currentTimeMillis() + "," + Float.toString(up) + "," + Float.toString(entropy));
            entropyOut.newLine(); 
            entropyOut.close();

        }
  
       
    }
    else {
      raws[raws_i] = ms.getCurrentRawData();
      
      if (is_connected) {
            
            FileWriter fstream = new FileWriter(rawLogName, true);
            BufferedWriter rawOut = new BufferedWriter(fstream);
            rawOut.write(System.currentTimeMillis() + "," + Float.toString(ms.getCurrentRawData()));
            rawOut.newLine(); 
            rawOut.close();

        }
      
      // log raw data
      
    }
  }
  catch (Exception e) { }

}




String get_cli_argument(float[] r) {
   String out = "";
   for (int i = 0; i < r.length; i++) {
    out += r[i] + " ";
   } 
   return out;
 }
 
 
 void issue_python_command(String arg) {
   
   try {
     
   // run the bash script (which in turn runs the python script
   // that delivers us our entropy value)
   Process proc= new ProcessBuilder("bash", sketchPath + "/entropy.sh", arg).start();

        BufferedReader stdInput = new BufferedReader(new 
             InputStreamReader(proc.getInputStream()));

        BufferedReader stdError = new BufferedReader(new 
             InputStreamReader(proc.getErrorStream()));

        // read the output from the command
        String s = null;
        while ((s = stdInput.readLine()) != null) {
            entropy = float(s);
            getNextUpdateTime();
            
            //add entropy to deque
            entropies.add(entropy);
            if (entropies.size() > deque_size) {
              entropies.removeFirst();
            }
        }

        // read any errors from the attempted command
        while ((s = stdError.readLine()) != null) {
            System.out.println(s);
        }
   
   } catch (Exception e) { println(e); }
   
   
 }
