package edu.ewu.components.player 
{

	import com.greensock.easing.Linear;
	import edu.ewu.components.attacks.BurgerKingRangedAttack;

	import com.greensock.events.LoaderEvent;

	import com.greensock.TweenMax;

	import com.natejc.input.KeyboardManager;

	import com.natejc.input.KeyCode;

	import com.natejc.utils.StageRef;

	import edu.ewu.components.attacks.Attack;

	import edu.ewu.components.attacks.RonaldMcDonaldRangedAttack;

	import edu.ewu.components.Collideable;

	import edu.ewu.components.CollisionManager;

	import edu.ewu.networking.NetworkManager;

	import edu.ewu.sounds.SoundManager;

	import flash.events.Event;

	import flash.events.MouseEvent;

	import flash.events.TimerEvent;

	import flash.utils.Timer;

	import edu.ewu.ui.screens.ScreenManager;

	import com.reyco1.multiuser.events.P2PDispatcher;

	import edu.ewu.components.attacks.RonaldMcDonaldBasicAttack;

	import edu.ewu.components.attacks.BurgerKingBasicAttack;

	import flash.utils.getDefinitionByName;

	

	/**

	 * ...

	 * @author Jon Roster

	 */

	public class LocalPlayer extends Player

	{

		/** The last x position of the player if they have moved. */

		protected var	_nLastX:uint;

		/** The last y position of the player if they have moved. */

		protected var	_nLastY:uint;

		

		private var _left:Boolean = false;

		private var _right:Boolean = false;

		private var _up:Boolean = false;

		private var _down:Boolean = false;


		private var _heartbeatTimer:Timer;

		private var _bSentInitial:Boolean = false;

		

		/** List of attacks for the compiler */

		private var _attack:Attack;

		private var _rmdBasicAttack:RonaldMcDonaldBasicAttack;

		private var _rmdRangedAttack:RonaldMcDonaldRangedAttack;
		
		private var _bkBasicAttack:BurgerKingBasicAttack;

		private var _bkRangedAttack:BurgerKingRangedAttack;

		
		/** To help keep track of score */

		public var sLastHitBy:String;
		
		public var nP1Score:int = 0;
		public var nP2Score:int = 0;
		public var nP3Score:int = 0;
		public var nP4Score:int = 0;
		

	
		/* ---------------------------------------------------------------------------------------- */

		

		public function LocalPlayer($pName:String, $charName:String) 

		{

			super($pName, $charName);

			

			KeyboardManager.instance.addKeyDownListener(KeyCode.W, wDownHandler);

			KeyboardManager.instance.addKeyDownListener(KeyCode.A, aDownHandler);

			KeyboardManager.instance.addKeyDownListener(KeyCode.S, sDownHandler);

			KeyboardManager.instance.addKeyDownListener(KeyCode.D, dDownHandler);

				

			KeyboardManager.instance.addKeyUpListener(KeyCode.W, wUpHandler);

			KeyboardManager.instance.addKeyUpListener(KeyCode.A, aUpHandler);

			KeyboardManager.instance.addKeyUpListener(KeyCode.S, sUpHandler);

			KeyboardManager.instance.addKeyUpListener(KeyCode.D, dUpHandler);

			


			KeyboardManager.instance.addKeyDownListener(KeyCode.T, this.defeated);

			

			this.addEventListener(Event.ENTER_FRAME, update);

			

			this._heartbeatTimer = new Timer(88.8);

			this._heartbeatTimer.addEventListener(TimerEvent.TIMER, heartbeat);

			this._heartbeatTimer.start();

			

			this.addCollidesWithType(CollisionManager.TYPE_PLAYER);

			this.addCollidesWithType(CollisionManager.TYPE_ATTACK);

			this.addCollidesWithType(CollisionManager.TYPE_WALL);


			this.addCollidesWithType(CollisionManager.TYPE_PIT);

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		override protected function init(e:LoaderEvent):void

		{

			super.init(e);

			//need to move these here so that we're sure the sprite is loaded before we try to 

			//trigger the animations

			StageRef.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);

			KeyboardManager.instance.addKeyDownListener(KeyCode.E, eDownHandler);

			StageRef.stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
			this.sLastHitBy = "";
			
			this._nLastX = this.stage.stageWidth / 2;
			
			this._nLastY = this.stage.stageHeight / 2;

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		private function wDownHandler():void 

		{

			this._up = true;

			this.gotoAndPlaySprite("Walk_Enter");

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		private function aDownHandler():void 

		{

			this._left = true;

			this.gotoAndPlaySprite("Walk_Enter");

		}

				

		/* ---------------------------------------------------------------------------------------- */

		

		private function sDownHandler():void 

		{

			this._down = true;

			this.gotoAndPlaySprite("Walk_Enter");

		}

				

		/* ---------------------------------------------------------------------------------------- */

		

		private function dDownHandler():void 

		{

			this._right = true;

			this.gotoAndPlaySprite("Walk_Enter");

		}

				

		/* ---------------------------------------------------------------------------------------- */

		

		private function wUpHandler():void 

		{

			this._up = false;

			this.gotoAndPlaySprite("Walk_Exit");

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		private function aUpHandler():void 

		{

			this._left = false;

			this.gotoAndPlaySprite("Walk_Exit");

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		private function sUpHandler():void 

		{

			this._down = false;

			this.gotoAndPlaySprite("Walk_Exit");

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		private function dUpHandler():void 

		{

			this._right = false;

			this.gotoAndPlaySprite("Walk_Exit");

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		private function eDownHandler():void 

		{




			this.gotoAndPlaySprite("Ranged_Attack");



			var customAttack:Class = getDefinitionByName("edu.ewu.components.attacks." + this._charName + "RangedAttack") as Class;

			new customAttack(this.PlayerName, this.x, this.y, this.SpriteRotation < 0 ? this.SpriteRotation + 360 : this.SpriteRotation, this.nBaseForce, this.nBaseDamage);

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		private function update(e:Event):void

		{

			var AngCos = Math.cos((this.SpriteRotation / 180) * Math.PI);
			var AngSin = Math.sin((this.SpriteRotation / 180) * Math.PI);


			if (this._bAlive && this.nLives>0)
			{

				if (this._bSentInitial == false)

				{

					this._bSentInitial = true;

					NetworkManager.instance.sendData(NetworkManager.OPCODE_MOVED, this);

				}

				

				if (_left)
				{

					this.x += this.nSpeed * AngSin;
					this.y += this.nSpeed * -AngCos;

				}



				if (_right)
				{

					this.x += this.nSpeed * -AngSin;
					this.y += this.nSpeed * AngCos;

				}
					

				if (_up )
				{


					this.x += this.nSpeed * AngCos;
					this.y += this.nSpeed * AngSin;


				}

				if (_down)

				{

					this.x += this.nSpeed * -AngCos;

					this.y += this.nSpeed * -AngSin;

				}


				

				if (_down || _left || _right || _up)

				{

					NetworkManager.instance.sendData(NetworkManager.OPCODE_MOVED, this);

				}

			}

		}

		

		/**

		 * @private

		 * Send heartbeat message.

		 * 

		 * @param	$e		The dispatched TimerEvent.

		 */

		protected function heartbeat($e:TimerEvent = null):void

		{

			NetworkManager.instance.sendData(NetworkManager.OPCODE_HEARTBEAT, this);

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		/**

		 * @private

		 * Rotate player to face mouse.

		 * 

		 * @param	$e		The dispatched MouseEvent.

		 */

		protected function mouseMoveHandler($e:MouseEvent = null):void

		{
			

			if (this._bAlive)

			{

				var distanceX : Number = $e.stageX - this.x;

				var distanceY : Number = $e.stageY - this.y;

				var angleInRadians : Number = Math.atan2(distanceY, distanceX);

				var angleInDegrees : Number = angleInRadians * (180 / Math.PI);

				if (angleInDegrees < 0)

				{

					//TODO: this looks terrible -Jon

					//this.this.gotoAndPlaySprite("Turn_Left");

					angleInDegrees += 360;

				}

				else

				{

					//this.this.gotoAndPlaySprite("Turn_Right");

				}

				

				this.SpriteRotation = angleInDegrees; 

				

			}

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		/**

		 * @private

		 * Create first attack.

		 * 

		 * @param	$e		The dispatched MouseEvent.

		 */

		protected function mouseClickHandler($e:MouseEvent = null):void

		{

			if (this._bAlive)

			{
				this.gotoAndPlaySprite("Light_Attack");

				var customAttack:Class = getDefinitionByName("edu.ewu.components.attacks." + this._charName + "BasicAttack") as Class;

				new customAttack(this.PlayerName, this.x, this.y, this.SpriteRotation < 0 ? this.SpriteRotation + 360 : this.SpriteRotation);

			}

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		/**

		 * Logic to be run when a collision is detected.

		 *

		 * @param	$oObjectCollidedWith	The object which was collided with.

		 */

		override public function collidedWith($oObjectCollidedWith:Collideable):void

		{

			if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_PLAYER || $oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_WALL)

			{

				if ($oObjectCollidedWith is Player)

				{

					var player:Player = $oObjectCollidedWith as Player;

					if (this.PlayerName != player.PlayerName)

					{

						TweenMax.killTweensOf(this);

						this.x = this._nLastX;

						this.y = this._nLastY;

					}

				}
				else

				{

					TweenMax.killTweensOf(this);

					this.x = this._nLastX;

					this.y = this._nLastY;

				}
			}

			else if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_ATTACK)

			{

				var attack:Attack = $oObjectCollidedWith as Attack;

				attack.apply(this);

			}

			else if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_PIT)

			{

				if (this._bAlive)

				{

					this.defeated();

				}

			}
		}

		

		override public function set x($x:Number):void

		{

			this._nLastX = this.x;

			super.x = $x

		}

		

		override public function set y($y:Number):void

		{

			this._nLastY = this.y;

			super.y = $y

		}

		

		public function defeated():void

		{

			SoundManager.instance.playSound("Death");
			
			this.visible = false;

			this._bAlive = false;

			this.nLives--;
			
			NetworkManager.instance.sendData(NetworkManager.OPCODE_DEATH, this);
			
			//keep track of who killed you.
			if (sLastHitBy == NetworkManager.instance.players[0])
				nP1Score++;
			else if (sLastHitBy == NetworkManager.instance.players[1])
				nP2Score++;
			else if (sLastHitBy == NetworkManager.instance.players[2])
				nP3Score++;
			else if (sLastHitBy == NetworkManager.instance.players[3])
				nP4Score++;

			//TODO: Play death animation;

			//this.gotoAndPlaySprite("Death");

			if (this.nLives == 0)

			{

				//TODO: Handle switching to results.

				var allDead:Boolean = true;

				for (var p:String in NetworkManager.instance.players)

				{

					if (Player(NetworkManager.instance.players[p]).alive)

					{

						trace(p + ": is alive");

						allDead = false;

						break;

					}

				}

				if (allDead)

				{

					trace("All Dead");
					ScreenManager.instance.mcActiveScreen.end();
					//following lines moved to game screen
					//ScreenManager.instance.crossSwitchScreen("Results");
					//ScreenManager.instance.mcActiveScreen.begin();
					//ScreenManager.instance.switchScreen("Results");

				}

			}

			else

			{

				TweenMax.delayedCall(5, respawn);

			}

		}

		

		public function respawn():void

		{

			//TODO: Add invulnerability timer

			this.x = stage.stageWidth * 0.5;

			this.y = stage.stageHeight * 0.5;

			this._bAlive = true;
			
			this.visible = true;
			
			this.nHealth = 0;
			
			this.sLastHitBy = "";

		}
		
		public function getHealth():int
		{
			return this.nHealth;
		}

	}
}