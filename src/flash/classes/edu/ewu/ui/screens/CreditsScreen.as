package edu.ewu.ui.screens 
{
	import edu.ewu.components.CreditsButton;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.SubmitButton;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.ui.buttons.SoundButton;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	import flash.net.navigateToURL;
	
	/**
	 * Drives the CreditsScreen class.
	 * 
	 * @author Tyler Peek
	 */
	public class CreditsScreen extends AbstractScreen
	{	
		/** Signal that is dispatched after the button is clicked. */
		public var			clickedSignal			:Signal = new Signal();
		/** Reference to the back button */
		public var			_btBack				:SoundButton;
		
		public var txtEmailJustin:TextField;
		public var txtEmailTyler:TextField;
		public var txtEmailJon:TextField;
		public var txtEmailLindsey:TextField;
		
		public var txtLink1:TextField;
		public var txtLink2:TextField;
		public var txtLink3:TextField;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the LobbyScreen object.
		 */
		public function CreditsScreen()
		{	
			
			super();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Begins CreditsScreen functions.
		 */
		override public function begin():void
		{
			MusicManager.instance.crossSwitchMusic("Victory");
			_btBack.clickedSignal.addOnce(toLobby);
			
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



