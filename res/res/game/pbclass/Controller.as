package pbclass{

	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
    import flash.events.TimerEvent;

	public class Controller {
		//The key code from keyboard
		//	Space	= 32;
		//	Up		= 38;
		//	Down	= 40;
		//	Left	= 37;
		//	Right	= 39;
		//	'a'		= 65;
		//	'd'		= 68;
		//	'w'		= 87;
		//	's'		= 83;
		//	'u'		= 90;
		//	'i'		= 73;
		//	'j'		= 74;
		//	'k'		= 75;
		//	'v'		= 86;
		//	'b'		= 66;

		//Set our controller's key code;
		private static var KEY_UP: uint = 87;
		private static var KEY_DOWN: uint = 83;
		private static var KEY_LEFT: uint = 65;
		private static var KEY_RIGHT: uint = 68;
		private static var KEY_A: uint = 74;
		private static var KEY_B: uint = 75;
		private static var KEY_X: uint = 85;
		private static var KEY_Y: uint = 73;
		private static var KEY_SELECT: uint = 86;
		private static var KEY_START: uint = 66;
		
		//The keyDown flag; 
		//Using binary to check which key has been pressed.
		private static const _UP: uint = 1;				//      0000 0001
		private static const _DOWN: uint = 2;			//      0000 0010
		private static const _LEFT: uint = 4;			//      0000 0100
		private static const _RIGHT: uint = 8;			//      0000 1000
		private static const _A: uint = 16;				//      0001 0000
		private static const _B: uint = 32;				//      0010 0000
		private static const _X: uint = 64;				//      0100 0000
		private static const _Y: uint = 128;			//      1000 0000
		private static const _SELECT: uint = 256;		// 0001 0000 0000
		private static const _START: uint = 512;		// 0010 0000 0000
		private static const _DIRBIT: uint = 15;		//      0000 1111
		private static const _ACTBIT: uint = 15<<4;		//      1111 0000
		private static const _FUNCBIT: uint = 15<<8;	// 1111 0000 0000
		
		
		//using binary system to save the information of pressed key.
		//if a bit which has been set as a KeyDown flag is 1, that means that Key has been pressed. Otherwise the bit would be 0;
		//For example, if keyPressed is 5. Because 5 is equal to 0101 as a binary number. 
		//Check the keyDown flag, we can see _UP and _LEFT are both pressed.
		private var keyPressed: uint;
		private var keyDownOnce: uint;		//it set value only for the moment you press the key. it doesn't last even if you hold the key.
		private const keyNum: uint = 10;
	
		//the Commands recorder. 
		//The command is basically a group of pressed key, in a certain sequence and certain interval time which normally very short, to make a special move.
		//Often used in fight game or action game.
		private static const COMMANDLIST:Array = [	[_DOWN, _DOWN, _A],
													[_LEFT, _LEFT],
													[_RIGHT, _RIGHT]
												  ]; //Command list.
												  
		private static const COMMANDNAME:Array = [	"super skill",
													"sprint left",
													"sprint right"
											  ];//Command name
											  
		//The maximum of time interval during the command inputing.
		private static const COMMANDINTERVAL: Number = 200;		//0.2 seconds between each press.
		
		private var commands:Array = new Array();		// command recorder. To save the command we've pressed.
		private var commandTimer: Timer = new Timer(COMMANDINTERVAL, 1);
		
		public function Controller()
		{
			keyPressed = 0;
			keyDownOnce = 0;
			commandTimer.addEventListener(TimerEvent.TIMER,commandTimerHandler);
		}
		
		public function getKeyNum():uint
		{
			return keyNum;
		}
		
		public function getPressedKey():uint
		{
			return keyPressed;
		}
		
		public function getDownKey():uint
		{
			return keyDownOnce;
		}
		
		public function resetKeyDown():void
		{
			keyDownOnce = 0;
		}
		
		//return the name of what key we've pressed.
		public function action_(bitId: uint):String
		{
			var order: Array = ["up", "down", "left", "right", "a", "b", "x", "y", "select", "start"];

			if ((keyPressed&(1<<bitId)) && bitId < order.length)
				return order[bitId];
			else
				return "";
		}

		//For Key Down event.
		public function KeyDownHandler(event: KeyboardEvent):void
		{
			var lastKeyPress: uint = keyPressed;
			
			// if the key is pressed, set the bit to 1;
			switch(event.keyCode)
			{
				case KEY_UP:
					keyPressed |= _UP;
				break;
				
				case KEY_DOWN:
					keyPressed |= _DOWN;
				break;
				
				case KEY_LEFT:
					keyPressed |= _LEFT;
				break;
				
				case KEY_RIGHT:
					keyPressed |= _RIGHT;
				break;
				
				case KEY_A:
					keyPressed |= _A;
				break;
				
				case KEY_B:
					keyPressed |= _B;
				break;
				
				case KEY_X:
					keyPressed |= _X;
				break;
				
				case KEY_Y:
					keyPressed |= _Y;
				break;
				
				default:
				break;
			}
			
			if (keyPressed != lastKeyPress)
			{
				keyDownOnce = (keyPressed^lastKeyPress)&~lastKeyPress;
				
				if(commands.push(keyDownOnce) > 10)
					commands.shift();

				commandTimer.reset();
				commandTimer.start();
			}
			else
				keyDownOnce = 0;
			
		}

		//For Key up event.
		public function KeyUpHandler(event: KeyboardEvent):void
		{
			// if the key is released, set the bit back to 0;
			switch(event.keyCode)
			{
				case KEY_UP:
					keyPressed &= ~_UP;
				break;
				
				case KEY_DOWN:
					keyPressed &= ~_DOWN;
				break;
				
				case KEY_LEFT:
					keyPressed &= ~_LEFT;
				break;
				
				case KEY_RIGHT:
					keyPressed &= ~_RIGHT;
				break;
				
				case KEY_A:
					keyPressed &= ~_A;
				break;
				
				case KEY_B:
					keyPressed &= ~_B;
				break;
				
				case KEY_X:
					keyPressed &= ~_X;
				break;
				
				case KEY_Y:
					keyPressed &= ~_Y;
				break;
				
				default:
				break;
			}
		}
		
		//test only
		public function getKeyCode(code: uint):void
		{
		//	trace(code);
		}
		
		//To redefine the key.
		public function setKey(key: String, code: uint):void
		{
			switch(key)
			{
				case "up":
					KEY_UP = code;
				break;
				
				case "down":
					KEY_DOWN = code;
				break;

				case "left":
					KEY_LEFT = code;
				break;
				
				case "right":
					KEY_RIGHT = code;
				break;
				
				case "a":
					KEY_A = code;
				break;
				
				case "b":
					KEY_B = code;
				break;

				case "x":
					KEY_X = code;
				break;
				
				case "y":
					KEY_Y = code;
				break;
				
				case "select":
					KEY_SELECT = code;
				break;
				
				case "start":
					KEY_START = code;
				break;
				
				default:
				
				break;
			}
		}
		
		//get the command name from what we pressed.
		public function getCommands(): String
		{
			var i: uint = 0;
			var j: uint = 0;
			var flag: Boolean = true;
			var moveName:String;
			
			for (i = 0; i < COMMANDLIST.length; i ++)
			{
				//When the length of the command we get is longer than the commandlist's length, we only compare to the end of commanlist's part.
				//For example, you pressed the key LEFT, RIGHT, DOWN, UP, B, DOWN, DOWN, A. when we check the commandlist "_DOWN, _DOWN, _A", we only compare it to last 3 key, which are DOWN, DOWN, A.
				if (commands.length >= COMMANDLIST[i].length)		
				{
					var comStart: uint = commands.length - COMMANDLIST[i].length;
					for (flag = true, j = 0; j < COMMANDLIST[i].length; j ++)
					{
						if ((commands[comStart + j]&COMMANDLIST[i][j]) != COMMANDLIST[i][j])
						{
							//flag check is for when the commands we keyed in is not matched to COMMANLIST, we set it false.
							flag = false;
							break;
						}
					}
					
					//if flag is true, that means we found a matched preseted command. 
					if (flag)
					{
						//return the matched command's name.
						return COMMANDNAME[i];
					}
				}
			}
			
			//Hold the key to keep hitting.
			//if ((keyPressed&_A) == _A)
			
			//Press once for only one hit.
			if ((keyDownOnce&_A) == _A)
				return "hit";
			
			if ((keyDownOnce&_B) == _B)
				return "jump";
			else 
			{
				if ((keyPressed&_LEFT) == _LEFT)
					return "move left";
				else if ((keyPressed&_RIGHT) == _RIGHT)
					return "move right";
			}
			
				
				return "";
		}
		
		//if the interval time of keypress is too long. clear the command array.
		public function commandTimerHandler(e: TimerEvent):void
		{
			commands.splice(0,commands.length);
		}
		
		//for test purpose only
		public function testCommand():void
		{
			trace(commands);
		}
		
		public function reset():void
		{
			keyPressed = 0;
			keyDownOnce = 0;
			commands.splice(0, commands.length);
		}
		
		//keyboard setting. set 0 is direction key with A for Hit, and S for Jump. set 1 is asdw for direction and J for Hit, K for Jump.
		public function setKeyboardSet(setting:Number):void
		{
			switch(setting)
			{
				case 1:
					KEY_UP = 87;
					KEY_DOWN = 83;
					KEY_LEFT = 65;
					KEY_RIGHT = 68;
					KEY_A = 74;
					KEY_B = 75;
					KEY_X = 85;
					KEY_Y = 73;
					KEY_SELECT = 86;
					KEY_START = 66;
				break;
				
				case 0:
					KEY_UP = 38;
					KEY_DOWN = 40;
					KEY_LEFT = 37;
					KEY_RIGHT = 39;
					KEY_A = 65;
					KEY_B = 83;
					KEY_X = 85;
					KEY_Y = 87;
					KEY_SELECT = 17;
					KEY_START = 13;
				break;
				
				default:
				break;
			}
		}
	}
	
}
