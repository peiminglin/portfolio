package pbclass
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import pbclass.Charactor;
	import pbclass.Enemy;
	import flash.events.Event;

	public class Boss extends Enemy
	{
		
	
		public function Boss(dx:Number=0, dy:Number=0):void
		{
			init(dx, dy);
			this.defence = 0.8;
			this.AILevel = 1;
			this.type = "boss";
		}
		
		public function plan(me:Hero):void
		{
			var i : int = 0;
			
			if (this.todoList.length == 0)
			switch(this.AILevel)
			{
				case 0:
					if (this.px - me.px > me.width || me.px - this.px > me.width)
					{
						i = Math.round(Math.random()*10);
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
						i = Math.round(Math.random()*4);
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
				break;
				
				case 1:
						if (this.px - me.px > me.width + this.width || me.px - this.px > me.width + this.width)
						{
							i = Math.round(Math.random()*10);
							if ( i != 0)
							{
								this.todoList.push("move");
								this.targetX = (me.px + this.px)/2;
							}
							else
							{
								this.todoList.push("normal");
								this.targetX = 20 + i*5;
							}
						}
						else if (this.px - me.px > me.width/2 || me.px - this.px > me.width/2)
						{
							i = Math.round(Math.random()*10);
							
							if (i > 8)
							{
								this.todoList.push("superskill");
								this.targetX = me.px;
							}
							else if (i > 5)
							{
								this.todoList.push("move");
								this.targetX = (me.px + this.px)/2;
							}
							else if (i != 0)
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
						else
						{
							i = Math.round(Math.random()*10);
							
							if (i > 8)
							{
								this.todoList.push("superskill");
								this.targetX = me.px;
							}
							else if (i != 0)
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
				break;
				
				default:
				break;
			}


		}
	}
}