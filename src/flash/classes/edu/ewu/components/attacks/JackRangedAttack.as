package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public dynamic class JackRangedAttack extends Attack
	{

		public function JackRangedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage,"edu.ewu.components.attacks.JackRangedAttack", $bNetwork);
			TweenMax.to(this, this._nTime, { x:$nX + 250 * Math.cos(this.angle/180*Math.PI), y:$nY + 250 * Math.sin(this.angle/180*Math.PI) } );
		}
		

	}
}