// Stringifier Test v0.1
// Load Image with metadata in filename naming convention
// Add images to datafolder with following file name convention: 
// Timestamp|Your Name|InstructionNr|Url.extension
// 12345|Ada Lovelace|25|Wellington|http://awesomeurl/yo.com.png

import java.io.File;

PImage img;

void setup() {
  size (600, 600);
  java.io.File folder = new java.io.File(dataPath(""));
  String[] filenames  = folder.list();  // get and display the number of jpg files
  println(filenames.length + " files in specified directory");

  for (int i = 0; i < filenames.length; i++) {
    PImage img = loadImage(filenames[i]);

    if (img != null) { 
      String filename = filenames[i];
      String[] items = split(filename, "|");
      println(items.length);
      for (i =0; i<items.length; i++) {
        println(items[i]);
      }

      if (items.length != 5) {
        fill(#FF0000);
        text("Wrong file name.", 20, 20);
        text("Should be something like:", 20, 40);
        fill(0);
        text("12345|Ada Lovelace|25|Wellington|http://awesomeurl/yo.com.png", 20, 60);
      } else {
        fill(0);
        String name = "Name: " + items[1];
        String timestamp = "Timestamp: " + items[0];
        String location = "Location: " + items[2];
        String url = items[3].replace("-ESCCOLON-", ":").replace("-ESCSLASH-", "/");
        //url = url.substring(0, url.lastIndexOf('.'));
        String instruction = items[4];
        instruction = "Instruction: " + instruction.substring(0, instruction.lastIndexOf('.'));

        text(name, 20, 20);
        text(timestamp, 20, 40);
        text(url, 20, 60);
        text(location, 20, 80);
        text(instruction, 20, 100);
        img.resize(width-40, 0);
        image(img, 20, 120);

      }
    }
  }
}


void draw() {
}
