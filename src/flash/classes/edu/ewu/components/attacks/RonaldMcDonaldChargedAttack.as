package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public dynamic class RonaldMcDonaldChargedAttack extends Attack
	{
		public function RonaldMcDonaldChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, "edu.ewu.components.attacks.RonaldMcDonaldChargedAttack", $bNetwork);
			TweenMax.to(this, .5, { scaleX:8, scaleY:8 } );
		}
	}
}