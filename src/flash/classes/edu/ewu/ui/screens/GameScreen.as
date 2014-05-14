package edu.ewu.ui.screens
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	
	/**
	 * Drives the GameScreen class.
	 * 
	 * @author Justin Breitenbach
	 */
	public class GameScreen extends AbstractScreen
	{
		/** Whether the game is currently running or not. */
		public var		bPlaying				:Boolean;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the GameScreen object.
		 */
		public function GameScreen()
		{
			super();
			
			this.mouseEnabled	= false;
			this.mouseChildren	= false;
			
			this.bPlaying 		= false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Begins GameScreen functions.
		 */
		override public function begin():void
		{
			this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			NetworkManager.instance.playerJoinedSignal.add(playerAdded);
			NetworkManager.instance.playerRemovedSignal.add(playerRemoved);
			MusicManager.instance.crossSwitchMusic("Game");
			this.bPlaying = true;
			//CollisionManager.instance.begin();
			super.begin();
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Handle player added
		 *
		 * @param	$oPlayer	Player that was added.
		 */
		protected function playerAdded($oPlayer:Player):void
		{
			this.addChild($oPlayer);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Handle player removed
		 *
		 * @param	$oPlayer	Player that was removed.
		 */
		protected function playerRemoved($oPlayer:Player):void
		{
			this.removeChild($oPlayer);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends GameScreen functions.
		 */
		override public function end():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			this.bPlaying = false;
			//CollisionManager.instance.end();
			super.end();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Handles all updates for this game.
		 *
		 * @param	$e		The dispatched Event.ENTER_FRAME event.
		 */
		public function enterFrameHandler($e:Event):void
		{
			if (this.bPlaying)
			{
				
			}
		}
	}
}

