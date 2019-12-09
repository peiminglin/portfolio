package pbclass
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import pbclass.Charactor;
	import pbclass.Enemy;
	import flash.events.Event;

	public class Bigguy2 extends Enemy
	{
		
	
		public function Bigguy2(dx:Number=0, dy:Number=0):void
		{
			init(dx, dy);
			this.HP = 100;
			this.AILevel = 1;
			this.type = "bigguy2";
		}

		
		public function plan(me:Hero):void
		{
			var i : int = 0;
			
			if (this.todoList.length == 0)
			{
				if (this.px - me.px > stage.stageWidth/2 || me.px - this.px > stage.stageWidth/2)
				{
					this.todoList.push("move"); 
					this.targetX = (me.px + this.px)/2;
				}
				else if (this.px - me.px > me.width + this.width || me.px - this.px > me.width + this.width)
				{
					i = Math.round(Math.random()*(3+me.level));
					if ( i != 0)
					{
						this.todoList.push("move");
						this.targetX = (me.px + this.px)/2;
					}
					else
					{
						this.todoList.push("normal");
						this.targetX = 20 + i*10;
					}
				}
				else if (this.px - me.px > me.width || me.px - this.px > me.width)
				{
					i = Math.round(Math.random()*(10 + me.level));
					
					if (i > 10 + (me.level>>1))
					{
						this.todoList.push("superskill");
						this.targetX = me.px;
					}
					else if (i > 10 - (me.level>>1))
					{
						this.todoList.push("hit");
						this.targetX = me.px;
					}
					else if (i > 2)
					{
						this.todoList.push("move");
						this.targetX = (me.px + this.px)/2;
					}
					else
					{
						this.todoList.push("normal");
						this.targetX = 25 + i*4;
					}
				}
				else
				{
					i = Math.round(Math.random()*(2 + me.level));
					
					if (i > 1)
					{
						this.todoList.push("hit");
						this.targetX = me.px;
					}
					else
					{
						this.todoList.push("normal");
						this.targetX = 20 + i*4;
					}
				}
			}
		}
	}
}