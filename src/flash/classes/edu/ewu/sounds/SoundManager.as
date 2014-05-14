package edu.ewu.sounds
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	/**
	 * Allow for easy managment of soundss.
	 * 
	 * @author Justin Breitenbach
	 */
	public class SoundManager
	{
		
		/** Stores a reference to the singleton instance. */  
		private static const _instance					:SoundManager 	= new SoundManager(SingletonLock);
		/** Reference to a Dictionary of sound */
		protected var		_dSound						:Dictionary 	= new Dictionary();
		/** Current volume of the sound */
		protected var		_nVolume					:Number			= 1.0;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the SoundManager object.
		 */
		public function SoundManager($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("SoundManager is a singleton and should not be instantiated. Use SoundManager.instance instead");
		}

		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns instance of SoundManager if it exists.
		 * 
		 * @return			Returns singleton instance of SoundManager.
		 */
		public static function get instance():SoundManager
		{
			return _instance;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Plays sound that was added with $soundName.
		 * 
		 * @param	$soundName	Name of the sound (specified during add()) to play.
		 */
		public function playSound($soundName:String):void
		{
			var oSound:Sound = this._dSound[$soundName];
			if (oSound)
			{
				var oSoundChannel:SoundChannel = oSound.play();
				oSoundChannel.soundTransform.volume = this._nVolume;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Add Sound to SoundManager overwriting Sound if one with the same $name is found.
		 *
		 * @param	$oNewSound	The Sound to be added.
		 * @param	$sName 		The name for $newSound to be added under.
		 */
		public function add($sName:String, $oNewSound:Sound):void
		{
			this._dSound[$sName] = $oNewSound;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Removes a Sound from SoundManager if one with the same $sName is found.
		 *
		 * @param	$sName 		The name the Sound was added under to be removed.
		 * @return				The Sound which was removed.
		 */
		public function remove($sName:String):Sound
		{
			var oRemovedSound:Sound = this._dSound[$sName];
			this._dSound[$sName] = null;
			return oRemovedSound;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Get _nVolume.
		 * 
		 * @return			The current volume.
		 */
		public function get nVolume():Number
		{
			return this._nVolume;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Sets _nVolume which is used to determine what new sounds will play at.
		 * 
		 * @param $nVolume	Volume to set sound to. (0.0 - 1.0) 
		 */
		public function set nVolume($nVolume:Number):void
		{
			var nFixedVolume:Number = $nVolume;
			if (nFixedVolume > 1.0)
			{
				nFixedVolume = 1.0;
			}
			else if (nFixedVolume < 0.0)
			{
				nFixedVolume = 0.0;
			}
			this._nVolume = nFixedVolume;
		}
	}
}

class SingletonLock{};

