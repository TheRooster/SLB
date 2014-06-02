package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class PapaJohnChargedAttack extends Attack
	{

		public function PapaJohnChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 500, "edu.ewu.components.attacks.WendyChargedAttack", "Thump",  $bNetwork);
		}
	}

}