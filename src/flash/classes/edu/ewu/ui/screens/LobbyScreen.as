package edu.ewu.ui.screens
{
	import edu.ewu.components.CreditsButton;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.SubmitButton;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.ui.buttons.BKButton;
	import edu.ewu.ui.buttons.RonButton;
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
		/** Reference to the Ron button */
		public var			_btRon				:RonButton;	
		/** Reference to the BK button */
		public var			_btBK				:BKButton;	
		/** Reference to the Credits button */
		public var			_btCredits				:CreditsButton;	
		public var			character				:String = "RonaldMcDonald";
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
			_btRon.clickedSignal.addOnce(changeCharacterToRon);
			_btBK.clickedSignal.addOnce(changeCharacterToBK);
			super.begin();
		}
		
		
		public function changeCharacterToRon():void
		{
			this.character = "RonaldMcDonald";
		}
		
		public function changeCharacterToBK():void
		{
			this.character = "BurgerKing";
		}
		/* ---------------------------------------------------------------------------------------- */
		
		private function onSubmit():void 
		{
			var name:String = _txtPlayerName.text;
			if (name == "Anon" || name == "")
			{
				name = "Anon" + uint(Math.random() * 10000).toString();
			}
			
			ScreenManager.instance.crossSwitchScreen("Game");
			ScreenManager.instance.mcActiveScreen.begin();
			ScreenManager.instance.mcActiveScreen.setPlayer(name, character);
		}
		
		
		private function toCredits():void 
		{	
			ScreenManager.instance.crossSwitchScreen("Credits");
			ScreenManager.instance.mcActiveScreen.begin();
		}
	}
}

