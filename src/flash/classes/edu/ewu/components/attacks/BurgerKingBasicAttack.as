package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingBasicAttack extends RonaldMcDonaldBasicAttack
	{
		public function BurgerKingBasicAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, 250+$nForce, 5+$nDamage, $bNetwork);
		}
	}

}