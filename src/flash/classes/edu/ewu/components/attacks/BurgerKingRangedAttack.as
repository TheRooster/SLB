package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingRangedAttack extends Attack
	{
		public function BurgerKingRangedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, 5*$nForce, 20 * $nDamage, 500, "edu.ewu.components.attacks.BurgerKingRangedAttack", "Thump", $bNetwork);
		}
	}
}