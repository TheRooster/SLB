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
		/** Reference to the Credits button */
		public var			_btQuit					:QuitButton;
		
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
			MusicManager.instance.crossSwitchMusic("Defeat");
			_btLobby.clickedSignal.addOnce(toLobby);
			_btCredits.clickedSignal.addOnce(toCredits);
			_btQuit.clickedSignal.addOnce(toPreloader);
			//txtKOs.text = NetworkManager.instance.players
			
			NetworkManager.instance.disconnect();
			super.begin();
		}
		
		override public function setKOs(kills:int, nLives:int):void
		{
			txtKOs.text = "You got " + kills + " KOs!";
			deaths = 3 - nLives;
				txtKOd.text = "You got KO'd " + deaths + " times!";
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
		
		private function toPreloader():void 
		{	
			ScreenManager.instance.crossSwitchScreen("Loading");
			ScreenManager.instance.mcActiveScreen.begin();
		}
	}
}

