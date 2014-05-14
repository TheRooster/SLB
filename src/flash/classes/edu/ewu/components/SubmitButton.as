package edu.ewu.components 
{
	import edu.ewu.ui.buttons.SoundButton;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class SubmitButton extends SoundButton 
	{
		
		public function SubmitButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null) 
		{
			super(upState, overState, downState, hitTestState);
		}
		
	}

}