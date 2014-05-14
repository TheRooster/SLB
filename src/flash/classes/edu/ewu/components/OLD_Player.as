package edu.ewu.components 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import edu.ewu.networking.NetworkManager;
	import flash.events.Event;
	import com.natejc.input.KeyboardManager;
	import edu.ewu.networking.NetworkManager;
	import com.natejc.input.KeyCode;
	import com.natejc.utils.StageRef;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class OLD_Player extends MovieClip 
	{
		/** Whether the player is a network player or not. */
		public var			bNetworked			:Boolean;
		/** Whether the player is currently alive or not. */
		public var			bAlive				:Boolean;
		
		/** Whether the player is sent initial data or not. */
		protected var		_bSentInitial		:Boolean	= false;
		
		/** Heartbeat Timer */
		protected var		_heartbeatTimer		:Timer;
		
		/** Health of the player, percentage applied to knockback. */
		public var		nHealth					:Number;
		/** Players remaining lives. */
		public var		nLives					:uint;
		
		private var _left:Boolean;
		private var _right:Boolean;
		private var _up:Boolean;
		private var _down:Boolean;
		
		private var _namePlate:TextField;
		private var _myColor:uint;
		
		public function Player(pName:String, color:uint = 0, $bNetworked:Boolean = false) 
		{
			super();
		
			_myColor = color == 0? int(Math.random() * 0xFFFFFF) : color;
				
			TweenMax.to(this, 1, { colorTransform: { tint:_myColor, tintAmount:1 }} );
			
			var fmt:TextFormat = new TextFormat("Courier New", 10, 0xFFFFFF);
			_namePlate = new TextField();
			_namePlate.defaultTextFormat = fmt;
			_namePlate.text = pName;
			_namePlate.x = this.width/2 -_namePlate.textWidth * .5;
			_namePlate.y = -_namePlate.textHeight;
			_namePlate.selectable = false;
			
			this.addChild(_namePlate);
			
			//TODO: Change to import initial values from xml potentially.
			this.nLives = 3;
			this.nHealth = 0;
			
			this.bAlive = true;
			this.bNetworked = $bNetworked;
			_left = _right = _up = _down = false;
			
			if (this.bNetworked == false)
			{
				this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
				KeyboardManager.instance.addKeyDownListener(KeyCode.W, function(){_up = true});
				KeyboardManager.instance.addKeyDownListener(KeyCode.A, function(){_left = true});
				KeyboardManager.instance.addKeyDownListener(KeyCode.S, function(){_down = true});
				KeyboardManager.instance.addKeyDownListener(KeyCode.D, function(){_right = true});
				
				KeyboardManager.instance.addKeyUpListener(KeyCode.W, function(){_up = false});
				KeyboardManager.instance.addKeyUpListener(KeyCode.A, function(){_left = false});
				KeyboardManager.instance.addKeyUpListener(KeyCode.S, function(){_down = false});
				KeyboardManager.instance.addKeyUpListener(KeyCode.D, function() { _right = false } );
				
				this._heartbeatTimer = new Timer(167);
				this._heartbeatTimer.addEventListener(TimerEvent.TIMER, heartbeat);
				this._heartbeatTimer.start();
			}
		}
		
		public function get PlayerName()
		{
			return this._namePlate.text;
		}
		
		public function get PlayerColor()
		{
			return _myColor;
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
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
		 * Handles all updates for this player.
		 *
		 * @param	$e		The dispatched Event.ENTER_FRAME event.
		 */
		public function enterFrameHandler($e:Event):void
		{
			if (this.bAlive)
			{
				if (this._bSentInitial == false)
				{
					this._bSentInitial = true;
					NetworkManager.instance.sendData(NetworkManager.OPCODE_MOVED, this);
				}
				if (_left && this.x - 5 > 0)
				{
					this.x -= 5;
				}
				else if(_left)
				{
					this.x = 0;
				}
					
				if (_right && this.x + (this.width/2) + 5 < StageRef.stage.stageWidth)
				{
					this.x += 5;
				}
				else if (_right)
				{
					this.x = StageRef.stage.stageWidth - this.width / 4;
				}
					
				if (_up && this.y - 5 > 0)
				{
					this.y -= 5;
				}
				else if(_up)
				{
					this.y = 0;
				}
					
				if (_down && this.y + (this.height/2) + 5 < StageRef.stage.stageHeight)
				{
					this.y += 5;
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
	}

}