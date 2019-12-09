package pbclass
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import pbclass.Charactor;

	public class Hero extends Charactor
	{
		
	//	private static const actMcList:Array = [normal, jump, walk, hit, jumphit, sprint, sprinthit, superskill];
	//	protected var actMcList:Array;
	//	protected var mcFrame:Array = ["Normal","Walk","Hit", "Hitted", "Hittedaway", "Getup", "Die","Superskill","Jump","Jumphit","Sprint","Sprinthit", "Hit2", "Hit3"];
		protected static const damageList:Array = 	[0, 0, 30, 0, 0, 0, 0, 50, 0, 20, 0, 15, 15, 10];
		protected static const powerList:Array = 	[0, 0, 30, 0, 0, 0, 0, 100, 0, 50, 0, 100, 30, 50];
		public var stamina:Number = 0;
		public var level:uint = 0;
		
		
		public function Hero(dx:Number=0, dy:Number=0):void
		{
			init(dx, dy);
			stamina = 0;
		}
		
		public function getDamage():Number
		{
			return damageList[this.status];
		}
		
		public function getPower():Number
		{
			return powerList[this.status];
		}
		
		public function action(order: String):void
		{
			//
			switch (order)
			{
				case "move left" :
					if (this.status == NORMAL || this.status == WALK)
					{
						this.px -=  this.speedX;
						setStatus(WALK);
						if (this.dir != FACELEFT)
						{
							this.turnAround();
						}
					}
					else if (this.status == JUMP||this.status == JUMPHIT)
					{
						this.px -=  this.speedX + this.speedPX;
					}
					break;

				case "move right" :
					if (this.status == NORMAL || this.status == WALK)
					{
						setStatus(WALK);
						if (this.dir == FACELEFT)
						{
							this.turnAround();
						}
						this.px +=  this.speedX;
					}
					else if (this.status == JUMP||this.status == JUMPHIT)
					{
						this.px +=  this.speedX + this.speedPX;
					}
					break;

				case "sprint left" :
					if (this.status == NORMAL || this.status == WALK)
					{
						setStatus(SPRINT);
						if (this.dir != FACELEFT)
						{
							this.turnAround();
						}
					}
					break;

				case "sprint right" :
					if (this.status == NORMAL || this.status == WALK)
					{
						setStatus(SPRINT);
						if (this.dir == FACELEFT)
						{
							this.turnAround();
						}
					}
					break;

				case "jump" :
					if (this.status == NORMAL || this.status == WALK || this.status == SPRINT)
					{
						setStatus(JUMP);
					}
					break;

				case "hit" :
					if (this.status == NORMAL || this.status == WALK)
					{
						setStatus(HIT);
					}
					else if (this.status == JUMP)
					{
						setStatus(JUMPHIT);
					}
					else if (this.status == SPRINT)
					{
						setStatus(SPRINTHIT);
					}
					else if (this.status == HIT && this.currentAct.currentFrame > 3)
					{
						setStatus(HIT2);
					}
					else if (this.status == HIT2 && this.currentAct.currentFrame > 3)
					{
						setStatus(HIT3);
					}
					break;

				case "super skill" :
					if (this.status == NORMAL || this.status == WALK)
					{
						if (this.stamina >= 16)
						{
							this.stamina -= 16;
							setStatus(SUPERSKILL);
						}
						else if(this.HP > 5)
						{
							this.HP = this.HP >> 1;
							setStatus(SUPERSKILL);
						}
					}
					break;

				default :
					if (this.status == WALK)
					{
						setStatus(NORMAL);
					}
					break;

			}

			//movable area checking;
			/*
			if (this.x < 0)
			this.x = 0;
			if (this.x > stage.stageWidth)
			this.x = stage.stageWidth;
			if (this.y < 0)
			this.y = 0;
			if (this.y > stage.stageHeight)
			this.y = stage.stageHeight;
			*/
		}
		
		public function updateData(cam:Camara):void
		{
		//	actMcList = [this.normal, this.walk, this.hit, this.hitted, this.hittedaway, this.getup, this.die, this.superskill, this.jump, this.jumphit, this.sprint, this.sprinthit, this.hit2, this.hit3];
			updatePos(cam);
			this.damage = this.getDamage();
			this.power = this.getPower();
			
			if (this.standability < 100)
				this.standability ++;
			
			if (this.status == HIT || this.status == HIT2 || this.status == HIT3)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					setStatus(NORMAL);
				}
			}
			else if (this.status == JUMP || this.status == JUMPHIT)
			{
				if (this.status == JUMPHIT && this.currentAct.currentFrame == this.currentAct.totalFrames)
					setStatus(JUMP);
					
				this.py +=  this.speedY;
				this.speedY +=  3;

				if (this.speedY > 1 && this.py > GROUNDY)
				{
					this.py = GROUNDY;
					this.speedY = 0;
					this.speedPX = 2;
					setStatus(NORMAL);
					//trace("this.y = " + this.y + ", GROUNDY = " + GROUNDY + ", SpeedY = " + this.speedY);
					//trace(this.status);
				}
			}
			else if (this.status == SPRINT)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					setStatus(NORMAL);
				}
				else
				{
					this.speedPX = this.speedX;
					this.px += (this.speedX + this.speedPX)*(this.dir == FACELEFT? -1:1);
				}
			}
			else if (this.status == SPRINTHIT)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					setStatus(NORMAL);
				}
				else
				{
					this.px += (this.dir == FACELEFT? -this.speedX/2:this.speedX/2);
				}
			}
			else if (this.status == SUPERSKILL)
			{
				if (this.currentAct.currentFrame == this.currentAct.totalFrames)
				{
					setStatus(NORMAL);
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