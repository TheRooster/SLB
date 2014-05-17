package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BKThrust extends Attack
	{
		
		public function BKThrust($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $bNetwork:Boolean = false, $nForce:uint = 200, $nDamage:uint = 0, $nTime:uint = 500) 
		{
			this.sHitSound = "Thump";
			this.sCreator = $sCreator; 
			this.x = $nX;
			this.y = $nY;
			this.damage = $nDamage;
			this.force = $nForce;
			this.angle = $nAngle;
			this.rotation = $nAngle;
			this._bNetwork = $bNetwork;
			this.sAttackName = "edu.ewu.components.attacks.Attack";
			
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
		
		override public function apply($oPlayer:LocalPlayer):void
		{
			//TODO: Handling health affecting force
			if (this.sCreator != $oPlayer.PlayerName)
			{
				SoundManager.instance.playSound(this.sHitSound);
				TweenMax.killTweensOf($oPlayer);
				TweenMax.to($oPlayer, 0.5, { x:$oPlayer.x + this.force * Math.cos(this.angle), y:$oPlayer.y + this.force * Math.sin(this.angle) , ease: Linear.easeNone } );
				this.destroy();
			}
		}
	}

}