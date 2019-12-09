package pbclass {
	
	public class EventPoint {
		public var px:Number;
		public var description:String;
		public var checked:Boolean;

		public function EventPoint(dx:Number, type:String){
			px = dx;
			description = type;
			checked = false;
		}
		
		public function checkEvent(cond:Boolean):String
		{
			if (checked == false && cond == true)
			{
				checked = true;
				return this.description;
			}
			else
				return "";
		}

	}
}
