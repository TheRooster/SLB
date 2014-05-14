package edu.ewu.components.player 
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import com.natejc.utils.StageRef;
	import edu.ewu.networking.NetworkManager;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class LocalPlayer extends Player
	{
		
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
				if (_left && this.x - 5 > 0)
				{
					this._nXPos -= this._nSpeed;
				}
				else if(_left)
				{
					this._nXPos = 0;
				}
					
				if (_right && this.x + (this.width/2) + 5 < StageRef.stage.stageWidth)
				{
					this._nXPos += this._nSpeed;
				}
				else if (_right)
				{
					this.x = StageRef.stage.stageWidth - this.width / 4;
				}
					
				if (_up && this.y - 5 > 0)
				{
					this.y -= this._nSpeed;
				}
				else if(_up)
				{
					this.y = 0;
				}
					
				if (_down && this.y + (this.height/2) + 5 < StageRef.stage.stageHeight)
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
		
		
		
		
		
	}

}