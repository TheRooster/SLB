package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class PapaJohnChargedAttack extends Attack
	{

		public function PapaJohnChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, "edu.ewu.components.attacks.PapaJohnChargedAttack", $bNetwork);
		}
	}

}