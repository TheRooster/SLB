package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public dynamic class JackChargedAttack extends Attack
	{

		public function JackChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, "edu.ewu.components.attacks.JackChargedAttack", $bNetwork);
			TweenMax.to(this, .5, { x:$nX + 200 * Math.cos(this.angle / 180 * Math.PI), y:$nY + 200 * Math.sin(this.angle / 180 * Math.PI), rotation:360, onComplete:tweenBack } );
		}
		
		private function tweenBack():void 
		{
			this.angle = this.angle > 180? this.angle - 180 : this.angle + 180;
			TweenMax.to(this, .5, { x:this.x + 200 * Math.cos(this.angle / 180 * Math.PI), y:this.y + 200 * Math.sin(this.angle / 180 * Math.PI), rotation:360} );
		}
		
	}

}