package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingRangedAttack extends RonaldMcDonaldRangedAttack
	{
		public function BurgerKingRangedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, 50+$nForce, 20 + $nDamage, $bNetwork);
		}
	}

}