package edu.ewu.components.attacks  
{
	import edu.ewu.components.Collideable;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import edu.ewu.components.CollisionManager;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class Attack extends Collideable
	{
		/** Player that created the attack */
		public var 		sCreator	:String;
		
		public var 		damage		:Number;
		public var 		force		:Number;
		public var		angle		:Number;
		protected var 	_timer  	:Timer;
		
		//$nTime is the time the attack will last in milliseconds.
		public function Attack($sCreator:String, $nAngle:uint, $nForce:uint, $nDamage:uint, $nTime:uint = 10000) 
		{
			this.sCreator = $sCreator; 
			this.damage = $nDamage;
			this.force = $nForce;
			this.angle = $nAngle;
			
			this.sCollisionType = CollisionManager.TYPE_ATTACK;
			
			CollisionManager.instance.add(this);
			
			_timer = new Timer($nTime, 0);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			_timer.start();
		}
		
		public function destroy()
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			
			CollisionManager.instance.remove(this);
		}
	}

}