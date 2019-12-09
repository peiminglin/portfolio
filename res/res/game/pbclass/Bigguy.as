package pbclass
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import pbclass.Charactor;
	import pbclass.Enemy;

	public class Bigguy extends Enemy
	{
		
	
		public function Bigguy(dx:Number=0, dy:Number=0):void
		{
			init(dx, dy);
			this.HP = 80;
			this.AILevel = 0;
			this.type = "bigguy";
		}

		//Enemy's AI. Target on Hero.
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
				else if (this.px - me.px > me.width || me.px - this.px > me.width)
				{
					i = Math.round(Math.random()*(1 + me.level));
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
				else
				{
					i = Math.round(Math.random()*(1 + me.level));
					if ( i != 0)
					{
						this.todoList.push("hit");
						this.targetX = me.px;
					}
					else
					{
						this.todoList.push("normal");
						this.targetX = 20 + i*10;
					}
				}
			}

		}
	}
}