package edu.ewu.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class AppEvent extends Event 
	{
		
		public static const NAME_SUBMIT = "AppEvent.Name.Submit";
		public var data:*;
		
		public function AppEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, inData:* = null) 
		{
			super(type, bubbles, cancelable);
			this.data = inData;
		}
		
	}

}