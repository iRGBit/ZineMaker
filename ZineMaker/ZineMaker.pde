/*
       .__                              __                 
 _______|__| ____   ____   _____ _____  |  | __ ___________ 
 \___   /  |/    \_/ __ \ /     \\__  \ |  |/ // __ \_  __ \
 /    /|  |   |  \  ___/|  Y Y  \/ __ \|    <\  ___/|  | \/
 /_____ \__|___|  /\___  >__|_|  (____  /__|_ \\___  >__|   
 \/       \/     \/      \/     \/     \/    \/       
 
 2019 Birgit Bachler
 http://irgbit.github.com/ZineMaker  
 ZineMaker for Processing Community Day Wellington/Brisbane/Melbourne 2019
 GNU GENERAL PUBLIC LICENSE v3.0  
 */

import java.io.File;

PFont Header;
PFont Txt;
PFont mono;

PShape coverdesign;


import processing.pdf.*;
PGraphicsPDF pdf;

int pdfwidth = 600;
int pdfheight = 800;
int margin = 40;

String[] contributors = {};


void setup() 
{
  size(600, 800, PDF, "zine.pdf");
  background(255);
  Header = createFont("Silkscreen", 32);
  Txt = createFont("Silkscreen", 16);
  mono = createFont("Courier", 12);
}

void draw() {

  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(dataPath("images/"));

  // list the files in the data folder
  String[] filenames  = folder.list();  // get and display the number of jpg files
  println(filenames.length + " files in specified directory");

  // ========================================== COVER PAGE ==========================================
  fill(255); 
  rect(0, 0, width, height);

  coverdesign = loadShape("zine-cover.svg");
  shape(coverdesign, 0, 0, pdfwidth, pdfheight);
  fill(0);
  textSize(222);
  textAlign(CENTER);
  textFont(Header);
  pushMatrix();
  translate(pdfwidth/2, pdfheight-margin*2);
  rotate(radians(random(-45, 45)));
  text("ZINE", 0, 0);

  popMatrix();

  PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();

  // ========================================== IMPRESSUM ==========================================
  fill(#FFFFFF);
  rect(0, 0, width, height);
  textAlign(LEFT);
  textFont(Txt);
  fill(0);
  //rect(width*.5, height-margin*6, width*.5-margin, margin*5);
  text("Curated by: Birgit Bachler (Wellington), Melanie Huang (Melbourne), David Harris (Brisbane)", width*.5, height-margin*4, width*.5-margin, margin*5);
  textAlign(LEFT);

  pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();


  // ========================================== TOC ========================================== 
  fill(0);
  textSize(18);
  textAlign(LEFT);
  textFont(Header);
  text("Table of Contents", 20, margin*3);
  textFont(mono);

  boolean newcontributor = false;

  int stop = margin*4;
  int pageCounter = 4;
  for (int i = 0; i < filenames.length; i++) {
    if ((filenames[i].charAt(0)) != '.') { // check if not dotfile
      PImage img = loadImage("images/"+filenames[i]);

      if (img != null) { 
        fill(0);
        String filename = filenames[i];
        String[] items = split(filename, "|");
        String tocEntry = items[1] +", #" + items[4].substring(0, items[4].lastIndexOf('.')) +"   page "+ pageCounter;
        text(tocEntry, margin, stop);
        stop +=18;
        pageCounter+=1;
        if (contributors.length == 0) {
          newcontributor = true;
        } else {
          for (int j = 0; j<contributors.length; j++) {
            if (contributors[j].equals(items[1])) {
              newcontributor = false;
              // println(items[1] + " is " + contributors[j]);
            } else {
              newcontributor = true;
              // println(items[1] + " is not " + contributors[j]);
            }
          }
        }

        if (newcontributor==true) {
          contributors = append(contributors, items[1]);
        }
      }
    }
  }



  pdf = (PGraphicsPDF) g;  // Get the renderer
  pdf.nextPage();


  // ========================================== CONTENT ==========================================
  println("I will loop " + filenames.length + " times.");
  for (int i = 0; i < filenames.length; i++) {

    if ((filenames[i].charAt(0)) != '.') { // check if not dotfile

      PImage img = loadImage("images/"+filenames[i]);

      if (img != null) { // check if loaded file is an image
        String filename = filenames[i];
        String[] items = split(filename, "|");

        println("Working on " + items[1] + "'s image which is number " + i);

        String name = "Name: " + items[1];
        //String timestamp = "Timestamp: " + items[0];
        String location = "Location: " + items[2];
        String url = items[3].replace("-ESCCOLON-", ":").replace("-ESCSLASH-", "/");
        String instruction = items[4];
        instruction = "Instruction: " + instruction.substring(0, instruction.lastIndexOf('.'));

        fill(0);
        textFont(Txt);
        text(name, margin, pdfheight-100);
        text(location, margin, pdfheight-80);
        text(instruction, margin, pdfheight-60);
        textFont(mono);
        text(url, margin, pdfheight-40);



        if (img.width > img.height) { // landscape
          println("Landscape");
          if (img.width >= pdfwidth-margin*2) {
            img.resize(pdfwidth-margin*2, 0);
          }
          image(img, margin, margin*4);
        } else if (img.width < img.height) { // portrait
          println("Portrait");
          if (img.width >= pdfwidth-margin*2) {
            img.resize(pdfwidth-margin*2, 0);
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
  }



  // ========================================== WHITE PAGES ==========================================
  int add = 4-(pageCounter%4); 
  for (int i=0; i<add; i++) {
    fill(255);
    rect(0, 0, width, height);
    pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();
  }
  println("Your zine has " + pageCounter + " pages. " + add + " blank pages added for double-sided printing.");

  // LAST PAGE
  String credits = "With contributions from: ";
  //println(contributors);
  for (int c=0; c<contributors.length; c++) {
    if (c==contributors.length-1) {
      credits = credits + contributors[c];
    } else {
      credits = credits + contributors[c] + " | ";
    }
  }

  fill(0);
  rect(margin, margin, pdfwidth-margin*2, pdfheight-margin*2);

  fill(255);
  textFont(Txt);

  text(credits, margin*2, margin*2, pdfwidth-margin*4, pdfheight-margin*4);

  text("Zine generated on "+str(day())+"-"+str(month())+"-"+str(year())+"_"+str(hour())+":"+str(minute()), margin*2, pdfheight-margin*2); 
  text("MYO with https://github.com/iRGBit/ZineMaker", margin*2, pdfheight-margin);

  // ========================================== BYE ==========================================

  String[] yay = {"Yay!", "Hooray", "Weeeee", "Tau Ke!", "You know what?", "Woo Hoo", "Ka mau te wehi!"};
  String[] goodbye = {"Bye!", "See ya!", "Laters!", "Haere Ra!", "Over and out"};

  println(yay[int(random(yay.length))]);
  println("Your zine is ready. Thank you for your patience.");
  println(goodbye[int(random(goodbye.length))]);

  exit();
}
