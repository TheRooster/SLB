package edu.ewu.components.player 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import com.natejc.utils.StageRef;
	import edu.ewu.components.attacks.Attack;
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
		
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function LocalPlayer($pName:String, $charName:String) 
		{
			super($pName, $charName);
			StageRef.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			StageRef.stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
				
			KeyboardManager.instance.addKeyDownListener(KeyCode.W, wDownHandler);
			KeyboardManager.instance.addKeyDownListener(KeyCode.A, aDownHandler);
			KeyboardManager.instance.addKeyDownListener(KeyCode.S, sDownHandler);
			KeyboardManager.instance.addKeyDownListener(KeyCode.D, dDownHandler);
				
			KeyboardManager.instance.addKeyUpListener(KeyCode.W, wUpHandler);
			KeyboardManager.instance.addKeyUpListener(KeyCode.A, aUpHandler);
			KeyboardManager.instance.addKeyUpListener(KeyCode.S, sUpHandler);
			KeyboardManager.instance.addKeyUpListener(KeyCode.D, dUpHandler);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			this._heartbeatTimer = new Timer(167);
			this._heartbeatTimer.addEventListener(TimerEvent.TIMER, heartbeat);
			this._heartbeatTimer.start();
			
			this.addCollidesWithType(CollisionManager.TYPE_PLAYER);
			this.addCollidesWithType(CollisionManager.TYPE_ATTACK);
			this.addCollidesWithType(CollisionManager.TYPE_WALL);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function wDownHandler():void 
		{
			this._up = true;
			//_sSprite.gotoAndPlay("Walk_Enter");
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function aDownHandler():void 
		{
			this._left = true;
		}
				
		/* ---------------------------------------------------------------------------------------- */
		
		private function sDownHandler():void 
		{
			this._down = true;
			//_sSprite.gotoAndPlay("Walk_Enter");
		}
				
		/* ---------------------------------------------------------------------------------------- */
		
		private function dDownHandler():void 
		{
			this._right = true;
		}
				
		/* ---------------------------------------------------------------------------------------- */
		
		private function wUpHandler():void 
		{
			this._up = false;
			//_sSprite.gotoAndPlay("Walk_Exit");
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function aUpHandler():void 
		{
			this._left = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function sUpHandler():void 
		{
			this._down = false;
			//_sSprite.gotoAndPlay("Walk_Exit");
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function dUpHandler():void 
		{
			this._right = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function update(e:Event):void
		{
			
			if (this._bAlive)
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
			if (this._bAlive)
			{
				var distanceX : Number = $e.stageX - this.x;
				var distanceY : Number = $e.stageY - this.y;
				var angleInRadians : Number = Math.atan2(distanceY, distanceX);
				var angleInDegrees : Number = angleInRadians * (180 / Math.PI);
				//this._sSprite.rotation = angleInDegrees;
				if (angleInDegrees < 0)
				{
					angleInDegrees += 360;
				}
				this.rotation = angleInDegrees;
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
				//new Attack(this.PlayerName, this.x, this.y, this._sSprite.rotation);
				new Attack(this.PlayerName, this.x, this.y, this.rotation + 360);
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
			}
			else if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_ATTACK)
			{
				var attack:Attack = $oObjectCollidedWith as Attack;
				attack.apply(this);
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
	}

}