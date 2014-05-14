package edu.ewu.ui.screens
{
	import flash.display.MovieClip;
	import org.osflash.signals.Signal;
	
	/**
	 * Provide base functionality for screens
	 * 
	 * @author Justin Breitenbach
	 */
	public class AbstractScreen extends MovieClip
	{
		/** Signal for when the show function has completed */
		public var		showCompletedSignal			:Signal = new Signal();
		/** Signal for when the hide function has completed */
		public var		hideCompletedSignal			:Signal = new Signal();
		/** Signal for when the begin function has completed */
		public var		beginCompletedSignal		:Signal = new Signal();
		/** Signal for when the end function has completed */
		public var		endCompletedSignal			:Signal = new Signal();
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the AbstractScreen object.
		 */
		public function AbstractScreen()
		{
			super();
			
			this.visible = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		public function destroy():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Show the screen
		 */
		public function show():void
		{
			this.visible = true;
			this.showCompleted();
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Allow for code execution after show has completed
		 */
		public function showCompleted():void
		{
			this.showCompletedSignal.dispatch();
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Hide the screen
		 */
		public function hide():void
		{
			this.visible = false;
			this.hideCompleted();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Allow for code execution after hide has completed
		 */
		public function hideCompleted():void
		{
			this.hideCompletedSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Starts operation of the screen.
		 */
		public function begin():void
		{
			this.beginCompleted();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Allow for code execution after begin has completed
		 */
		public function beginCompleted():void
		{
			this.beginCompletedSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends operation of the screen.
		 */
		public function end():void
		{
			this.endCompleted();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Allow for code execution after end has completed
		 */
		public function endCompleted():void
		{
			this.endCompletedSignal.dispatch();
		}
	}
}

