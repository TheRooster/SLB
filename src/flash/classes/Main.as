package 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.XMLLoader;
	import com.natejc.input.KeyboardManager;
	import com.natejc.utils.StageRef;
	import edu.ewu.sounds.Music;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.sounds.SoundManager;
	import edu.ewu.ui.screens.CreditsScreen;
	import edu.ewu.ui.screens.GameScreen;
	import edu.ewu.ui.screens.LoadingScreen;
	import edu.ewu.ui.screens.LobbyScreen;
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
		
		var loadingScreen:LoadingScreen = new LoadingScreen();
		var lobbyScreen:LobbyScreen = new LobbyScreen();
		var gameScreen:GameScreen = new GameScreen();
		var creditsScreen:CreditsScreen = new CreditsScreen();
		var resultsScreen:ResultsScreen = new ResultsScreen();
		
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
			
			LoaderMax.activate([MP3Loader]);
			var mainQueue:LoaderMax = new LoaderMax( { name:"mainQueue", onComplete:completeHandler } );
			this.loadMusic(mainQueue);
			this.loadSounds(mainQueue);
			mainQueue.load();	
		}
		
		private function completeHandler(event:LoaderEvent)
		{
			//loadingScreen = new LoadingScreen();
			ScreenManager.instance.add("Loading", loadingScreen);
			//lobbyScreen = new LobbyScreen();
			ScreenManager.instance.add("Lobby", lobbyScreen);
			//gameScreen = new GameScreen();
			ScreenManager.instance.add("Game", gameScreen);
			//creditsScreen = new CreditsScreen();
			ScreenManager.instance.add("Credits", creditsScreen);
			//resultsScreen = new ResultsScreen();
			ScreenManager.instance.add("Results", resultsScreen);
			
			resultsScreen.beginCompletedSignal.add(reset);
			
			this.addChild(loadingScreen);
			this.addChild(lobbyScreen);
			this.addChild(gameScreen);
			this.addChild(creditsScreen);
			this.addChild(resultsScreen);
			
			ScreenManager.instance.switchScreen("Loading");
			ScreenManager.instance.mcActiveScreen.begin();
		}
		
		private function reset()
		{
			this.removeChild(lobbyScreen);
			this.removeChild(gameScreen);
			ScreenManager.instance.remove("Lobby");
			ScreenManager.instance.remove("Game");
			lobbyScreen = new LobbyScreen();
			ScreenManager.instance.add("Lobby", lobbyScreen);
			gameScreen = new GameScreen();
			ScreenManager.instance.add("Game", gameScreen);
			this.addChild(lobbyScreen);
			this.addChild(gameScreen);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		//{ region Loading
		
		//{ region Music
		
		private function loadMusic(queue:LoaderMax)
		{
			var musicLoader:XMLLoader = new XMLLoader("resources/audio/music/music.xml", { name:"musicLoader", onComplete:musicOnComplete } );
			queue.append(musicLoader);
		}
		
		private function musicOnComplete(event:LoaderEvent)
		{
			var loaders:Array = (event.target as XMLLoader).getChildren(true, true);
			loaders.forEach(addMusic);
		}
		
		private function addMusic(loader:MP3Loader, index:int, array:Array)
		{ 
			var name:String = loader.vars.name;
			var loopStart:Number = loader.vars.loopStart;
			var loops:Boolean = loader.vars.loops;
			var volume:Number = loader.vars.volume;
			MusicManager.instance.add(name, new Music(LoaderMax.getContent(name), volume, loops, loopStart));
		}
		
		//} endregion
		
		//{ region Sounds
		
		private function loadSounds(queue:LoaderMax)
		{
			var soundsLoader:XMLLoader = new XMLLoader("resources/audio/sounds/sounds.xml", { name:"soundsLoader", onComplete:soundsOnComplete } );
			queue.append(soundsLoader);
		}
		
		private function soundsOnComplete(event:LoaderEvent)
		{
			var loaders:Array = (event.target as XMLLoader).getChildren(true, true);
			loaders.forEach(addSound);
		}
		
		private function addSound(loader:MP3Loader, index:int, array:Array)
		{
			var name:String = loader.vars.name;
			SoundManager.instance.add(name, LoaderMax.getContent(name));
		}
		
		//} endregion
		
		//} endregion
	}
}