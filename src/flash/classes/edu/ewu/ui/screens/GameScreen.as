package edu.ewu.ui.screens
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	import edu.ewu.components.player.LocalPlayer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.components.CollisionManager;
	import flash.text.TextFormat;
	
	/**
	 * Drives the GameScreen class.
	 * 
	 * @author Justin Breitenbach
	 */
	public class GameScreen extends AbstractScreen
	{
		/** Whether the game is currently running or not. */
		public var		bPlaying				:Boolean;
		/** Text box that contains the name of a player. */
		public var      txtLocal;
		/** Text box that contains the name of a player. */
		public var      txtp2;
		/** Text box that contains the name of a player. */
		public var      txtp3;
		/** Text box that contains the name of a player. */
		public var      txtp4;
		/** Text box that contains the lives of a player. */
		public var      txtLocalLives;
		/** Text box that contains the lives of a player. */
		public var      txtp2Lives;
		/** Text box that contains the lives of a player. */
		public var      txtp3Lives;
		/** Text box that contains the lives of a player. */
		public var      txtp4Lives;
		
		public var      txtLocalHealth;
		/** Text box that contains the lives of a player. */
		public var      txtP2Health:TextField = new TextField();
		/** Text box that contains the lives of a player. */
		public var      txtP3Health;
		/** Text box that contains the lives of a player. */
		public var      txtP4Health;
		
		/** References to each player. */
		public var p1;
		public var p2;
		public var p3;
		public var p4;
/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the GameScreen object.
		 */
		public function GameScreen()
		{
			this.bPlaying 		= false;
			super();
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
			CollisionManager.instance.begin();
			super.begin();
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Creates the Local Player.
		 */
		override public function setPlayer(name:String, character:String):void
		{
			//player will now be created in GameScreen.
			//var me:LocalPlayer = new LocalPlayer(name, "BurgerKing");
			var me:LocalPlayer = new LocalPlayer(name, character);
			p1 = me;
			me.x = stage.stageWidth * 0.5;
			me.y = stage.stageHeight * 0.5;
			
			NetworkManager.instance.add(name, me);
			NetworkManager.instance.connect(name, me);
			ScreenManager.instance.mcActiveScreen.addChild(me);
			
			txtLocal.text = name;
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
			if (p2 == null)
			{
				p2 = $oPlayer;
				txtp2.text = p2._pName;
			}
			else if (p3 == null)
			{
				p3 = $oPlayer;
				txtp3.text = p3._pName;
			}
			else if (p4 == null)
			{
				p4 = $oPlayer;
				txtp4.text = p4._pName;
			}
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
			CollisionManager.instance.end();
			ScreenManager.instance.crossSwitchScreen("Results");
			ScreenManager.instance.mcActiveScreen.begin();
			ScreenManager.instance.mcActiveScreen.setKOs(p1.kills, p1.nLives);
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
				txtLocalHealth.text = p1.getHealth() + "%";
				if(p2!=null)
					txtP2Health.text = p2.nHealth + "%";
				if(p3!=null)
					txtP3Health.text = p3.nHealth + "%";
				if(p4!=null)
					txtP4Health.text = p4.nHealth + "%";
			}
		}
	}
}

