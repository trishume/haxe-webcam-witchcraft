package ;
import Widget;

class PointerWidget extends Widget {
	override public function draw() {
		var ratio = Widget.w / 640;
		var px = (640 - pt.x) * ratio;
		g.beginFill(0xFF0000);
		g.drawCircle(px,pt.y,20);
	}
}