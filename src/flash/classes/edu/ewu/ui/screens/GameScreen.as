package edu.ewu.ui.screens
{
	import com.greensock.TweenMax;
	import edu.ewu.components.attacks.Attack;
	import edu.ewu.components.collectables.Burger;
	import edu.ewu.components.collectables.Collectable;
	import edu.ewu.components.collectables.Soda;
	import edu.ewu.components.player.Player;
	import edu.ewu.components.player.LocalPlayer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.components.CollisionManager;
	import flash.text.TextFormat;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import edu.ewu.components.collectables.Collectable;
	import edu.ewu.components.collectables.Jalepeno;
	import flash.utils.Timer;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	
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
		
		public var maxPlayerCount:uint;
		public var currentPlayerCount:uint;
		public var numPlayerInput :uint;
		
		private var _collectableSpawnTimer:Timer;
		
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
			_collectableSpawnTimer = new Timer(Math.random() * 60000 + 5000);
			super();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Begins GameScreen functions.
		 */
		override public function begin():void
		{
			this.maxPlayerCount = 1;
			this.currentPlayerCount = 1;
			
			KeyboardManager.instance.addKeyDownListener(KeyCode.ESC, escKeyDownHandler);
			this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			NetworkManager.instance.playerJoinedSignal.add(playerAdded);
			NetworkManager.instance.playerRemovedSignal.add(playerRemoved);
			NetworkManager.instance.collectableAddedSignal.add(collectableAdded);
			MusicManager.instance.crossSwitchMusic("Game");
			
			this.bPlaying = false;
			CollisionManager.instance.begin();
			
            _collectableSpawnTimer.addEventListener(TimerEvent.TIMER, spawnItem);
            _collectableSpawnTimer.start();
			
			super.begin();
		}
		
		private function escKeyDownHandler():void
		{
			ScreenManager.instance.getScreen("Results").setKOs(this.me.kills, this.me.nLives);
			this.end();
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Creates the Local Player.
		 */
		override public function setGame(name:String, character:String, $sSessionName:String, numPlayers:uint):void
		{
			this.playerName = name;
			this.sessionName = $sSessionName;
			var loader:XMLLoader =  new XMLLoader("resources/xml/serverKey.xml", { name:"key", onComplete:initNetwork} );
			loader.load();
			//player will now be created in GameScreen.
			//var me:LocalPlayer = new LocalPlayer(name, "BurgerKing");
			me = new LocalPlayer(playerName, character);
			
			if (numPlayers > 4)
			{
				numPlayers = 4;
			}
			else if (numPlayers < 2)
			{
				numPlayers = 2;
			}
			
			this.numPlayerInput = numPlayers;
		}
		
		private function spawnItem($e:Event = null):void
		{
			if (this.bPlaying)
			{
				var random:Number = Math.random() * 1;
				
				if(random < .333)
					addChild(new Jalepeno());
				else if (random > .333 && random < .666)
					addChild(new Burger());
				else if (random > .666)
					addChild(new Soda());
				_collectableSpawnTimer.stop();
				_collectableSpawnTimer = new Timer(Math.random() * 60000 + 5000);
				_collectableSpawnTimer.start();
			}
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
			if (this.bPlaying)
			{
				NetworkManager.instance.sendData(NetworkManager.OPCODE_DISCONNECT, $oPlayer);
			}
			
			this.currentPlayerCount++;
			
			if (this.currentPlayerCount > this.maxPlayerCount)
			{
				this.maxPlayerCount = this.currentPlayerCount;
			}
			
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
			this.currentPlayerCount--;
			
			this.removeChild($oPlayer);
			
			if (this.p2 == $oPlayer)
			{
				this.txtp2.text = "";
				this.txtP2Health.text = "";
				this.txtp2Lives.text = "";
				this.p2 = null;
			}
			else if (this.p3 == $oPlayer)
			{
				this.txtp3.text = "";
				this.txtP3Health.text = "";
				this.txtp3Lives.text = "";
				this.p3 = null;
			}
			else if (this.p4 == $oPlayer)
			{
				this.txtp4.text = "";
				this.txtP4Health.text = "";
				this.txtp4Lives.text = "";
				this.p3 = null;
			}
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
			//ScreenManager.instance.mcActiveScreen.setKOs(this.me.kills, this.me.nLives);
			NetworkManager.instance.playerJoinedSignal.removeAll();
			NetworkManager.instance.playerRemovedSignal.removeAll();
			NetworkManager.instance.collectableAddedSignal.removeAll();
			NetworkManager.instance.disconnect();
			this.p1 = null;
			this.p2 = null;
			this.p3 = null;
			this.p4 = null;
			this.me = null;
			
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:* = this.getChildAt(i);
				if (child is Player || child is Collectable || child is Attack)
				{
					this.removeChild(child);
				}
			}
			
			_collectableSpawnTimer.removeEventListener(TimerEvent.TIMER, spawnItem);
			_collectableSpawnTimer.stop();
			
			KeyboardManager.instance.removeKeyDownListener(KeyCode.ESC, escKeyDownHandler);
			
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
					
				if (this.maxPlayerCount >= this.numPlayerInput)
				{
					var stillHasLivesCount:uint = 0;
					var stillAliveCount:uint = 0;
					
					for each (var player:Player in NetworkManager.instance.players)
					{
						if (player.alive)
						{
							stillAliveCount++;
						}
						if (player.nLives > 0)
						{
							stillHasLivesCount++;
						}
					}
					
					if (stillAliveCount <= 1 && stillHasLivesCount <= 1)
					{
						ScreenManager.instance.getScreen("Results").setKOs(this.me.kills, this.me.nLives);
						this.end();
					}
				}
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
			this.bPlaying = true;
			me.respawn();
		}
	}
}

