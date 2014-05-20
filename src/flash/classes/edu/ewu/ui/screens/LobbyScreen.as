package edu.ewu.ui.screens
{


	import edu.ewu.components.CreditsButton;
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
	 * @author Justin Breitenbach
	 */
	public class LobbyScreen extends AbstractScreen
	{	
		/** Signal that is dispatched after the button is clicked. */
		public var			clickedSignal			:Signal = new Signal();
		/** Reference to the input text field */
		public var			_txtPlayerName			:TextField;
		/** Reference to the Submit button */
		public var			_btSubmit				:SubmitButton;
		/** Reference to the Credits button */
		public var			_btCredits				:CreditsButton;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the LobbyScreen object.
		 */
		public function LobbyScreen()
		{	
			
			super();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Begins GameScreen functions.
		 */
		override public function begin():void
		{
			MusicManager.instance.crossSwitchMusic("Lobby");
			_btSubmit.clickedSignal.addOnce(onSubmit);
			_btCredits.clickedSignal.addOnce(toCredits);
			super.begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function onSubmit():void 
		{
			var name:String = _txtPlayerName.text;
			if (name == "Anon" || name == "")
			{
				name = "Anon" + uint(Math.random() * 10000).toString();
			}
			var me:LocalPlayer = new LocalPlayer(name, "RonaldMcDonald");
			me.x = stage.stageWidth * 0.5;
			me.y = stage.stageHeight * 0.5;
			
			ScreenManager.instance.crossSwitchScreen("Game");
			ScreenManager.instance.mcActiveScreen.begin();
			
			
			NetworkManager.instance.add(name, me);
			NetworkManager.instance.connect(name, me);
			ScreenManager.instance.mcActiveScreen.addChild(me);
		}
		
		
		private function toCredits():void 
		{	
			ScreenManager.instance.crossSwitchScreen("Credits");
			ScreenManager.instance.mcActiveScreen.begin();
		}
	}
}

