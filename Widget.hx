package ;
import WebcamInterface;
import flash.display.Sprite;

class Widget extends Sprite {
	
	public var pt : Point;
	public var slope : Float;
	var g : flash.display.Graphics;
	
	static inline var w = 560;
	static inline var h = 240;
	
	public function new() {
		super();
		pt = {x:0,y:0,};
		slope = 0;	
		g = this.graphics;	
	}
	
	public function draw() {
		
	}
}