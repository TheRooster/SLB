package 
{
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
		private const DEVKEY:String = "";
		private const SERV_KEY:String = SERVER + DEVKEY;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Main object.
		 */
		public function Main():void
		{
			KeyboardManager.init(this.stage);
			StageRef.stage = this.stage;
			
			MusicManager.instance.add("Lobby", new Music(new LobbyLoop(), 1.0, true)); 
			MusicManager.instance.add("Game", new Music(new GameLoop(), 1.0, true, 1914)); 
			
			SoundManager.instance.add("ButtonClick", new ClickSound());
			
			var lobbyScreen:LobbyScreen = new LobbyScreen();
			ScreenManager.instance.add("Lobby", lobbyScreen);
			var gameScreen:GameScreen = new GameScreen();
			ScreenManager.instance.add("Game", gameScreen);
			
			this.addChild(lobbyScreen);
			this.addChild(gameScreen);
			
			NetworkManager.instance.initConnection(SERV_KEY);
			
			ScreenManager.instance.switchScreen("Lobby");
			ScreenManager.instance.mcActiveScreen.begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */

	}
}

