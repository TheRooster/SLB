package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class RonaldMcDonaldChargedAttack extends Attack
	{
		public function RonaldMcDonaldChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, 10*$nForce, $nDamage, 1000, "edu.ewu.components.attacks.RonaldMcDonaldChargedAttack", "Explosion",  $bNetwork);
			TweenMax.to(this, .5, { scaleX:2, scaleY:2 } );
		}
	}
}