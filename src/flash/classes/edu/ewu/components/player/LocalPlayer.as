package edu.ewu.components.player 
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import com.natejc.utils.StageRef;
	import edu.ewu.components.attacks.Attack;
	import edu.ewu.components.Collideable;
	import edu.ewu.networking.NetworkManager;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import edu.ewu.components.CollisionManager;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
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
			
			CollisionManager.instance.add(this);
			this.addCollidesWithType(CollisionManager.TYPE_PLAYER);
			this.addCollidesWithType(CollisionManager.TYPE_WALL);
			
			CollisionManager.instance.begin();
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
					this._nLastX = this.x;
					this._nLastY = this.y;
				}
				if (_left && this.x - 5 > 0)
				{
					this._nLastX = this.x;
					this._nXPos -= this._nSpeed;
				}
				else if(_left)
				{
					this._nLastX = this.x;
					this._nXPos = 0;
				}
					
				if (_right && this.x + (this.width/2) + 5 < StageRef.stage.stageWidth)
				{
					this._nLastX = this.x;
					this._nXPos += this._nSpeed;
				}
				else if (_right)
				{
					this._nLastX = this.x;
					this.x = StageRef.stage.stageWidth - this.width / 4;
				}
					
				if (_up && this.y - 5 > 0)
				{
					this._nLastY = this.y;
					this.y -= this._nSpeed;
				}
				else if(_up)
				{
					this._nLastY = this.y;
					this.y = 0;
				}
					
				if (_down && this.y + (this.height/2) + 5 < StageRef.stage.stageHeight)
				{
					this._nLastY = this.y;
					this.y += this._nSpeed;
				}
				else if (_down)
				{
					this._nLastY = this.y;
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
		 * Logic to be run when a collision is detected.
		 *
		 * @param	$oObjectCollidedWith	The object which was collided with.
		 */
		override public function collidedWith($oObjectCollidedWith:Collideable):void
		{
			if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_PLAYER || $oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_WALL)
			{
				this.x = this._nLastX;
				this.y = this._nLastY;
			}
			else if ($oObjectCollidedWith.sCollisionType == CollisionManager.TYPE_ATTACK)
			{
				//TODO: Handle health multiplying force
				var attack:Attack = $oObjectCollidedWith as Attack;
				TweenMax.to(this._sSprite, 1.0, { x:this.x + attack.force * Math.cos(attack.angle), y:this.y + attack.force * Math.sin(attack.angle) , ease: Linear.easeNone } );
				attack.destroy();
			}
		}
	}

}