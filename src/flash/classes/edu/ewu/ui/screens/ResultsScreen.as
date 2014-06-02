package edu.ewu.ui.screens
{
	import edu.ewu.components.BackButton;
	import edu.ewu.components.CreditsButton;
	import edu.ewu.ui.buttons.QuitButton;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.SubmitButton;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.ui.buttons.SoundButton;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	
	/**
	 * Drives the LobbyScreen class.
	 * 
	 * @author Tyler Peek
	 */
	public class ResultsScreen extends AbstractScreen
	{	
		/** Signal that is dispatched after the button is clicked. */
		public var			clickedSignal			:Signal = new Signal();
		/** References to the text fields */
		public var			txtKOs					:TextField;
		public var			txtKOd					:TextField;
		/** Reference to the Submit button */
		public var			_btLobby				:BackButton;
		/** Reference to the Credits button */
		public var			_btCredits				:CreditsButton;	
		
		var deaths:int = 0;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the ResultsScreen object.
		 */
		public function ResultsScreen()
		{	
			super();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Begins GameScreen functions.
		 */
		override public function begin():void
		{
			//This code should end world hunger.
			//ScreenManager.instance.remove("Game");
			//ScreenManager.instance.remove("Lobby");
			//var lobbyScreen:LobbyScreen = new LobbyScreen();
			//ScreenManager.instance.getScreen("Lobby") = new LobbyScreen();
			//var gameScreen:GameScreen = new GameScreen();
			//ScreenManager.instance.getScreen("Game") = AbstractScreen(gameScreen);
			
			_btLobby.clickedSignal.addOnce(toLobby);
			_btCredits.clickedSignal.addOnce(toCredits);
			//txtKOs.text = NetworkManager.instance.players
			
			//NetworkManager.instance.disconnect();
			super.begin();
		}
		
		override public function setKOs(kills:int, nLives:int):void
		{
			txtKOs.text = "You got " + kills.toString() + " KOs!";
			var deaths:int = 3 - nLives;
			txtKOd.text = "You got KO'd " + deaths.toString() + " times!";
			
			if (kills > deaths)
			{
				MusicManager.instance.crossSwitchMusic("Victory");
			}
			else
			{
				MusicManager.instance.crossSwitchMusic("Defeat");
			}
		}
		
		public function setFullServerMessage():void
		{
			txtKOs.text = "Server was full";
			txtKOd.text = "";
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function toLobby():void 
		{
			ScreenManager.instance.crossSwitchScreen("Lobby");
			ScreenManager.instance.mcActiveScreen.begin();
		}
		
		
		private function toCredits():void 
		{	
			ScreenManager.instance.crossSwitchScreen("Credits");
			ScreenManager.instance.mcActiveScreen.begin();
		}
	}
}

