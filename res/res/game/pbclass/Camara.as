package pbclass {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import pbclass.Charactor;
	
	public class Camara {
		private var speedX: Number;
		private var speedY: Number;
		private var offsetX: Number;
		private var offsetY: Number;
		private var focusX:Number;
		private var focusY:Number;
		private var GROUNDY:Number;
		public var x:Number;
		public var y:Number;
		public var style:String;

		public function Camara(px:Number, py:Number) {
			speedX = 0;
			speedY = 0;
			offsetX = 0;
			offsetY = 0;
			focusX = px;
			focusY = py;
			GROUNDY = py;
		}
		
		public function focusOn(px:Number, py:Number):void
		{
			this.focusX = px;
			this.focusY = py;
		}
		
		public function updateData(stg:Stage):void
		{
			if (this.style == "shake")
				this.shake();
			else
				this.normal();
				
			this.x = stg.stageWidth/2 - this.x;
			this.y = this.GROUNDY - this.y;
			
		}
		
		public function normal():void
		{
			offsetY = 0;
			offsetX = 0;
			this.x = focusX + offsetX;
			this.y = focusY + offsetY;
		}
		
		public function shake():void
		{
			offsetY = Math.round(Math.random()*10) - 5;
			offsetX = Math.round(Math.random()*2) - 1;
			this.x = focusX + offsetX;
			this.y = focusY + offsetY;
		}
		
	}
}
