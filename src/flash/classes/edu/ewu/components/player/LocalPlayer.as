package edu.ewu.components.player 
{

	import com.greensock.easing.Linear;

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

	import edu.ewu.components.attacks.BKBasicAttack;

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

		
		/** To help keep track of score */

		public var sLastHitBy:String;

	
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




			this._sSprite.gotoAndPlay("Ranged_Attack");



			var customAttack:Class = getDefinitionByName("edu.ewu.components.attacks." + this._charName + "RangedAttack") as Class;

			new customAttack(this.PlayerName, this.x, this.y, this.SpriteRotation < 0 ? this.SpriteRotation + 360 : this.SpriteRotation);

		}

		

		/* ---------------------------------------------------------------------------------------- */

		

		private function update(e:Event):void

		{

			


			if (this._bAlive && this.nLives>0)
			{

				if (this._bSentInitial == false)

				{

					this._bSentInitial = true;

					NetworkManager.instance.sendData(NetworkManager.OPCODE_MOVED, this);

				}

				

				if (_left && (this.x - this._nSpeed) > 0)

				{

					this.x -= this._nSpeed;

				}

				else if(_left)

				{

					this.x = 0;

				}



				if (_right && (this.x + (this.width/2) + this._nSpeed) < StageRef.stage.stageWidth)

				{

					this.x += this._nSpeed;

				}

				else if (_right)

				{

					this.x = StageRef.stage.stageWidth - this.width / 4;

				}

					

				if (_up && (this.y - this._nSpeed) > 0)

				{

					//Move toward mouse rather than global up 

					//TODO: this is buggy, but works well for a movement scheme, will need to fix bugs before alpha -Jon

					//this.x += this._nSpeed * Math.cos(rotation);

					//this.y += this._nSpeed * Math.sin(rotation);

					

					this.y -= this._nSpeed;

				}

				else if(_up)

				{

					this.y = 0;

				}

				

				if (_down && (this.y + (this.height/2) + this._nSpeed) < StageRef.stage.stageHeight)

				{

					this.y += this._nSpeed;

				}

				else if (_down)

				{

					this.y = StageRef.stage.stageHeight - this.height / 4;

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

			

			//TODO: we may need to use the mouse movements to update a dummy object here, as it is the mouse movement is kinda wonky.  I'll look into refactoring it -Jon

			

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

				

				this.SpriteRotation = angleInDegrees; //TODO: consider rotating sprite here instead of whole player, solves the nameplate dissapearing issue

				

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
					ScreenManager.instance.crossSwitchScreen("Results");
					ScreenManager.instance.mcActiveScreen.begin();
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

		}
		
		public function getHealth():int
		{
			return this.nHealth;
		}

	}
}