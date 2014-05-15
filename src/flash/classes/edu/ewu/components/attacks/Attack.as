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
		
		//$nTime is the time the attack will last in milliseconds.
		public function Attack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint = 100, $nDamage:uint = 0, $nTime:uint = 1000, $bNetwork:Boolean = false) 
		{
			//TODO: Change for specific attacks later
			this.sHitSound = "Thump";
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
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Apply attack to player
		 *
		 * @param	$oPlayer	Player attack is applying to.
		 */
		public function apply($oPlayer:LocalPlayer):void
		{
			if (this.sCreator != $oPlayer.PlayerName)
			{
				SoundManager.instance.playSound(this.sHitSound);
				var distanceX : Number = $oPlayer.x - this.x;
				var distanceY : Number = $oPlayer.y - this.y;
				var angleInRadians : Number = Math.atan2(distanceY, distanceX);
				var angleInDegrees : Number = angleInRadians * (180 / Math.PI);
				TweenMax.to($oPlayer, 1.0, { x:$oPlayer.x + this.force * Math.cos(angleInDegrees), y:$oPlayer.y + this.force * Math.sin(angleInDegrees) , ease: Linear.easeNone } );
				this.destroy();
			}
		}
	}

}