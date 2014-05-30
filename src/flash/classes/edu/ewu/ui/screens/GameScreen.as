package edu.ewu.ui.screens
{
	import com.greensock.TweenMax;
	import edu.ewu.components.Collectable;
	import edu.ewu.components.player.Player;
	import edu.ewu.components.player.LocalPlayer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.components.CollisionManager;
	import flash.text.TextFormat;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	
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
		
		private const SERVER:String = "rtmfp://p2p.rtmfp.net/";
		
		private var sessionName:String = "SimpleDemoGroup";
		private var   DEVKEY:String = "";
		private var SERV_KEY:String = "";
		
		var me:LocalPlayer;
		var playerName:String;
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
			NetworkManager.instance.collectableAddedSignal.add(collectableAdded);
			MusicManager.instance.crossSwitchMusic("Game");
			
			this.bPlaying = true;
			CollisionManager.instance.begin();
			super.begin();
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Creates the Local Player.
		 */
		override public function setGame(name:String, character:String, $sSessionName:String):void
		{
			this.playerName = name;
			this.sessionName = $sSessionName;
			var loader:XMLLoader =  new XMLLoader("resources/xml/serverKey.xml", { name:"key", onComplete:initNetwork} );
			loader.load();
			//player will now be created in GameScreen.
			//var me:LocalPlayer = new LocalPlayer(name, "BurgerKing");
			me = new LocalPlayer(playerName, character);
			
			
		}
		
		
		private function initNetwork(event:LoaderEvent):void 
		{
			DEVKEY = (LoaderMax.getContent("key")).Key; 
			SERV_KEY = SERVER + DEVKEY; 
			NetworkManager.instance.initConnection(SERV_KEY, sessionName);
			NetworkManager.instance.add(playerName, me);
			NetworkManager.instance.connect(playerName, me);
			ScreenManager.instance.mcActiveScreen.addChild(me);
			
			p1 = me;
			me.x = stage.stageWidth * 0.5;
			me.y = stage.stageHeight * 0.5;
			txtLocal.text = playerName;
			this.begin();
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
				this.start();
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
			NetworkManager.instance.playerJoinedSignal.removeAll();
			NetworkManager.instance.playerRemovedSignal.removeAll();
			NetworkManager.instance.collectableAddedSignal.removeAll();
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
				updateLives();
				if(p2!=null)
					txtP2Health.text = p2.nHealth + "%";
				if(p3!=null)
					txtP3Health.text = p3.nHealth + "%";
				if(p4!=null)
					txtP4Health.text = p4.nHealth + "%";
			}
		}
		
		public function updateLives():void
		{
			txtLocalLives.text = makePeriods(p1.getLives());
			
			
			if(p2!=null)
				txtp2Lives.text = makePeriods(p2.nLives);
			if(p3!=null)
				txtp3Lives.text = makePeriods(p3.nLives);
			if(p4!=null)
				txtp4Lives.text = makePeriods(p4.nLives);
		}
		
		public function makePeriods(n:int):String
		{
			var s:String = "";
			while (n > 0)
			{
				s += ".";
				n--;
			}
			return s;
		}
		
		protected function collectableAdded($oCollectable:Collectable):void
		{
			this.addChild($oCollectable);
		}
		
		public function start():void
		{
			me.alive = true;
		}
	}
}

