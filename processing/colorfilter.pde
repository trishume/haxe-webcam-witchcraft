import hypermedia.video.*;
//import processing.video.*;
color colorSample = color (255,255,255);
float  sampleR;
float  sampleG;
float  sampleB;

int cam_width;
int cam_height;
int comb_width;
int comb_height;
boolean filtering = false;

int tresh = 50;

OpenCV opencv;
//Capture video;
LowPass lp;

 
void setup(){
  size(640,480);
  cam_width = 640;
  cam_height = 480;
  comb_width = cam_width;
  comb_height = cam_height;
  opencv = new OpenCV( this );  
  opencv.capture(cam_width,cam_height);
  //video = new Capture(this, width, height, 24);
  
  lp = new LowPass(10);  //The argument is the FIFO queue length
}

void draw(){
  //video.read();
  opencv.read();
  colorFilter();
}
int colorDistance(color c1,color c2){
 int dis=0;
 dis += pow(red(c1)-red(c2),2);
 dis += pow(green(c1)-green(c2),2);
 dis += pow(blue(c1)-blue(c2),2);
	     
 dis = round(sqrt(dis));
 return dis;   
}
//COLOR FILTER
void colorFilter(){
  int[] cam =  opencv.pixels();
  loadPixels();
 int rightmostx = 0;
 int leftmostx = cam_width;
 int rightmosty = 0;
 int leftmosty = 0;
  if (filtering){
     // rightmost/leftmost pixel
     
     for(int i=0;i<cam_width*cam_height;i++){ //loop through all the camera pixels
      /*float rval = red(cam[i]);
      float gval = green(cam[i]);
      float bval = blue(cam[i]);      
      float r = (sampleR / 3)*((bval - rval) + (bval - bval)); 
      float g = (sampleG / 3)*((bval - rval) + (bval - bval));
      float b = (sampleB / 3)*((bval - rval) + (bval - gval));*/
      float distance = colorDistance(colorSample,cam[i])*2;
      //cam[i] = color(255 - distance); //change each pixel
      
      //threshholding
      if (distance < tresh) { // If the pixel is brighter than the
        cam[i] = color(255); // threshold value, make it white
        // rightmost/leftmost pixel
        int x = i % cam_width;
        if (x <= leftmostx) {
          leftmostx = x;
          leftmosty = floor(i / cam_width);
        }
        if (x >= rightmostx) {
          rightmostx = x;
          rightmosty = floor(i / cam_width);
        }
      } 
      else { // Otherwise,
        cam[i] = color(0); // make it black
      }
     }     
  }  
 updatePixels();
 
 PImage comb = createImage(comb_width, comb_height, RGB);
   comb.loadPixels();
   for (int i = 0; i < comb_width*comb_height; i++) {
      comb.pixels[i] = cam [i];
    }
   //if(filtering) comb.filter(THRESHOLD);
   comb.updatePixels();
   image(comb,0,0);
   if(filtering) {
     noStroke();
     fill(0,0,255);
     ellipse(leftmostx, leftmosty, 20, 20);
     fill(0,255,0);
     ellipse(rightmostx, rightmosty, 20, 20);
     stroke(255,0,0);
     strokeWeight(4);
     line(leftmostx, leftmosty,rightmostx, rightmosty);
     
     float slope = float(rightmosty - leftmosty) / float(rightmostx - leftmostx);
     lp.input(-slope);
     text("slope: " + str(lp.output), 15, 30); 
   }
}

void mousePressed(){
  int loc = mouseX + mouseY*width;
  colorSample = pixels[loc];
  sampleR = red(colorSample);
  sampleG = green(colorSample);
  sampleB = blue(colorSample);
  filtering = true;
}

void keyPressed(){
  if(key=='q') {
    tresh--;
  }
  if(key=='w') {
    tresh++;
  }
  if(key=='f') {
    filtering = !filtering;
  } 
}

public void stop(){
  opencv.stop();//stop the object
  super.stop();
}
