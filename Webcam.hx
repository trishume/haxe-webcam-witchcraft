import flash.Memory;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;

class Webcam {
		var mc : flash.display.MovieClip;
    var rawvideo : flash.media.Video;
    var cam:flash.media.Camera;
		var canvasBitmapData : flash.display.BitmapData;
		var canvas:flash.display.Bitmap;
		
		var sample : ColorConverter.RGB;
		var filtering : Bool;
		var thresh : Int;
		
		
		var interf : WebcamInterface;

    static function main() {
			var wc : Webcam;
			wc = new Webcam();
			wc.display();
			//trace("started");
    }
		public function new() {
			cam = flash.media.Camera.getCamera();
			cam.setMode(320, 240, 40, false);
			cam.setQuality(0, 100);
			
			mc=flash.Lib.current;
			var stage = flash.Lib.current.stage;
			stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;
			rawvideo = new flash.media.Video(Std.int(stage.width), Std.int(stage.height) );
			rawvideo.attachCamera(cam);
			rawvideo.scaleX = 2;
			rawvideo.scaleY = 2;
			
			canvasBitmapData = new flash.display.BitmapData(320,240);
			
			canvasBitmapData.draw(rawvideo);
			
			canvas = new flash.display.Bitmap(canvasBitmapData);
			canvas.scaleX = 2;
			canvas.scaleY = 2;
			//mc.addChild(canvas);
			
			filtering = false;
			thresh = 35;
			
			interf = new WebcamInterface();
			
			
			mc.addEventListener(flash.events.Event.ENTER_FRAME,onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK,mouseClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);	
			//trace("added events");		
		}
		public function display() {
			if (cam!=null) {
			  mc.addChild(rawvideo);
				mc.addChild(canvas);
				mc.addChild(interf);
				//interf.draw();
			} else {
			  trace("No Camera") ;
			}
		}
		private function blobsFill() {
			var white = 0x00ffffff;
			for (i in 0...15)  
			{  
			    // get the rectangle containing only white pixels  
			    var mainRect = canvasBitmapData.getColorBoundsRect(0xffffffff, 0xffffffff);  

			    // exit if the rectangle is empty  
			    if (mainRect.isEmpty()) break;  

			    // get the first column of the rectangle  
			    var x:Int = Math.floor(mainRect.x);  
					
			    // examine pixel by pixel unless you find the first white pixel  
			    for (y in Math.floor(mainRect.y)...Math.floor(mainRect.y + mainRect.height))  
			    {
							
			        if ((canvasBitmapData.getPixel32(x, y) & 0x00ffffff) == white)  
			        {  
									interf.message = "yay";
			            // fill it with some color  
			            canvasBitmapData.floodFill(x, y, 0xffff55ff);  

			            // get the bounds of the filled area - this is the blob  
			            var blobRect = canvasBitmapData.getColorBoundsRect(0x00ffffff, 0xffff55ff);  

			            // check if it meets the min and max width and height  
			            if (blobRect.width > 50 && blobRect.height > 300)  
			            {  
			                // if so, add the blob rectangle to the array  
			                canvasBitmapData.floodFill(x, y, 0xff00ff00);			  
			            }  else {

			            	// mark blob as processed with some other color  
			            	canvasBitmapData.floodFill(x, y, 0xff0000ff);  
									}
			        }  
			    }   
			}
		}
		private function doFastMem() {
			
			var byteArray = canvasBitmapData.getPixels(canvasBitmapData.rect);
			
			byteArray.position = 0;
			
			Memory.select(byteArray);
			
			var i : UInt = 0;
			var len: UInt = 320*240 * 4;
			
			var leftmost : WebcamInterface.Point = {x:0,y:0,};
			var rightmost : WebcamInterface.Point = {x:320,y:0,};
			
			while (i < len) {
				var color = ColorConverter.toRGB(Memory.getI32(i));
				var distance = ColorConverter.colorDistance(color,sample);
	      //cam[i] = color(255 - distance); //change each pixel

	      //threshholding
	      if (distance < thresh) { // If the pixel is brighter than the
	        color = {r: 0xFF,g: 0xFF,b: 0xFF,a:0xFF,}; // threshold value, make it white
	
	        // rightmost/leftmost pixel
	        var x = (i >> 2) % 320;
	        if (x >= leftmost.x) {
	          leftmost.x = x;
	          leftmost.y = Math.floor((i >> 2) / 320);
	        }
	        if (x <= rightmost.x) {
	          rightmost.x = x;
	          rightmost.y = Math.floor((i >> 2) / 320);
	        }
	      } else { // Otherwise,
	        color = {r: 0x00,g: 0x00,b: 0x00,a:0x00,}; // make it black
	      }
				Memory.setI32(i,ColorConverter.toInt(color,0x50));
				//var u:UInt = Std.int(i / 8) << 8;
				//Memory.setI32(i, u);
				i += 4;
			}

			interf.setPoints(leftmost,rightmost);
			interf.draw();
			
			canvasBitmapData.setPixels(canvasBitmapData.rect, byteArray);
			// test();
			
		}
		private function onEnterFrame(_) : Void {
			canvasBitmapData.draw(rawvideo);
			//canvasBitmapData.noise(Math.round(Math.random()*500));
			if(filtering){
				doFastMem();
				blobsFill();
			}
			
			
			
		}
		function mouseClick(e:MouseEvent) {
			//trace("click");
			canvasBitmapData.draw(rawvideo);
      var pix = canvasBitmapData.getPixel32(Math.round(e.localX / 2),Math.round(e.localY / 2));
			//trace(pix);
      sample = ColorConverter.toRGB2(pix);
			filtering = true;
		}
		function keyDown(e:KeyboardEvent) {
			
			if(e.keyCode == 81) { //Q
				thresh += 5;
				interf.message = "threshhold: " + thresh;
			} else if(e.keyCode == 87) { //W
				thresh -= 5;
				interf.message = "threshhold: " + thresh;
			}	else if(e.keyCode == 70) { //F
				filtering = false;
				interf.message = "filtering stopped.";
			}	else if(e.keyCode == 83) { //F
				interf.single = !interf.single;
				interf.message = "Single point mode toggled.";
			} else if(e.keyCode == 73) { //F
				interf.message = "Hold up a coloured object and click it. Q&W = threshhold, S = Single point mode, ";
			} else {
				interf.message = "key: " + e.keyCode;
			}
		}
		
}
