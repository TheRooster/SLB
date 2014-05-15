package edu.ewu.ui.screens
{
<<<<<<< HEAD
	import edu.ewu.components.NamePrompt;
=======
>>>>>>> 5941e9013b9e30c9869303147550fe452f54669f
	import edu.ewu.components.player.LocalPlayer;
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
		public var			_btSubmit				:SoundButton;
		
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
			super.begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function onSubmit():void 
		{
			var name:String = _txtPlayerName.text;
			if (name == "")
			{
				name = "Anon";
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
	}
}

