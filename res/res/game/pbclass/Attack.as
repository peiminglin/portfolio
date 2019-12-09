package pbclass {
	import flash.display.MovieClip;
	
	public class Attack extends MovieClip{
		public var type:uint;
		public var px:Number;
		public var py:Number;
		public var dir:uint;
		public var power:uint;
		public var damage:uint;
		public var srcObj:String;
		public var targetObj:String;

		public function Attack() {
			type = 0;
			dir = 0;
			power = 0;
			damage = 0;
		}
		
		//update camera's position
		public function updateData(cam:Camara):void
		{
			this.x = cam.x + this.px;
			this.y = cam.y + this.py;
		}
	}
}
