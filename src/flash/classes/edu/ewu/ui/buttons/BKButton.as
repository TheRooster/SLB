package edu.ewu.ui.buttons 
{
	
	import edu.ewu.ui.buttons.SoundButton;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BKButton extends SoundButton
	{
		
		public function BKButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null) 
		{
			super(upState, overState, downState, hitTestState);
		}
		
	}

}