package ;
import flash.display.Sprite;

class WebcamInterface extends Sprite {
	var mc : flash.display.MovieClip;
	
	public var leftmost : Point;
	public var rightmost : Point;
	
	public var single : Bool;
	
	public var message : String;
	
	var p : flash.text.TextField;
	var slope : flash.text.TextField;
	
	var curWidget : Widget;
	
	public function new() {
		super();
		mc=flash.Lib.current;
		//var stage = flash.Lib.current.stage;
		single = false;
		message = "Welcome to Witchcraft Pre-Alpha 0.0.1 - Press I for instructions";
		
		leftmost = {x:50,y:50,};
		rightmost = {x:80,y:80,};
		
		p = new flash.text.TextField();
    p.text=message;
    p.textColor=0xFFFFFF;
		p.antiAliasType = flash.text.AntiAliasType.ADVANCED;
		p.width = 640;
		p.alpha = 0.7;
    this.addChild(p);

		slope = new flash.text.TextField();
    slope.textColor=0xFFFFFF;
		slope.alpha = 0.7;
		slope.visible = false; 
    this.addChild(slope);

		curWidget = new PointerWidget();
		curWidget.x = 640;
		this.addChild(curWidget);
	}
	public function setPoints(p1 : Point,p2 : Point) {
		leftmost = p1;
		rightmost = p2;
		leftmost.x *= 2;
		leftmost.y *= 2;
		rightmost.x *= 2;
		rightmost.y *= 2;
	}
	public function draw() {
		var g = this.graphics;
		g.clear();
		
		var middle : Point = {x:(leftmost.x + rightmost.x) >> 1,y:(leftmost.y + rightmost.y) >> 1,};
		//widget
		curWidget.pt = middle;
		curWidget.draw();
		
		
		var dist = Math.sqrt(Math.pow(leftmost.x - rightmost.x,2) + Math.pow(leftmost.y - rightmost.y,2));
		if(dist > 50 && !single && leftmost.x != 0) {
			g.beginFill(0xFF0000);
			g.drawCircle(leftmost.x,leftmost.y,10);
			g.beginFill(0x00FF00);
			g.drawCircle(rightmost.x,rightmost.y,10);
			g.beginFill(0x0000FF);
			g.lineStyle(2, 0xFF00FF);
			g.moveTo(leftmost.x,leftmost.y);
			g.lineTo(rightmost.x,rightmost.y);
			
			slope.x = middle.x;
			slope.y = middle.y;
			slope.text = "slope: " + -((leftmost.y - rightmost.y)/(leftmost.x - rightmost.x));
			slope.visible = true;
		} else if(leftmost.x != 0){
			g.beginFill(0x0000FF);
			g.drawCircle(middle.x,middle.y,20);
			slope.visible = false;
		} else {
			slope.visible = false;
		}
		p.text = message;
	}
}
typedef Point = {
	var x : Int;
	var y : Int;
}