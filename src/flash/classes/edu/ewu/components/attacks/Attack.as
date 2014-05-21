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

		public function Attack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint, $nDamage:uint, $nTime:uint, $sAttackName:String, $sHitSound:String, $bNetwork:Boolean = false) 

		{

			//Changed so everything is passed to super.

			//On each attack creation they pass their values up instead of setting them all in their own attack.

			this.sCreator = $sCreator; 

			this.x = $nX;

			this.y = $nY;

			this.angle = $nAngle;

			this.rotation = $nAngle;

			this._bNetwork = $bNetwork;

			

			this.force = $nForce;

			this.damage = $nDamage;

			this.sHitSound = $sHitSound;

			this.sAttackName = $sAttackName;

			

			this.sCollisionType = CollisionManager.TYPE_ATTACK;

			CollisionManager.instance.add(this);

			

			_timer = new Timer($nTime, 1);

			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, destroy);

			_timer.start();

			

			StageRef.stage.addChild(this);

			

			if (this._bNetwork == false)

			{

				NetworkManager.instance.sendData(NetworkManager.OPCODE_ATTACK, this);

			}

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

			if (this.sCreator != $oPlayer.PlayerName)

			{

				$oPlayer.sLastHitBy = this.sCreator;
				SoundManager.instance.playSound(this.sHitSound);

				TweenMax.killTweensOf($oPlayer);

				TweenMax.to($oPlayer, 0.5, { x:$oPlayer.x + this.force * Math.cos(this.angle), y:$oPlayer.y + this.force * Math.sin(this.angle) , ease: Linear.easeNone } );

				this.destroy();

			}

		}

	}
}