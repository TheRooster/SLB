package edu.ewu.ui.buttons
{
	import edu.ewu.sounds.SoundManager;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	import flash.display.DisplayObject;
	
	/**
	 * Extens SimpleButton to add the ability to play sounds on click
	 * 
	 * @author Justin Breitenbach
	 */
	public class SoundButton extends SimpleButton
	{
		/** Signal that is dispatched after the button is clicked. */
		public var		clickedSignal		:Signal = new Signal();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the SoundButton object.
		 */
		public function SoundButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			this.addEventListener(MouseEvent.CLICK, this.clickHandler);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Handle mouse click on button.
		 * 
		 * @param	$e		The dispatched MouseEvent.CLICK event.
		 */
		protected function clickHandler($e:MouseEvent):void
		{
			SoundManager.instance.playSound("ButtonClick", true);
			this.clickedSignal.dispatch();
		}
	}
}

