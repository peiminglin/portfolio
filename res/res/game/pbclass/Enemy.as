package pbclass
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import pbclass.Charactor;

	public class Enemy extends Charactor
	{
		
	//	private static const actMcList:Array = [normal, jump, walk, hit, jumphit, sprint, sprinthit, superskill];
		//protected var actMcList:Array = new Array;
		protected var todoList:Array = new Array;
		protected var targetX:Number = 0;
		protected var targetY:Number = 0;
		public var AILevel:uint = 0;
		
	//	protected var mcFrame:Array = ["Normal","Walk","Hit", "Hitted", "Hittedaway", "Getup", "Die","Superskill","Jump","Jumphit","Sprint","Sprinthit", "Hit2", "Hit3"];
		protected static const damageList:Array = 	[0, 0, 4, 0, 0, 0, 0, 8];
		protected static const powerList:Array = 	[0, 0, 40, 0, 0, 0, 0, 100];
		
		public function Enemy(dx:Number=0, dy:Number=0):void
		{
			init(dx, dy);
			targetX = 0;
		}
		
		public function getDamage():Number
		{
			return damageList[this.status];
		}
		
		public function getPower():Number
		{
			return powerList[this.status];
		}

		
		public function action():void
		{
			var order:String = this.todoList[0];

			//
			switch (order)
			{

				case "move" :
					if (this.status == NORMAL || this.status == WALK)
					{
						setStatus(WALK);
						
						if ((this.dir == FACELEFT && this.targetX > this.px) ||
							(this.dir != FACELEFT && this.targetX < this.px))
							this.turnAround();
							
					}
					break;
					
				case "hit" :
					if (this.status == NORMAL || this.status == WALK)
					{
						setStatus(HIT);
						if ((this.dir == FACELEFT && this.targetX > this.px) ||
							(this.dir != FACELEFT && this.targetX < this.px))
							this.turnAround();

					}
					break;

				case "superskill" :
					if (this.status == NORMAL || this.status == WALK)
					{
						setStatus(SUPERSKILL);
						if ((this.dir == FACELEFT && this.targetX > this.px) ||
							(this.dir != FACELEFT && this.targetX < this.px))
							this.turnAround();

					}
					break;
					
				default :
					if (this.status == WALK)
					{
						setStatus(NORMAL);
					}
					break;

			}

		}
		
		public function updateData(cam:Camara):void
		{
			
			//actMcList = [this.normal, this.walk, this.hit, this.hitted, this.hittedaway, this.getup, this.die, this.superskill];
			
			updatePos(cam);
			
			this.damage = this.getDamage();
			this.power = this.getPower();
			
			if (this.standability < 100)
				this.standability ++;
			
			if (this.status == NORMAL)
			{
				if (this.targetX > 1)
					this.targetX --;
				else
					this.todoList.shift();
			}
			else if (this.status == WALK)
			{
				this.px += this.speedX*(this.targetX > this.px?1:-1);
						
				if (this.px - this.targetX < this.speedX && this.px - this.targetX < this.speedX)
					this.todoList.shift();

			}
			else if (this.status == HIT)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					setStatus(NORMAL);
					if (this.todoList[0] == "hit")
						this.todoList.shift();
				}
			}
			else if (this.status == SUPERSKILL)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					setStatus(NORMAL);
					if (this.todoList[0] == "superskill")
						this.todoList.shift();
				}
			}
			else if (this.status == HITTED)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					setStatus(NORMAL);
				}
			}
			else if (this.status == HITTEDAWAY)
			{
				if (this.py < GROUNDY)
					this.py += 10;
					
				if (this.currentAct.currentFrame < (this.currentAct.totalFrames>>1))
				{
					this.px += (this.dir == FACELEFT? this.speedX*2:-this.speedX*2);
				}
				else if (this.currentAct.currentFrame < this.currentAct.totalFrames*3/4)
				{
					this.px += (this.dir == FACELEFT? this.speedX:-this.speedX);
				}
				else if (this.currentAct.currentFrame == this.currentAct.totalFrames && this.py >= GROUNDY)
				{
					if (this.HP > 0)
					{
						setStatus(GETUP);
						this.py = GROUNDY;
					}
					else
						setStatus(DIE);
				}
			}else if (this.status == GETUP)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					setStatus(NORMAL);
					if (this.todoList[0] == "move" || this.todoList[0] == "normal")
					this.todoList.shift();
				}
			}
			else if (this.status == DIE)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					this.ifDead = true;
				}
			}
			
		}
		

	}
}