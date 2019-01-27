// 2019 Birgit Bachler
// zine maker for Processing Community Day 2019

import java.io.File;
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
  fill(#F80A2B);
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

  pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();


  // CONTENT
  for (int i = 0; i < filenames.length; i++) {
    fill(255);
    rect(0, 0, width, height);
    PImage img = loadImage(filenames[i]);
    println(filenames[i], " ", img.width, " ", img.height);

    if (img.width > img.height) { // landscape
      println("Landscape");
      if (img.width >= pdfwidth-margin*2) {
        img.resize(pdfwidth-margin*2, 0);
        image(img, margin, margin*4);
      }
    } else if (img.width < img.height) { // portrait
      println("Portrait");
      if (img.height >= pdfheight-margin*2) {
        img.resize(0, pdfheight-margin*2);
        image(img, margin, margin);
      }
    } else { // square
      println("Square");
      if (img.height > pdfheight) {
        img.resize(0, pdfheight-margin*2);
        image(img, margin, margin);
      }
    }

    pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();
  }

  // WHITE PAGES

  // LAST PAGE
  rect(100, 100, pdfwidth/2, pdfheight/2);
  fill(0);
  text(str(day())+"-"+str(month())+str(year())+"_"+str(hour())+":"+str(minute())+":"+str(second()), 10, 90); 

  exit();
}