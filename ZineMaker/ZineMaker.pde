// 2019 Birgit Bachler
// zine maker for Processing Community Day 2019

import java.io.File;


import processing.pdf.*;
PGraphicsPDF pdf;

int pdfwidth = 600;
int pdfheight = 800;
int margin = 20;

String[] contributors = {};


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

  // COVER PAGE
  fill(random(255), random(255), random(255)); // to be replaced 
  rect(0, 0, width, height);
  fill(0);
  textSize(66);
  textAlign(CENTER);
  text("ZINE", width/2, height/2);

  PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();

  // WHITE PAGE
  fill(#FFFFFF);
  rect(0, 0, width, height);
  pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();

  // TOC
  fill(0);
  textSize(18);
  textAlign(LEFT);
  text("Table of Contents", 20, margin*2);
  textSize(12);

  boolean newcontributor = false;


  int stop = margin*4;
  int pageCounter = 4;
  for (int i = 0; i < filenames.length; i++) {
    PImage img = loadImage(filenames[i]);

    if (img != null) { 
      fill(0);
      String filename = filenames[i];
      String[] items = split(filename, "|");
      String tocEntry = items[1] +"   page "+ pageCounter;
      text(tocEntry, margin, stop);
      stop +=margin;
      pageCounter+=1;
      if (contributors.length == 0) {
        newcontributor = true;
      } else {
        for (int j = 0; j<contributors.length; j++) {
          if (contributors[j].equals(items[1])) {
            newcontributor = false;
            println(items[1] + " is " + contributors[j]);
          } else {
            newcontributor = true;
            println(items[1] + " is not " + contributors[j]);
          }
        }
      }

      if (newcontributor==true) {
        contributors = append(contributors, items[1]);
      }
    }
  }



  pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();


  // CONTENT
  println("I will loop " + filenames.length + " times.");
  for (int i = 0; i < filenames.length; i++) {

    PImage img = loadImage(filenames[i]);

    if (img != null) { // check if loaded file is an image
      String filename = filenames[i];
      String[] items = split(filename, "|");

      println("Working on " + items[1] + "'s image which is number " + i);

      String name = "Name: " + items[1];
      String timestamp = "Timestamp: " + items[0];
      String location = "Location: " + items[2];
      String url = items[3].replace("-ESCCOLON-", ":").replace("-ESCSLASH-", "/");
      //url = url.substring(0, url.lastIndexOf('.'));
      String instruction = items[4];
      instruction = "Instruction: " + instruction.substring(0, instruction.lastIndexOf('.'));

      fill(0);
      text(name, 20, pdfheight-100);
      text(url, 20, pdfheight-80);
      text(location, 20, pdfheight-60);
      text(instruction, 20, pdfheight-40);

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
    }
    pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();
  }



  // WHITE PAGES
  int add = 4-(pageCounter%4); 
  for (int i=0; i<add; i++) {
    fill(255);
    rect(0, 0, width, height);
    pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();
  }
  println("Your zine has  " + pageCounter + " pages." + add + " blank pages added.");

  // LAST PAGE
  String credits = "With contributions from: ";
  //println(contributors);
  for (int c=0; c<contributors.length; c++) {
    credits = credits + contributors[c] + " | ";
  }

  fill(0);
  rect(margin, margin, pdfwidth-margin*2, pdfheight-margin*2);

  fill(255);
  text(credits, margin*2, margin*2, pdfwidth-margin*4, pdfheight-margin*4);
  
  
  text("Generated on "+str(day())+"-"+str(month())+"-"+str(year())+"_"+str(hour())+":"+str(minute()), margin*2, pdfheight-margin*2); 
  println("Your zine is ready. Thank you for your patience.");
  exit();
}
