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
 
 // Silkscreen Font by Jason Kottke  
 */

import java.io.File;

// Fonts used in the main zine
PFont Header;
PFont Txt;
PFont mono;

PShape coverdesign;

boolean autoGenerateInstructions = false; 
// if true the script will generate instructio pages from the latest github repo (experimental) 
// if false the most recent hand-layouted pages will be added (recommended)

boolean onlineInstructions = false;

boolean debug = false;


import processing.pdf.*;
PGraphicsPDF pdf;

int pdfwidth = 842;
int pdfheight = 1192;
int margin = 40;

String[] contributors = {};


void setup() 
{
  size(842, 1192, PDF, "zine.pdf");
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

  textAlign(CENTER);
  textFont(Header);
  pushMatrix();
  translate(pdfwidth/2, pdfheight-margin*2);
  rotate(radians(random(-45, 45)));
  fill(0);
  textSize(128);
  text("ZINE", 0, 0);

  popMatrix();

  PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the PDF renderer
  pdf.nextPage();

  // ========================================== IMPRESSUM ==========================================
  fill(#FFFFFF);
  rect(0, 0, width, height);
  textAlign(LEFT);
  textFont(mono);
  fill(0);
  //rect(width*.5, height-margin*6, width*.5-margin, margin*5);
  text("Curated by:\nBirgit Bachler (Wellington), Melanie Huang (Melbourne) & David Harris (Brisbane)\nThanks to:\nTristan Bunn, Tim Turnidge, Seth Ellis, Amari Low & The Processing Foundation\n\nPCDAUS/NZ has been made possible with the support of College of Creative Arts at Massey University Wellington, Queensland College of Art, Griffith University Brisbane\n2019", width*.2, height-margin*4, width*.8-margin, margin*5);


  textAlign(LEFT);

  pdf.nextPage();


  // ========================================== TOC ========================================== 
  fill(0);
  textSize(18);
  textAlign(LEFT);
  textFont(Header);
  text("Table of Contents", 20, margin*3);
  textFont(mono);

  boolean newcontributor = false; // initialise newcontributor variable 

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
          newcontributor = true; // add contributor from first entry
        } else {
          for (int j = 0; j<contributors.length; j++) { // loop through contributor array
            if (contributors[j].equals(items[1])) { // check if contributor name matches with any name in the array
              newcontributor = false; // this is not a new contributor
              if (debug) {
                println(items[1] + " is " + contributors[j]);
              }
            } else {
              newcontributor = true; // this is a new contributor
              if (debug) {
                println(items[1] + " is not " + contributors[j]);
              }
            }
          }
        }

        if (newcontributor==true) {
          contributors = append(contributors, items[1]); // append new contributor name to array
        }
      }
    }
  }

  pdf.nextPage();


  // ========================================== CONTENT ==========================================

  if (debug) {
    println("I will loop " + filenames.length + " times.");
  }
  for (int i = 0; i < filenames.length; i++) {

    if ((filenames[i].charAt(0)) != '.') { // check if not dotfile

      PImage img = loadImage("images/"+filenames[i]);

      if (img != null) { // check if loaded file is an image
        String filename = filenames[i];
        String[] items = split(filename, "|");
        if (debug) {
          println("Working on " + items[1] + "'s image which is number " + i);
        }
        String name = "Name: " + items[1];
        //String timestamp = "Timestamp: " + items[0];
        String location = "Location: " + items[2];
        String url = items[3].replace("-ESCCOLON-", ":").replace("-ESCSLASH-", "/");
        String instruction = items[4];
        instruction = "Instruction: " + instruction.substring(0, instruction.lastIndexOf('.')); // remove file name .png from last piece of string (here: instruction)

        fill(0);
        textFont(Txt);
        text(name, margin, pdfheight-100);
        text(location, margin, pdfheight-80);
        text(instruction, margin, pdfheight-60);
        textFont(mono);
        text(url, margin, pdfheight-40);



        if (img.width > img.height) { // landscape
          if (debug) {
            println("Landscape");
          }
          if (img.width >= pdfwidth-margin*2) {
            img.resize(pdfwidth-margin*2, 0);
          }
          image(img, margin, margin);
        } else if (img.width < img.height) { // portrait
          if (debug) {
            println("Portrait");
          }
          if (img.width >= pdfwidth-margin*2) {
            img.resize(pdfwidth-margin*2, 0);
          }

          image(img, margin, margin);
        } else { // square
          if (debug) {
            println("Square");
          }
          if (img.height > pdfheight) {
            img.resize(0, pdfheight-margin*2);
          }
          image(img, margin, margin);
        }
        pdf.nextPage();
      }
    }
  }




  // ========================================== WHITE PAGES ==========================================
  int add = 4-(pageCounter%4); // is the current total page count dividable by 4? otherwise add fill pages for double-sided printing
  for (int i=0; i<add; i++) {
    fill(255);
    rect(0, 0, width, height);
    pdf.nextPage();
  }
  println("Your zine has " + pageCounter + " pages. " + add + " blank pages added for easy double-sided printing. :)");



  // ========================================== INSTRUCTIONS ==========================================
  if (autoGenerateInstructions) {
    generateSol();
  } else 
  {
    String svgurl;
    // load manually layouted pages
    if (onlineInstructions) {
      svgurl = "https://raw.githubusercontent.com/physicsdavid/pcd2019/master/coding-challenge/lewitt-instructions/";
    } else {
      svgurl = "";
    }
    for (int i=1; i<5; i++) {
      String path = svgurl + "ZineInstructions-" + nf(i, 2) + ".svg";
      if (debug) {
        println("Adding " + path);
      }
      PShape instPage=loadShape(path);
      shape(instPage, 0, 0, pdfwidth, pdfheight);
      pdf.nextPage();
    }
  }

  // ========================================== LAST PAGE ==========================================

  String credits = "With contributions from: ";

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

  text("Zine generated on "+str(day())+"-"+str(month())+"-"+str(year())+"_"+str(hour())+":"+str(minute()) + " with", margin*2, pdfheight-margin*1.5); 

  text("https://github.com/iRGBit/ZineMaker", margin*2, pdfheight-margin-3);




  // ========================================== BYE ==========================================

  String[] yay = {"Yay!", "Hooray", "Weeeee", "Tau Ke!", "You know what?", "Woo Hoo", "Ka mau te wehi!", "Hip Hip Hooray!", "Good news everyone!"};
  String[] goodbye = {"Bye!", "See ya!", "Laters!", "Haere Ra!", "Over and out"};

  println(yay[int(random(yay.length))]);
  println("Your zine is ready. Thank you for your patience.");
  println(goodbye[int(random(goodbye.length))]);

  exit();
}
