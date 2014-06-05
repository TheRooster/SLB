package edu.ewu.components.attacks  
{
	import com.greensock.easing.Linear;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TweenMax;
	import com.natejc.utils.StageRef;
	import edu.ewu.components.Collideable;
	import edu.ewu.components.CollisionManager;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.player.Player;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.SoundManager;
	import edu.ewu.ui.screens.ScreenManager;
	import flash.display.Loader;
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
		
		public var 		damage		:Number =1;
		public var 		force		:Number=1;
		public var		angle		:Number;
		public var 		_timer  	:Timer;
		public var		sAttackName	:String;
		public var		_nTime		:Number;

		//$nTime is the time the attack will last in milliseconds.
		public function Attack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint, 
							   $nDamage:uint, $sAttackName:String, $bNetwork:Boolean = false)
		{
			//On each attack creation they pass their values up instead of setting them
			//all in their own attack.
			var loader:XMLLoader = new XMLLoader("resources/xml/attacks/" + $sAttackName.substring($sAttackName.lastIndexOf('.')+1, $sAttackName.length) + ".xml", { name:$sAttackName, onComplete:init  } );
			loader.load();
			
			
			this.sCreator = $oCreator.PlayerName; 
			this.x = $nX;
			this.y = $nY;
			this.angle = $nAngle;
			
			if (this.angle > 360)
			{
				this.angle -= 360;
			}
			this.rotation = this.angle;
			this._bNetwork = $bNetwork;
			this.sAttackName = $sAttackName;
			
			
			
			
		}
		
		public function init($e:LoaderEvent)
		{
			var stats:XML = XMLLoader($e.target).content;
			this.force *= uint(stats.force);
			this.damage *= uint(stats.damage);
			this._nTime = Number(stats.time);
			this.sHitSound = stats.hitSound;
			
			
			StageRef.stage.addChild(this);
			
			this.sCollisionType = CollisionManager.TYPE_ATTACK;
			
			CollisionManager.instance.add(this);
			
			_timer = new Timer(this._nTime, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			_timer.start();
			
			
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
				$oPlayer.nHealth += this.damage; 
				$oPlayer.sLastHitBy = this.sCreator;
				SoundManager.instance.playSound(this.sHitSound);
				TweenMax.killTweensOf($oPlayer);
				
				//Convert this bitch to radians yo
				this.angle = (this.angle / 180) * Math.PI;
				var distance:Number = (this.force / $oPlayer.nWeight) * (($oPlayer.nHealth + 1) / 10);

				TweenMax.to($oPlayer, 0.5, { x:$oPlayer.x + (distance * Math.cos(this.angle)), y:$oPlayer.y + (distance * Math.sin(this.angle)) , ease: Linear.easeOut } );

				this.destroy();
			}
		}
	}
}