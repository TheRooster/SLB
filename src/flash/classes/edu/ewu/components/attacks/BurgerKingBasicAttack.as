package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingBasicAttack extends Attack 
	{
		public function BurgerKingBasicAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, 3*$nForce, 50*$nDamage, 500, "edu.ewu.components.attacks.BurgerKingBasicAttack", "Thump", $bNetwork);
		}
	}

}