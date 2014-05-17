package edu.ewu.components.attacks  
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import edu.ewu.components.Collideable;
	import edu.ewu.components.CollisionManager;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.SoundManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.natejc.utils.StageRef;
	
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
		/** Name of the sound to play on hit. */
		public var		sHitSound	:String;
		
		public var 		damage		:Number;
		public var 		force		:Number;
		public var		angle		:Number;
		protected var 	_timer  	:Timer;
		
		public var		sAttackName	:String;
		
		//$nTime is the time the attack will last in milliseconds.
		public function Attack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $bNetwork:Boolean = false, $nForce:uint = 200, $nDamage:uint = 0, $nTime:uint = 500) 
		{
			//TODO: Change for specific attacks later
			
		}
		
		public function destroy($e:TimerEvent = null)
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			
			this.stage.removeChild(this);
			CollisionManager.instance.remove(this);
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Apply attack to player
		 *
		 * @param	$oPlayer	Player attack is applying to.
		 */
		public function apply($oPlayer:LocalPlayer):void
		{
			//TODO: Handling health affecting force
			
		}
	}

}