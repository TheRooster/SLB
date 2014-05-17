package 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.natejc.input.KeyboardManager;
	import com.natejc.utils.StageRef;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.Music;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.sounds.SoundManager;
	import edu.ewu.ui.screens.GameScreen;
	import edu.ewu.ui.screens.LobbyScreen;
	import edu.ewu.ui.screens.ScreenManager;
	import flash.display.MovieClip;
	
	
	/**
	 * Drives the project.
	 * 
	 * @author	Nate Chatellier
	 */
	public class Main extends MovieClip
	{
		
		
		
		private const SERVER:String = "rtmfp://p2p.rtmfp.net/";
		private var   DEVKEY:String = "";
		private var SERV_KEY:String = "";
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Main object.
		 */
		public function Main():void
		{
			KeyboardManager.init(this.stage);
			StageRef.stage = this.stage;
			
			
			//Load the key from an xml file named serverKey, <serverKey><Key>yourkeyHere</Key></serverKey>
			var loader:XMLLoader =  new XMLLoader("resources/xml/serverKey.xml", { name:"key", onComplete:initNetwork} );
			loader.load();
			
			
			
			MusicManager.instance.add("Lobby", new Music(new LobbyLoop(), 0.15, true)); 
			MusicManager.instance.add("Game", new Music(new GameLoop(), 0.15, true, 1914)); 
			
			SoundManager.instance.add("ButtonClick", new ClickSound());
			SoundManager.instance.add("Thump", new ThumpSound());
			
			var lobbyScreen:LobbyScreen = new LobbyScreen();
			ScreenManager.instance.add("Lobby", lobbyScreen);
			var gameScreen:GameScreen = new GameScreen();
			ScreenManager.instance.add("Game", gameScreen);
			
			this.addChild(lobbyScreen);
			this.addChild(gameScreen);
			
			
			
			ScreenManager.instance.switchScreen("Lobby");
			ScreenManager.instance.mcActiveScreen.begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function initNetwork(event:LoaderEvent):void 
		{
			DEVKEY = (LoaderMax.getContent("key")).Key; 
			SERV_KEY = SERVER + DEVKEY; 
			NetworkManager.instance.initConnection(SERV_KEY);
		}
		
		/* ---------------------------------------------------------------------------------------- */

	}
}

