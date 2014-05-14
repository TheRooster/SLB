package edu.ewu.ui.screens
{
	import flash.utils.Dictionary;

	/**
	 * Allow for easy managment of screens and screen transitions
	 * 
	 * @author Justin Breitenbach
	 */
	public class ScreenManager
	{
		
		/** Stores a reference to the singleton instance. */  
		private static const _instance			:ScreenManager = new ScreenManager(SingletonLock);
		/** Reference to the active Screen */
		public var			mcActiveScreen		:AbstractScreen;
		/** Reference to a Dictionary of extra screens */
		protected var		_dScreens			:Dictionary = new Dictionary();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the ScreenManager object.
		 */
		public function ScreenManager($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("ScreenManager is a singleton and should not be instantiated. Use ScreenManager.instance instead");
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns instance of ScreenManager if it exists.
		 * 
		 * @return			Returns singleton instance of ScreenManager.
		 */
		public static function get instance():ScreenManager
		{
			return _instance;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Switches screens, starting to show the new screen when the other has finished hiding.
		 * 
		 * @param	$sNewScreenName		Name of the screen (specified during add()) to switch to.
		 */
		public function switchScreen($sNewScreenName:String):void
		{
			var mcNewScreen:AbstractScreen = this._dScreens[$sNewScreenName];
			
			if (this.mcActiveScreen)
			{
				function showNewScreen():void
				{
					if (mcNewScreen)
					{
						mcNewScreen.show();
						ScreenManager.instance.mcActiveScreen = mcNewScreen;
					}
				}
				
				this.mcActiveScreen.hideCompletedSignal.addOnce(showNewScreen);
				this.mcActiveScreen.hide();
			}
			else if (mcNewScreen)
			{
				mcNewScreen.show();
				this.mcActiveScreen = mcNewScreen;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Starts showing and hiding screens simultaniously.
		 * 
		 * @param	$sNewScreenName		Name of the screen (specified during add()) to switch to.
		 */
		public function crossSwitchScreen($sNewScreenName:String):void
		{
			var mcNewScreen:AbstractScreen = this._dScreens[$sNewScreenName];
			if (this.mcActiveScreen)
			{
				this.mcActiveScreen.hide();
				this.mcActiveScreen = null;
			}
			if (mcNewScreen)
			{
				mcNewScreen.show();
				this.mcActiveScreen = mcNewScreen;
			}
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Add screen to ScreenManager overwriting screen if one with the same $name is found.
		 *
		 * @param	$mcNewScreen		The AbstractScreen to be added.
		 * @param	$sScreenName 		The name for $newScreen to be added under.
		 */
		public function add($sScreenName:String, $mcNewScreen:AbstractScreen):void
		{
			this._dScreens[$sScreenName] = $mcNewScreen;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Removes a screen from ScreenManager if one with the same $name is found.
		 *
		 * @param	$sScreenName		The name the AbstractScreen was added under to be removed.
		 * @return						The AbstractScreen which was removed.
		 */
		public function remove($sScreenName:String):AbstractScreen
		{
			var mcRemovedScreen:AbstractScreen = this._dScreens[$sScreenName];
			this._dScreens[$sScreenName] = null;
			return mcRemovedScreen;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Retrieved a screen from ScreenManager if one with the same $name is found.
		 *
		 * @param	$sScreenName 		The name the AbstractScreen was added under to be retrieved.
		 * @return						The AbstractScreen which if it was found.
		 */
		public function getScreen($sScreenName:String):AbstractScreen
		{
			return this._dScreens[$sScreenName];
		}
	}
}

class SingletonLock{};

