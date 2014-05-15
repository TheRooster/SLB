package edu.ewu.components.attacks  
{
	import edu.ewu.components.Collideable;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import edu.ewu.components.CollisionManager;
	import edu.ewu.networking.NetworkManager;
	
	/**
	 * ...
	 * @author Lindsey
	 */
	public class Attack extends Collideable
	{
		/** Player that created the attack */
		public var 		sCreator	:String;
		/** Whether the attack was created locally or not */
		protected var	_bNetwork	:Boolean;
		
		public var 		damage		:Number;
		public var 		force		:Number;
		public var		angle		:Number;
		protected var 	_timer  	:Timer;
		
		//$nTime is the time the attack will last in milliseconds.
		public function Attack($sCreator:String,$nX:uint, $nY:uint, $nAngle:uint, $nForce:uint = 100, $nDamage:uint = 0, $nTime:uint = 1000, $bNetwork:Boolean = false) 
		{
			this.sCreator = $sCreator; 
			this.x = $nX;
			this.y = $nY;
			this.damage = $nDamage;
			this.force = $nForce;
			this.angle = $nAngle;
			this._bNetwork = $bNetwork;
			
			this.sCollisionType = CollisionManager.TYPE_ATTACK;
			
			CollisionManager.instance.add(this);
			
			_timer = new Timer($nTime, 0);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			_timer.start();
			
			if (this._bNetwork == false)
			{
				NetworkManager.instance.sendData(NetworkManager.OPCODE_ATTACK, this);
			}
		}
		
		public function destroy()
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			
			CollisionManager.instance.remove(this);
		}
	}

}