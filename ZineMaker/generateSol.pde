Table LeWitt;
int total = 0;

PFont inst;
String[] pages ={"", "", "", ""};

boolean iDebug = false;
// true: print debug messages to console
// false: don't print debug messages to console

boolean onlineVersion = true; 
// true: download csv file from github repo (internet connection required)
// false: use local file

void generateSol() {
  inst = createFont("Courier", 6);

  if (onlineVersion) {
    LeWitt = loadTable("https://raw.githubusercontent.com/physicsdavid/pcd2019/master/coding-challenge/lewitt-instructions/LeWittInstructions.csv", "header");
  } else {
        LeWitt = loadTable("lewitt-instructions/LeWittInstructions.csv", "header"); 

  }
  
  if (iDebug) {
    println(LeWitt.getRowCount() + " instructions in table");
  }

  for (TableRow row : LeWitt.rows()) {
    String complete = row.getString("Complete");
    if (complete.equals("y")) {
      //println(nr + " (" + title + ") : " + instruction);
      total++;
    }
  }
  if (iDebug) {

    println(total + " complete instructions in table");
  }
  int counter = 1;
  int pagebreak = ceil(total/4.0);

  //println(pagebreak);
  int currentpage = 0;
  for (TableRow row : LeWitt.rows()) {
    int nr = row.getInt("Number");
    String title = row.getString("Title");
    String complete = row.getString("Complete");
    String instruction = row.getString("Instruction");
    if (complete.equals("y")) {
      //println(nr + " (" + title + ") : " + instruction);
      if (counter%pagebreak == 0) { // next Page, please!
        currentpage ++;
        if (iDebug) {
          println(currentpage);
        }
      }
      pages[currentpage] = pages[currentpage] + ">>> " + title + " " + instruction + "\n";
      counter++;
    }
  }
  fill(0);
  textFont(inst);
  pdf = (PGraphicsPDF) g;  // Get the renderer


  for (int i = 0; i<pages.length; i++) {
    // println("----------------------------------------PAGE " + i+1 +"----------------------------------------");

    //println(pages[i]);
    text(pages[i], margin, margin, pdfwidth-margin*2, pdfheight-margin*2);
    if (i<pages.length-1) {
      pdf.nextPage();
    }
  }
}
