package edu.ewu.sounds
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import edu.ewu.datastructures.Stack;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	/**
	 * Allow for easy managment of music transitions
	 * 
	 * @author Justin Breitenbach
	 */
	public class MusicManager
	{
		
		/** Stores a reference to the singleton instance. */  
		private static const _instance					:MusicManager 	= new MusicManager(SingletonLock);
		/** Reference to the active Music */
		public var			oActiveMusic				:Music;
		/** Reference to what position the sound channel was stopped. */
		protected var		_oMusicStack				:Stack			= new Stack();
		/** Reference to a Dictionary of music */
		protected var		_dMusic						:Dictionary 	= new Dictionary();
		/** Current volume of the music */
		protected var		_nVolume					:Number			= 1.0;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the MusicManager object.
		 */
		public function MusicManager($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("MusicManager is a singleton and should not be instantiated. Use MusicManager.instance instead");
		}

		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns instance of MusicManager if it exists.
		 * 
		 * @return			Returns singleton instance of MusicManager.
		 */
		public static function get instance():MusicManager
		{
			return _instance;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Stops current music and plays music that was added with $newMusicName.
		 * Moveds active music to secondary.
		 * 
		 * @param	$newMusicName	Name of the music (specified during add()) to switch to.
		 */
		public function switchMusic($newMusicName:String):void
		{
			var oNewMusic:Music = this._dMusic[$newMusicName];
			if (this.oActiveMusic)
			{
				this.oActiveMusic.pause();
				this._oMusicStack.push(this.oActiveMusic);
				this.oActiveMusic = null;
			}
			if (oNewMusic)
			{
				this.oActiveMusic = oNewMusic;
				this.oActiveMusic.nVolume = this._nVolume;
				this.oActiveMusic.play();
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Stops current music, gets last music played, and plays.
		 */
		public function switchBackMusic():void
		{
			if (this.oActiveMusic)
			{
				this.oActiveMusic.pause();
				this.oActiveMusic = null;
			}
			if (this._oMusicStack.isEmpty() == false)
			{
				this.oActiveMusic = Music(this._oMusicStack.pop());
				this.oActiveMusic.nVolume = this._nVolume;
				this.oActiveMusic.play();
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Fades between active music and music added with $newMusicName.
		 * 
		 * @param	$newMusicName	Name of the music (specified during add()) to switch to.
		 * @param	$fadeTime		Time (in seconds) to fade between music.
		 */
		public function crossSwitchMusic($newMusicName:String, $fadeTime:Number = 1.0):void
		{
			var oNewMusic:Music = this._dMusic[$newMusicName];
			if (this.oActiveMusic)
			{
				var oOriginalMusic:Music = this.oActiveMusic;
				if (oOriginalMusic.soundChannel)
				{
					this._oMusicStack.push(oOriginalMusic);
					this.oActiveMusic = null;
					TweenMax.to(oOriginalMusic.soundChannel, $fadeTime, { volume: 0, ease: Linear.easeNone, onComplete: oOriginalMusic.pause });
				}
			}
			if (oNewMusic)
			{
				this.oActiveMusic = oNewMusic;
				this.oActiveMusic.nVolume = this._nVolume;
				this.oActiveMusic.play();
				TweenMax.to(oNewMusic.soundChannel, 0, { volume: 0 } );
				TweenMax.to(oNewMusic.soundChannel, $fadeTime, { volume: oNewMusic.nVolume, ease: Linear.easeNone });
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Fades between active and secondary music.
		 * Switches active and secondary.
		 * 
		 * @param	$fadeTime		Time (in seconds) to fade between music.
		 */
		public function crossSwitchBackMusic($fadeTime:Number = 1.0):void
		{
			if (this.oActiveMusic)
			{
				var oOriginalMusic:Music = this.oActiveMusic;
				if (oOriginalMusic.soundChannel)
				{
					this._oMusicStack.push(oOriginalMusic);
					this.oActiveMusic = null;
					TweenMax.to(oOriginalMusic.soundChannel, $fadeTime, { volume: 0, ease: Linear.easeNone, onComplete: oOriginalMusic.pause });
				}
			}
			if (this._oMusicStack.isEmpty() == false)
			{
				var oBackMusic:Music = this._dMusic.pop();
				this.oActiveMusic = oBackMusic;
				this.oActiveMusic.nVolume = this._nVolume;
				this.oActiveMusic.play();
				TweenMax.to(oBackMusic.soundChannel, 0, { volume: 0 } );
				TweenMax.to(oBackMusic.soundChannel, $fadeTime, { volume: oBackMusic.nVolume, ease: Linear.easeNone });
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Add Music to MusicManager overwriting Music if one with the same $name is found.
		 *
		 * @param	$oNewMusic	The Music to be added.
		 * @param	$sName 		The name for $newMusic to be added under.
		 */
		public function add($sName:String, $oNewMusic:Music):void
		{
			this._dMusic[$sName] = $oNewMusic;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Removes a Music from MusicManager if one with the same $sName is found.
		 *
		 * @param	$sName 		The name the Music was added under to be removed.
		 * @return				The Music which was removed.
		 */
		public function remove($sName:String):Music
		{
			var oRemovedMusic:Music = this._dMusic[$sName];
			this._dMusic[$sName] = null;
			return oRemovedMusic;
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
		 * Sets _nVolume.
		 * 
		 * @param $nVolume	Volume to set music to. (0.0 - 1.0) 
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
			if (this.oActiveMusic)
			{
				this.oActiveMusic.nVolume =  $nVolume;
			}
		}
	}
}

class SingletonLock{};

