package edu.ewu.sounds
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	
	/**
	 * Keep track of a sound channel, keep track of the position it was stopped at, and automatically loop if desired. 
	 * 
	 * @author Justin Breitenbach
	 */
	public class Music
	{
		/** Keep track of last position _soundChannel was stopped at. */
		protected var	_pausePosition			:Number			= 0.0;
		/** Start position of the loop if looping. (Milliseconds) */
		protected var	_nLoopStartPosition		:Number;
		/** Sound channel created when played. */
		protected var	_soundChannel			:SoundChannel;
		/** Sound to be played. */
		protected var	_sound					:Sound;
		/** Determines whether or not to loop the sound. */
		public var		bLoop					:Boolean;
		/** The volume of the sound before transform. */
		protected var	_nVolume				:Number;
		/** The original volume of the sound specified at constructions. */
		protected var	_nOriginalVolume		:Number;
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Music object.
		 * 
		 * @param	$sndSound				The sound which the Music plays.
		 * @param	$nVolume				Initial volume of the Music (0.0 - 1.0).
		 * @param	$bLoop					Whether $sndSound should loop when it completes.
		 * @param	$nLoopStartPosition		Where the loop should start when $sndSound completes if looping.
		 */
		public function Music($sndSound:Sound, $nVolume:Number = 1.0, $bLoop:Boolean = false, $nLoopStartPosition = 0.0)
		{
			this.bLoop = $bLoop;
			if ($nVolume > 1.0 || $nVolume < 0.0)
			{
				this._nVolume = 1.0;
			}
			else
			{
				this._nVolume = $nVolume;
			}
			this._nOriginalVolume = this.nVolume;
			this._nLoopStartPosition = $nLoopStartPosition;
			this._sound = $sndSound;
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Play _sound and store SoundChannel
		 */
		public function play():void
		{
			this._soundChannel = this._sound.play(_pausePosition, 0, new SoundTransform(this._nVolume));
			if (this.bLoop)
			{
				this._soundChannel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Stop _soundChannel.
		 */
		public function stop():void
		{
			if (this.bLoop)
			{
				this._soundChannel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
			}
			this._pausePosition = 0.0;
			this._soundChannel.stop();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Stop _soundChannel and store its last position for resume functionality.
		 */
		public function pause():void
		{
			if (this.bLoop)
			{
				this._soundChannel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
			}
			this._pausePosition = this._soundChannel.position;
			this._soundChannel.stop();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Loop sound upon completion.
		 * 
		 * @param	$e		The dispatched Event.SOUND_COMPLETE event.
		 */
		protected function soundCompleteHandler($e:Event = null):void
		{
			$e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
			var sndOldTransform:SoundTransform = SoundChannel($e.currentTarget).soundTransform;
			//Apply sound transform from pre loop to maintain volume and other changes.
			this._soundChannel = this._sound.play(this._nLoopStartPosition, 0, sndOldTransform);
			this._soundChannel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Get _soundChannel.
		 * 
		 * @return			A SoundChannel if this is currently playing.
		 */
		public function get soundChannel():SoundChannel
		{
			return this._soundChannel;
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
		 * @param $nVolume	Volume to set music to.  Multiplies value by original volume to get relative volume. 
		 */
		public function set nVolume($nVolume:Number):void
		{
			var nRelativeVolume:Number = this._nOriginalVolume * $nVolume;
			if (nRelativeVolume > 1.0)
			{
				nRelativeVolume = 1.0;
			}
			else if (nRelativeVolume < 0.0)
			{
				nRelativeVolume = 0.0;
			}
			this._nVolume = nRelativeVolume;
			if (this._soundChannel)
			{
				this._soundChannel.soundTransform.volume = nRelativeVolume;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Get _nOriginalVolume.
		 * 
		 * @return			The volume that was specified at construction.
		 */
		public function get nOriginalVolume():Number
		{
			return this._nOriginalVolume;
		}
	}
}

