package pbclass {
	import flash.display.Stage;
	import flash.display.MovieClip;
	import pbclass.Camara;
	
	public class Food extends MovieClip {
		public var type:Number;
		public var energy:Number;
		public var px:Number;
		public var py:Number;

		public function Food(dx:Number = 0, dy:Number = 0, tp:Number = 0):void {
			this.px = dx;
			this.py = dy;
			this.type = tp;
			this.energy = (tp+1)*25;
			gotoAndStop(tp+1);
		}

		public function updateData(cam:Camara):void
		{				
			this.x = cam.x + this.px;
			this.y = cam.y + this.py;
		}
	}
}
