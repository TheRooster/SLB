package edu.ewu.ui.screens
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	
	/**
	 * Provide base functionality for screens
	 * 
	 * @author Justin Breitenbach
	 */
	public class FadeScreen extends AbstractScreen
	{
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the FadeScreen object.
		 */
		public function FadeScreen()
		{
			super();
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		override public function destroy():void
		{
			TweenMax.killTweensOf(this);
			super.destroy();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Show the screen
		 */
		override public function show():void
		{
			this.alpha = 0;
			this.visible = true;
			TweenMax.to(this, 1.0, { alpha: 1, ease: Linear.easeNone, onComplete: super.show });
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Hide the screen
		 */
		override public function hide():void
		{
			TweenMax.to(this, 1.0, { alpha: 0, ease: Linear.easeNone, onComplete: super.hide });
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Allow for code execution after hide is completed
		 */
		override public function hideCompleted():void
		{
			this.visible = false;
			super.hideCompleted()
		}
		
	}
}

