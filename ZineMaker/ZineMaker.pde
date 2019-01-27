// 2019 Birgit Bachler
// zine maker for Processing Community Day 2019

import java.io.File;
//import java.io.FilenameFilter;


//static final FilenameFilter pictFilter = new FilenameFilter() {
//  final String[] exts = {
//    ".jpg", ".png"
//  };

//  @ Override boolean accept(final File dir, String name) {
//    name = name.toLowerCase();
//    for (final String ext : exts)  if (name.endsWith(ext))  return true;
//    return false;
//  }
//};

//protected static final File[] getFolderContent(final File dir) {
//  return dir.listFiles(pictFilter);  //
//}

import processing.pdf.*;
PGraphicsPDF pdf;

int pdfwidth = 600;
int pdfheight = 800;
int margin = 20;


void setup() 
{
  size(600, 800, PDF, "zine.pdf");
  background(255);
}

void draw() {

  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(dataPath(""));

  // list the files in the data folder
  String[] filenames  = folder.list();  // get and display the number of jpg files
  println(filenames.length + " files in specified directory");

  //imageMode(CENTER);

  // COVER PAGE
  fill(random(255), random(255), random(255)); // to be replaced 
  rect(0, 0, width, height);
  fill(0);
  text("ZINE", width/2, height/2);

  PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();

  // WHITE PAGE
  fill(#FFFFFF);
  rect(0, 0, width, height);
  pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();

  // TOC
  int stop = margin*3;
  int pageCounter = 4;
  for (int i = 0; i < filenames.length; i++) {
    PImage img = loadImage(filenames[i]);

    if (img != null) { 
      fill(0);
      String tocEntry = filenames[i] + "........." + pageCounter;
      text(tocEntry, margin, stop);
      stop +=margin;
      pageCounter+=1;
    }
  }
  pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();


  // CONTENT
  for (int i = 0; i < filenames.length; i++) {
    fill(255);
    rect(0, 0, width, height);
    PImage img = loadImage(filenames[i]);

    if (img != null) { // check if loaded file is an image
      println(filenames[i], " ", img.width, " ", img.height);

      if (img.width > img.height) { // landscape
        println("Landscape");
        if (img.width >= pdfwidth-margin*2) {
          img.resize(pdfwidth-margin*2, 0);
        }
        image(img, margin, margin*4);
      } else if (img.width < img.height) { // portrait
        println("Portrait");
        if (img.height >= pdfheight-margin*2) {
          img.resize(0, pdfheight-margin*2);
        }
        image(img, margin, margin);
      } else { // square
        println("Square");
        if (img.height > pdfheight) {
          img.resize(0, pdfheight-margin*2);
        }
        image(img, margin, margin);
      }


      pdf = (PGraphicsPDF) g;  // Get the renderer
      pdf.nextPage();
    }
  }
  int add = 4-(pageCounter%4); 
  println("Your zine has  " + pageCounter + " pages." + add + " blank pages added.");



  // WHITE PAGES

  // LAST PAGE
  rect(100, 100, pdfwidth/2, pdfheight/2);
  fill(0);
  text(str(day())+"-"+str(month())+str(year())+"_"+str(hour())+":"+str(minute())+":"+str(second()), 10, 90); 

  exit();
}
