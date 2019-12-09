/*
Author: Alex Lin.
All resources and codes designed by myself on september 2011.
Copyright@2011 reserved.

*/



package pbclass
{
	//import my files
	import pbclass.Charactor;
	import pbclass.Controller;
	import pbclass.Camara;
	import pbclass.Hero;
	import pbclass.Enemy;
	import pbclass.Bigguy;
	import pbclass.Bigguy2;
	import pbclass.Attack;
	import pbclass.Boss;
	import pbclass.EventPoint;
	import pbclass.Food;

	//import system files
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flashx.textLayout.formats.BackgroundColor;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Game extends MovieClip
	{

		//set game progress
		static const EXIT:uint = 0;
		static const LOGO:uint = 1;
		static const INTRO:uint = 2;
		static const MENU:uint = 3;
		static const OPTION:uint = 4;
		static const KEYSETTING:uint = 5;
		static const CREDIT:uint = 6;
		static const PLAYGAME:uint = 7;
		static const TEST:uint = 100;
		var status:uint = 0;
		var statusUI: Array = new Array;
		
		//set static const number
		static const GROUNDY:Number = 250;
		static const MAXENEMY:uint = 4;
		static const MAXLEVEL:uint = 16;

		//my charactor and the boss.
		var myHero:Hero = new Hero(300,GROUNDY);
		var myBoss:Boss;
		
		//the hit effect picture
		var hitEffectList:Array = new Array();
		var tempHit:Attack = new Attack();
		
		//food list and enemy list
		var foodList:Array = new Array();
		var enemyList:Array = new Array();
		var enemyHpBar:Array = new Array();
		var enemyTimer:Timer = new Timer(2000);
		
		//play time and different event.
		//the first argument means when my charactor pass a position x, the event will happen.
		//the second argument is the description of the event.
		var entryEvent:EventPoint = new EventPoint(1500, "entry event");	//after my charactor pass the position, enemies start showing up.
		var bossEvent:EventPoint = new EventPoint(2800, "boss event");		//after my charactor pass the position, boss shows up.
		var winEvent:EventPoint = new EventPoint(2800, "win event");		//after my charactor pass the position, boss shows up.
		var eventList:Array = [entryEvent, bossEvent, winEvent];						//My Events' Points List
		var playTime:Number = 0;

		var score:uint = 0;
		var bestScore:uint = 0;
		static const NORMALHIT:int = 1;
		static const KILLBIGGUY:int = 5;
		static const KILLBIGGUY2:int = 8;
		static const KILLBOSS:int = 50;
		static const LEFTHP:int = 1;
		
		var gameStatus:int;
		static const NORMAL:int = 0;
		static const WIN:int = 1;
		static const LOSE:int = 2;
		var gameOver:GameOverTitle = new GameOverTitle();
		var gameOverTimer:Timer = new Timer(5000);
		
		//my Camera.
		//The background's left would be the position px=0, and to make sure my charactor will always in center.
		//my camera's will follow my charactor all the times.
		var myCamara: Camara = new Camara(100,GROUNDY);
		var myController: Controller = new Controller();
		
		//It has 2 keyboard settings. one using direction keys. the other one using asdw for direction.
		var keyBoardSet:Number = 1;
		
		//the background and user interface.
		var myBg:BackGround = new BackGround();
		var myGameGui:TopBg = new TopBg();
		
		//The Dynamic Difficulty Adjustment System.
		//The System will check how many enemies you've killed, and how much HP you've lost in every 15 seconds, to adjust the difficulty automatically;
		var difficultyAdjustCheck:Timer = new Timer(15000);
		var difficulty:uint = 0;
		var lastHP:uint = 100;
		var lastKills:uint = 0;
		var numKills:uint = 0;


		public function Game()
		{
			stage.scaleMode = "exactFit";
			statusUI = [null, logo_mc, intro_mc, menu_mc, option_mc, keysetting_mc, credit_mc];

			for (var i = 1; i < this.statusUI.length; i ++)
				this.statusUI[i].visible = false;
			this.BT_Back.visible = false;
			
			// Initial the status
			setStatus(LOGO);

			//Add the main event circuit
			stage.addEventListener(Event.ENTER_FRAME, GameCircuit);

			//Add all the event for menu buttons.
			this.menu_mc.BT_Play.addEventListener(MouseEvent.CLICK, playClickHandler);
			this.menu_mc.BT_Option.addEventListener(MouseEvent.CLICK, optionClickHandler);
			this.menu_mc.BT_Credit.addEventListener(MouseEvent.CLICK, creditClickHandler);
			this.BT_Back.addEventListener(MouseEvent.CLICK, backClickHandler);
		}

		public function GameCircuit(e:Event):void
		{
			switch (this.status)
			{
				//Logo
				case LOGO :
					if (playLogo())
					{
						setStatus(INTRO);
						this.logo_mc.visible = false;
					}
					break;

				//Introduction video
				case INTRO :
					if (playIntro())
					{
						setStatus(MENU);
						this.intro_mc.visible = false;
					}
				break;

				//menu 
				case MENU :
					playMenu();
					break;
				
				//game playing
				case PLAYGAME :
					playGame();
					break;
					
				//options
				case OPTION :
					option();
					break;

				//keysetting
				case KEYSETTING :
					keySetting();
					break;

				//credit
				case CREDIT :
					credit();
					break;
					
				//test mode. for test only
				case TEST:
					test();
					break;

				default :
					break;
			}
		}

		public function playLogo():Boolean
		{
			//skip logo
			//return true;

			//play logo. go to next step after logo finished.
			if (this.logo_mc.currentFrame == this.logo_mc.totalFrames)
				return true;
			else
				return false;
		}

		public function playIntro():Boolean
		{
			//skip intro
			return true;

			//play intro. go to next step after intro finished.
			if (this.intro_mc.currentFrame == this.intro_mc.totalFrames)
				return true;
			else
				return false;
		}

		public function playMenu():void
		{
			//menu issues;
		}

		public function initGame():void
		{
			entryEvent.checked = false;
			bossEvent.checked = false;
			winEvent.checked = false;
			
			gameStatus = 0;	//0 is normal, 1 is win, 2 is lose
			difficulty = 1;
			score = 0;
			lastHP = 100;
			lastKills = 0;
			numKills = 0;
			playTime = 0;
			myHero.init(300,GROUNDY);
			myHero.stamina = 0;
			myHero.defence = 0.2;
			myBg.y = GROUNDY;
			myBg.x = 0;
			
			//my carema focus on my charactor, make the charactor a little bit lower than center.
			myCamara.focusOn(myHero.px, myHero.py - 50);
			updateAll();
			
			addChild(myBg);
			addChild(myHero);
			addChild(myGameGui);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, myController.KeyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, myController.KeyUpHandler);
			enemyTimer.addEventListener(TimerEvent.TIMER, EnemyTimerHandler);
			enemyTimer.start();
			gameOverTimer.addEventListener(TimerEvent.TIMER, gameOverTimerHandler);
			myGameGui.BT_Pause.addEventListener(MouseEvent.CLICK, pauseClickHandler);
			difficultyAdjustCheck.addEventListener(TimerEvent.TIMER, DACHandler);
			difficultyAdjustCheck.start();
			
			myController.setKeyboardSet(keyBoardSet);
		}
		
		public function playGame():void
		{
			//
			var cmd:String = "";
			var i:int;
			
			updateAll();
			myCamara.focusOn(myHero.px, myHero.py - 50);
			
			//the controller will get the command from what you pressed, then pass it to my charactor.
			cmd = myController.getCommands();
			myHero.action(cmd);

			
			//when bossEvent happened, boss comes out.
			/*for (var desk:String = "", i = 0; i < eventList.length; i ++)
			{
				desc = eventList[i].checkEvent(myHero.px);
				
				if (desc == "boss event")
				{
					var hpBar:HpBar = new HpBar();
					myBoss = new Boss(myHero.px + (Math.round(Math.random()) == 0?-stage.stageWidth/2:stage.stageWidth/2), GROUNDY);
					
					myBoss.updateData(myCamara);
					hpBar.x = myBoss.x;
					hpBar.y = myBoss.y + 5;
					enemyList.unshift(myBoss);
					enemyHpBar.push(hpBar);
					addChild(myBoss);
					addChild(hpBar);
				}
			}*/
			
			if (entryEvent.checkEvent(myHero.px > entryEvent.px) == entryEvent.description)
			{
				//Do not comment this if statement. The .checkEvent method check the condition, if it's archived, the value of event.checked will be true;
				//Even if you do nothing here, the event still need to be checked. 
			}
			if (bossEvent.checkEvent(myHero.px > bossEvent.px) == bossEvent.description)
			{
				var hpBar:HpBar = new HpBar();
				myBoss = new Boss(myHero.px + stage.stageWidth/2, GROUNDY);
				
				myBoss.updateData(myCamara);
				hpBar.x = myBoss.x;
				hpBar.y = myBoss.y + 5;
				enemyList.unshift(myBoss);
				enemyHpBar.push(hpBar);
				addChild(myBoss);
				addChild(hpBar);
			}
			
			if (enemyList.length != 0 && enemyList[0].type == "boss" && winEvent.checkEvent(enemyList[0].ifDead) == winEvent.description)
			{
				gameStatus = 1;
				if (gameOverTimer.running == false)
				{
					score += myHero.HP * LEFTHP;
					bestScore = bestScore > score ? bestScore : score;
					gameOver.finalScoreBox.text = String(score);
					gameOver.bestScoreBox.text = String(bestScore);
					gameOver.titleBox.text = "You Win";
					gameOverTimer.start();
					gameOver.x = stage.stageWidth/2;
					gameOver.y = stage.stageHeight/2;
					addChild(gameOver);
				}
			}			
			
			//doing all actions of all enemies.
			for (i = 0; i < enemyList.length; i ++)
			{										
				//if enemy dead, randomly drop some HP items.
				if (enemyList[i].ifDead == true)
				{
					if (myHero.HP < 75 && Math.round(Math.random()*this.difficulty)==0)
					{
						var food:Food = new Food(enemyList[i].px, enemyList[i].py, Math.floor(Math.random()*(100-myHero.HP)/25));
						food.updateData(myCamara);
						foodList.push(food);
						addChild(food);
					}
					
					if (enemyList[i].type == "bigguy")
						this.score += KILLBIGGUY*this.difficulty;
					else if (enemyList[i].type == "bigguy2")
						this.score += KILLBIGGUY2*this.difficulty;
					else if (enemyList[i].type == "boss")
						this.score += KILLBOSS*this.difficulty;
					
					removeChild(enemyList.splice(i, 1)[0]);
					removeChild(enemyHpBar.splice(i, 1)[0]);
					this.numKills ++;
					
					i --;
				}
				//else enemies doing what AI let it do.
				else
				{
					enemyList[i].plan(myHero);
					enemyList[i].action();
					
					//attack and attacked check.
					if (enemyList[i].px - myHero.px < stage.stageWidth/2 && myHero.px - enemyList[i].px < stage.stageWidth/2)
					{
						if (myHero.attack(enemyList[i], tempHit))
						{
							tempHit.damage = myHero.damage;
							tempHit.power = myHero.power;
							enemyList[i].getAttacked(tempHit);
							if (myHero.stamina < 64)
								myHero.stamina ++;
					
							hitEffectList.push(tempHit);
							tempHit.updateData(myCamara);
							addChild(tempHit);
							tempHit = new Attack();
							
							score += NORMALHIT*this.difficulty;
						}
					
						if (enemyList[i].attack(myHero, tempHit))
						{
							tempHit.damage = enemyList[i].damage;
							tempHit.power = enemyList[i].power;
							myHero.getAttacked(tempHit);
						
							hitEffectList.push(tempHit);
							tempHit.updateData(myCamara);
							addChild(tempHit);
							tempHit = new Attack();
						}
					}
				}
			}
			
			//hit effect pic display
			for (i = 0; i < hitEffectList.length; i ++)
			{
				if (hitEffectList[i].currentFrame == hitEffectList[i].totalFrames)
				{
					removeChild(hitEffectList.splice(i,1)[0]);
					i --;
				}
			}
			
			//HP item check.
			for(i = 0; i < foodList.length; i ++)
				if (myHero.hitTestObject(foodList[i]))
				{
					myHero.HP += foodList[i].energy;
					removeChild(foodList.splice(i,1)[0]);
					i --;
					if (myHero.HP > 100)
						myHero.HP = 100;
				}
			
			//if my hero dead, game over. go back to menu
			if (myHero.ifDead)
			{
				gameStatus = 2;
				if (gameOverTimer.running == false)
				{
					bestScore = bestScore > score ? bestScore : score;
					gameOver.finalScoreBox.text = String(score);
					gameOver.bestScoreBox.text = String(bestScore);
					gameOver.titleBox.text = "You Lose";
					gameOverTimer.start();
					gameOver.x = stage.stageWidth/2;
					gameOver.y = stage.stageHeight/2;
					addChild(gameOver);
				}
			}

			myGameGui.HPBar.scaleX = myHero.HP/100;
			myGameGui.StaBar.scaleX = myHero.stamina/64;
			myGameGui.scoreBox.text = String(score);
			myController.resetKeyDown();
		}
		
		//basically just update the position
		public function updateAll():void
		{
			var i:Number;
			myCamara.updateData(stage);
			for (i = 0; i < enemyList.length; i ++)
			{
				enemyList[i].updateData(myCamara);
				
				//if (enemyList[i].px > myBg.width - stage.stageWidth/2)
				//	enemyList[i].px = myBg.width - stage.stageWidth/2;
				//else if (enemyList[i].px < stage.stageWidth/2)
				//	enemyList[i].px = stage.stageWidth/2;
				
				enemyHpBar[i].x = enemyList[i].x;
				enemyHpBar[i].y = enemyList[i].y + 5;
				enemyHpBar[i].scaleX = enemyList[i].HP/100;
			}
			myHero.updateData(myCamara);
			
			if (myHero.px > myBg.width - 700)
				myHero.px = myBg.width - 700;
			else if (myHero.px < stage.stageWidth/2)
				myHero.px = stage.stageWidth/2;
			
			for (i = 0; i < hitEffectList.length; i ++)
				hitEffectList[i].updateData(myCamara);
			
			for (i = 0; i < foodList.length; i ++)
				foodList[i].updateData(myCamara);
				
			myBg.x = myCamara.x;
			myBg.y = myCamara.y + GROUNDY;
			myBg.back2.x = myHero.px>>1;
			myBg.back3.x = (myHero.px*7)>>3;
			
		}

		public function option():void
		{
			//
			this.option_mc.selected.y = this.keyBoardSet*200;
		}

		public function keySetting():void
		{

			//
		}

		public function credit():void
		{

			//
		}

		//set current game progress.
		public function setStatus(sta:uint):void
		{
			//var flag:Array = ["exit","logo","intro","menu","playgame","option","keysetting","credit"];
			switch(sta)
			{
				case LOGO:
					this.status = LOGO;
					this.logo_mc.visible = true;
					this.logo_mc.gotoAndPlay(1);
				break;
				
				case INTRO:
					this.status = INTRO;
					this.intro_mc.visible = true;
					this.intro_mc.gotoAndPlay(1);
				break;
				
				case MENU:
					this.status = MENU;
					this.menu_mc.visible = true;
				break;
				
				case OPTION:
					this.status = OPTION;
					this.option_mc.visible = true;
					this.BT_Back.visible = true;
					this.option_mc.kbset1.addEventListener(MouseEvent.CLICK, kbsetSelect1);
					this.option_mc.kbset2.addEventListener(MouseEvent.CLICK, kbsetSelect2);
				break;
				
				case KEYSETTING:
					this.status = KEYSETTING;
					this.keysetting_mc.visible = true;
					this.BT_Back.visible = true;
					break;
				
				case CREDIT:
					this.status = CREDIT;
					this.credit_mc.visible = true;
					this.credit_mc.gotoAndPlay(1);
					//this.BT_Back.visible = true;
				break;
				
				case PLAYGAME:
					this.status = PLAYGAME;
					initGame();
					
				break;
				
				case TEST:
					this.status = TEST;
					initGame();
				break;
				
				default:
				break;
			}

		}
		
		public function leavePage():void
		{
			this.statusUI[this.status].visible = false;
			this.BT_Back.visible = false;
		}
		
		//finish game. clear all the children. go back to menu;
		public function finishGame():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, myController.KeyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, myController.KeyUpHandler);
			enemyTimer.removeEventListener(TimerEvent.TIMER, EnemyTimerHandler);
			enemyTimer.stop();
					
			removeChild(myBg);
			while(enemyList.length > 0)
				removeChild(enemyList.shift());
			while(enemyHpBar.length > 0)
				removeChild(enemyHpBar.shift());
			while(foodList.length > 0)
				removeChild(foodList.shift());
			while(hitEffectList.length > 0)
				removeChild(hitEffectList.shift());

			removeChild(myHero);
			removeChild(myGameGui);
			
			myController.reset();
			
			setStatus(MENU);
		}

		// All Click Handler Functions
		public function playClickHandler(event:MouseEvent):void
		{
			setStatus(PLAYGAME);
			this.menu_mc.visible = false;
		}

		public function optionClickHandler(event:MouseEvent):void
		{
			setStatus(OPTION);
			this.menu_mc.visible = false;
		}

		public function kbsetSelect1(event:MouseEvent):void
		{
				this.keyBoardSet = 0;
		}
		
		public function kbsetSelect2(event:MouseEvent):void
		{
				this.keyBoardSet = 1;
		}
		
		public function creditClickHandler(event:MouseEvent):void
		{
			setStatus(CREDIT);
			this.menu_mc.visible = false;
		}

		public function backClickHandler(event:MouseEvent):void
		{
			leavePage();
				
			setStatus(MENU);
		}
		
		public function pauseClickHandler(event:MouseEvent):void
		{
			finishGame();
		}
		
		//Enemy timer.
		public function EnemyTimerHandler(event:TimerEvent):void
		{
			if (entryEvent.checked == true && enemyList.length < MAXENEMY + (this.difficulty>>3))
			{
				var hpBar:HpBar = new HpBar();
				var enemy:Enemy;
				//enemy.AILevel = Math.round(Math.random());
				
				if (Math.round(Math.random()*MAXLEVEL) > (this.difficulty>>1))
					enemy = new Bigguy(myHero.px + (Math.round(Math.random()*4) == 0?-stage.stageWidth/2:stage.stageWidth/2), GROUNDY);
				else
					enemy = new Bigguy2(myHero.px + (Math.round(Math.random()*4) == 0?-stage.stageWidth/2:stage.stageWidth/2), GROUNDY);

				
				enemy.updateData(myCamara);
				hpBar.x = enemy.x;
				hpBar.y = enemy.y + 5;
				enemyList.push(enemy);
				enemyHpBar.push(hpBar);
				addChild(enemy);
				addChild(hpBar);
				
				playTime += 2;
			}
		}
		
		public function gameOverTimerHandler(event:TimerEvent):void
		{
			gameOverTimer.stop();
			removeChild(gameOver);
			finishGame();
		}
		
		//Dynamic Difficulty Adjustment Check Timer
		public function DACHandler(event:TimerEvent):void
		{
			if (numKills - lastKills > 0 && (myHero.HP - lastHP)/4 < (numKills - lastKills))
			{
				if (this.difficulty < MAXLEVEL)
					this.difficulty ++;
			}
			
			if(myHero.HP - lastHP > 20)
			{
				if (this.difficulty > 0)
				this.difficulty -= (myHero.HP - lastHP)>>4;
			}
			
			lastHP = myHero.HP;
			lastKills = numKills;
			myHero.level = this.difficulty;
		}
		
		public function test():void
		{
			
		}

	}
}


