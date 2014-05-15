package  
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class Attack extends MovieClip
	{
		protected var _damage :Number;
		protected var _force  :Number;
		protected var _timer  :Timer;
		
		public function Attack() 
		{
			//sets a new timer for 10 seconds
			_timer = new Timer(10000, 0);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			_timer.start();
		}
		
		public function destroy()
		{
			//remove from collision manager
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, destroy);
		}
	}

}