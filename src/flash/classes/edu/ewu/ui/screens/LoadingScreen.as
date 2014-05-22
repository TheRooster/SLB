package edu.ewu.ui.screens 
{
	import edu.ewu.components.CreditsButton;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.SubmitButton;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.ui.buttons.SoundButton;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	
	/**
	 * Drives the CreditsScreen class.
	 * 
	 * @author Tyler Peek
	 */
	public class LoadingScreen extends AbstractScreen
	{	
		/** Signal that is dispatched after the button is clicked. */
		public var			clickedSignal			:Signal = new Signal();
		/** Reference to the back button */
		public var			_btLobby				:SoundButton;
		
		public var txtLoading:TextField = new TextField();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the LobbyScreen object.
		 */
		public function LoadingScreen()
		{	
			super();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Begins LoadingScreen functions.
		 */
		override public function begin():void
		{
			MusicManager.instance.crossSwitchMusic("Victory");
			_btLobby.clickedSignal.addOnce(toLobby);
			super.begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		

		private function toLobby():void 
		{	
			ScreenManager.instance.crossSwitchScreen("Lobby");
			ScreenManager.instance.mcActiveScreen.begin();
		}
	}
}



