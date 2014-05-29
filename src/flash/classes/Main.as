package 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.natejc.input.KeyboardManager;
	import com.natejc.utils.StageRef;
	import edu.ewu.components.CreditsButton;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.Music;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.sounds.SoundManager;
	import edu.ewu.ui.screens.CreditsScreen;
	import edu.ewu.ui.screens.GameScreen;
	import edu.ewu.ui.screens.LobbyScreen;
	import edu.ewu.ui.screens.LoadingScreen;
	import edu.ewu.ui.screens.ResultsScreen;
	import edu.ewu.ui.screens.ScreenManager;
	import flash.display.MovieClip;
	
	
	/**
	 * Drives the project.
	 * 
	 * @author	
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
			//var loader:XMLLoader =  new XMLLoader("resources/xml/serverKey.xml", { name:"key", onComplete:initNetwork} );
			//loader.load();
			
			
			MusicManager.instance.add("Lobby", new Music(new LobbyLoop(), 0.15, true)); 
			MusicManager.instance.add("Game", new Music(new GameLoop(), 0.15, true, 1914)); 
			MusicManager.instance.add("Victory", new Music(new VictoryLoop(), 0.15, true, 27549)); 
			MusicManager.instance.add("Defeat", new Music(new DefeatLoop(), 0.15, true)); 
			
			SoundManager.instance.add("ButtonClick", new ClickSound());
			SoundManager.instance.add("Thump", new ThumpSound());
			SoundManager.instance.add("Death", new DeathSound());
			
			
			var loadingScreen:LoadingScreen = new LoadingScreen();
			ScreenManager.instance.add("Loading", loadingScreen);
			var lobbyScreen:LobbyScreen = new LobbyScreen();
			ScreenManager.instance.add("Lobby", lobbyScreen);
			var gameScreen:GameScreen = new GameScreen();
			ScreenManager.instance.add("Game", gameScreen);
			var creditsScreen:CreditsScreen = new CreditsScreen();
			ScreenManager.instance.add("Credits", creditsScreen);
			var resultsScreen:ResultsScreen = new ResultsScreen();
			ScreenManager.instance.add("Results", resultsScreen);
			
			this.addChild(loadingScreen);
			this.addChild(lobbyScreen);
			this.addChild(gameScreen);
			this.addChild(creditsScreen);
			this.addChild(resultsScreen);
			
			
			
			ScreenManager.instance.switchScreen("Loading");
			ScreenManager.instance.mcActiveScreen.begin();
		}
		
		/* ---------------------------------------------------------------------------------------- 
		
		private function initNetwork(event:LoaderEvent):void 
		{
			DEVKEY = (LoaderMax.getContent("key")).Key; 
			SERV_KEY = SERVER + DEVKEY; 
			NetworkManager.instance.initConnection(SERV_KEY);
		}
		
		/* ---------------------------------------------------------------------------------------- */

	}
}

