package edu.ewu.ui.screens
{
	import edu.ewu.components.CreditsButton;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.SubmitButton;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.MusicManager;
	import edu.ewu.ui.buttons.BKButton;
	import edu.ewu.ui.buttons.ColonelButton;
	import edu.ewu.ui.buttons.HostButton;
	import edu.ewu.ui.buttons.IslandMap;
	import edu.ewu.ui.buttons.JackButton;
	import edu.ewu.ui.buttons.PapaButton;
	import edu.ewu.ui.buttons.RonButton;
	import edu.ewu.ui.buttons.SoundButton;
	import edu.ewu.ui.buttons.TrayMap;
	import edu.ewu.ui.buttons.UFCMap;
	import edu.ewu.ui.buttons.WendyButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	import com.greensock.*;
	
	/**
	 * Drives the LobbyScreen class.
	 * 
	 * @author Justin Breitenbach
	 */
	public class LobbyScreen extends AbstractScreen
	{	
		/** Signal that is dispatched after the button is clicked. */
		public var			clickedSignal			:Signal = new Signal();
		/** References to the input text fields */
		public var			_txtPlayerName			:TextField;
		public var			_txtServer				:TextField;
		public var			_txtPlayers				:TextField;
		
		/** Reference to the Submit button */
		public var			_btSubmit				:SubmitButton;
		/** Reference to the Host button */
		public var			_btHost					:HostButton;
		
		/** Reference to the Ron button */
		public var			_btRon					:RonButton;	
		/** Reference to the BK button */
		public var			_btBK					:BKButton;
		/** Reference to the Wendy button */
		public var			_btWendy				:WendyButton;
		/** Reference to the Jack button */
		public var			_btJack					:JackButton;
		/** Reference to the Colonel button */
		public var			_btColonel				:ColonelButton;
		/** Reference to the Papa button */
		public var			_btPapa					:PapaButton;
		
		/** Reference to the TrayMap button */
		public var			_btTrayMap				:TrayMap;
		/** Reference to the IslandMap button */
		public var			_btIslandMap			:IslandMap;
		/** Reference to the UFCMap button */
		public var			_btUFCMap				:UFCMap;
		
		/** Reference to the Credits button */
		public var			_btCredits				:CreditsButton;	
		public var			character				:String = "RonaldMcDonald";
		public var			map						:int = 2;
		
		//Number of players allowed
		protected var _nNumberOfPlayers :uint = 4;
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
			
			
			_btSubmit.clickedSignal.add(onSubmit);
			_btCredits.clickedSignal.add(toCredits);
			_btRon.clickedSignal.add(changeCharacterToRon);
			_btBK.clickedSignal.add(changeCharacterToBK);
			_btWendy.clickedSignal.add(changeCharacterToWendy);
			_btJack.clickedSignal.add(changeCharacterToJack);
			_btPapa.clickedSignal.add(changeCharacterToPapa);
			_btColonel.clickedSignal.add(changeCharacterToColonel);
			_btTrayMap.clickedSignal.add(changeMapToTray);
			_btIslandMap.clickedSignal.add(changeMapToIsland);
			_btUFCMap.clickedSignal.add(changeMapToUFC);
			
			
			super.begin();
			fadeCharacters();
			fadeMaps();
			_btRon.alpha = 1;
			_btTrayMap.alpha = 1;
		}
		
		
		public function changeCharacterToRon():void
		{
			this.character = "RonaldMcDonald";
			fadeCharacters();
			this._btRon.alpha = 1;
		}
		
		public function changeCharacterToBK():void
		{
			this.character = "BurgerKing";
			fadeCharacters();
			this._btBK.alpha = 1;
		}
		
		public function changeCharacterToWendy():void
		{
			this.character = "Wendy";
			fadeCharacters();
			this._btWendy.alpha = 1;
		}
		
		public function changeCharacterToJack():void
		{
			this.character = "Jack";
			fadeCharacters();
			this._btJack.alpha = 1;
		}
		
		public function changeCharacterToPapa():void
		{
			this.character = "PapaJohn";
			fadeCharacters();
			this._btPapa.alpha = 1;
		}
		
		public function changeCharacterToColonel():void
		{
			this.character = "ColonelSanders";
			fadeCharacters();
			this._btColonel.alpha = 1;
		}
		
		public function fadeCharacters():void
		{
			_btRon.alpha = .5;
			_btBK.alpha = .5;
			_btWendy.alpha = .5;
			_btJack.alpha = .5;
			_btColonel.alpha = .5;
			_btPapa.alpha = .5;
		}
		
		public function fadeMaps():void
		{
			_btTrayMap.alpha = .5;
			_btIslandMap.alpha = .5;
			_btUFCMap.alpha = .5;
		}
		
		public function changeMapToTray():void
		{
			this.map = 2;
			fadeMaps();
			_btTrayMap.alpha = 1;
		}
		
		public function changeMapToIsland():void
		{
			this.map = 3;
			fadeMaps();
			_btIslandMap.alpha = 1;
		}
		
		public function changeMapToUFC():void
		{
			this.map = 4;
			fadeMaps();
			_btUFCMap.alpha = 1;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function onSubmit():void 
		{
			var name:String = _txtPlayerName.text;
			var sessionName:String = _txtServer.text;
			if (name == "Anon" || name == "")
			{
				name = "Anon" + uint(Math.random() * 10000).toString();
			}
			if (sessionName == "Server1" || sessionName == "")
			{
				sessionName = "SimpleDemoGroup";
			}
			_nNumberOfPlayers = int(_txtPlayers.text);
			
			if (_nNumberOfPlayers > 4)
			{
				_nNumberOfPlayers = 4;
			}
			else if (_nNumberOfPlayers < 2)
			{
				_nNumberOfPlayers = 2;
			}
			
			sessionName += this.map.toString();
			sessionName += this._nNumberOfPlayers.toString();
			
			
			ScreenManager.instance.crossSwitchScreen("Game");
			ScreenManager.instance.mcActiveScreen.gotoAndPlay(map);
			//ScreenManager.instance.mcActiveScreen.begin();
			//ScreenManager.instance.mcActiveScreen.begin();
			ScreenManager.instance.mcActiveScreen.setGame(name, character, sessionName, _nNumberOfPlayers);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function onHost():void 
		{
			var name:String = _txtPlayerName.text;
			var sessionName:String = _txtServer.text;
			if (name == "Anon" || name == "")
			{
				name = "Anon" + uint(Math.random() * 10000).toString();
			}
			
			ScreenManager.instance.crossSwitchScreen("Game");
			ScreenManager.instance.mcActiveScreen.gotoAndPlay(map);
			ScreenManager.instance.mcActiveScreen.begin();
			ScreenManager.instance.mcActiveScreen.setGame(name, character, sessionName, 4);
		}
		
		private function toCredits():void 
		{	
			ScreenManager.instance.crossSwitchScreen("Credits");
			ScreenManager.instance.mcActiveScreen.begin();
		}
	}
}

