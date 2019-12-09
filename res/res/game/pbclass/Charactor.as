package pbclass
{

	import flash.display.MovieClip;
	import pbclass.Attack;
	import pbclass.Camara;

	public class Charactor extends MovieClip
	{

		public var type:String;//absolute position
		public var px:Number;//absolute position
		public var py:Number;
		public var HP:Number;
		public var standability:Number;	//if standability reduced down to 0, charactor get kicked away.
		public var defence:Number;
		public var damage:Number;
		public var power:Number;		//power reduce opponent's standability
		public var ifDead:Boolean = false;
		public var ifAttack:Boolean = false;
		public var status:uint;
		public var dir:uint;
		public static const FACELEFT:uint = 0;
		public static const FACERIGHT:uint = 1 << 8;
		
		protected var camX:Number;//the position of the camara
		protected var camY:Number;
		protected var speedX:Number;
		protected var speedY:Number;
		protected var speedPX:Number;

		//all different move 
		protected static const NORMAL:uint = 0;
		protected static const WALK:uint = 1;
		protected static const HIT:uint = 2;
		protected static const HITTED:uint = 3;
		protected static const HITTEDAWAY:uint = 4;
		protected static const GETUP:uint = 5;
		protected static const DIE:uint = 6;
		protected static const SUPERSKILL:uint = 7;
		protected static const JUMP:uint = 8;
		protected static const JUMPHIT:uint = 9;
		protected static const SPRINT:uint = 10;
		protected static const SPRINTHIT:uint = 11;
		protected static const HIT2:uint = 12;
		protected static const HIT3:uint = 13;
		
		protected var currentAct:MovieClip;

		protected var GROUNDY:uint;

		protected static const JumpSpeed:Number = -20.0;
		protected var mcFrame:Array = ["Normal","Walk","Hit", "Hitted", "Hittedaway", "Getup", "Die","Superskill","Jump","Jumphit","Sprint","Sprinthit", "Hit2", "Hit3"];

		public function Charactor(dx:Number=0, dy:Number=0):void
		{
			init(dx, dy);
		}

		public function init(dx:Number, dy:Number):void
		{
			ifDead = false;
			this.px = dx;
			this.py = dy;
			GROUNDY = dy;
			speedX = 5;
			speedPX = 2;
			speedY = 0;
			HP = 100;
			standability = 100;
			defence = 0;
			dir = FACERIGHT;
			this.rotationY = 180;
			this.status = WALK;
			setStatus(NORMAL);
		}

		public function getStatus():String
		{
			return mcFrame[this.status];
		}
		
		public function setStatus(sta:uint):void
		{
			if (sta != this.status)
			{
				if (sta == JUMP && this.status != JUMP && this.status != JUMPHIT)
				{
					this.speedY = JumpSpeed;
				}
				
				this.gotoAndStop(mcFrame[sta]);
				this.currentAct = MovieClip(this.getChildAt(0));
				this.status = sta;
				
				if (sta == HIT || sta == HIT2 || sta == HIT3 || sta == JUMPHIT || sta == SPRINTHIT || sta == SUPERSKILL)
					this.ifAttack = true;
				else
					this.ifAttack = false;
			}
		}

		public function getAttacked(att:Attack):void
		{
			this.HP -= (att.damage*(1-this.defence));
			if (this.HP < 0)
				this.HP = 0;
			
			if (this.dir == att.dir)
				this.turnAround();
				
			if (this.standability - att.power > 0 && this.py > GROUNDY - 1 && this.HP > 0)
			{
				this.standability -= att.power;
				setStatus(HITTED);
			}
			else
			{
				this.standability = 100;
				setStatus(HITTEDAWAY);
			}
			
		}
	
		public function attack(obj:Charactor, att:Attack):Boolean
		{
			if (this.ifAttack == false)
				return false;
				
			var myAtt:MovieClip;
			var objAttb:MovieClip;
			var x1:Number;
			var x2:Number;
			var y1:Number;
			var y2:Number;
			
			myAtt = MovieClip(MovieClip(this.getChildAt(0)).getChildAt(1));
			objAttb = MovieClip(obj.getChildAt(0));
			objAttb = MovieClip(objAttb.getChildAt(0));
			
			if (myAtt.hitTestObject(objAttb))
			{
				att.dir = this.px > obj.px ? 0:(1<<8);
				x1 = myAtt.x + myAtt.parent.x + this.px;
				x2 = objAttb.x + objAttb.parent.x + obj.px;
				y1 = myAtt.y + myAtt.parent.y + this.py;
				y2 = objAttb.y + objAttb.parent.y + obj.py;
				
				//
				att.px = x2 + (this.px > obj.px ? 1:-1)*(objAttb.width/2);
				att.py = y2;
				return true;
			}
			else
				return false;
		}
		
		public function turnAround():void
		{
			this.dir = (this.dir == FACELEFT? FACERIGHT:FACELEFT);
			this.rotationY -=  180;
		}
		
		public function require():String
		{
		//	if (this.status == SUPERSKILL && this.superskill.currentFrame > 8 && this.superskill.currentFrame < 60)
		//		return "shake";
		//	else
				return "";
		}
		
		public function updatePos(cam:Camara):void
		{
			this.x = cam.x + this.px;
			this.y = cam.y + this.py;
		}
	}
}