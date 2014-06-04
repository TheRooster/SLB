package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class PapaJohnBasicAttack extends Attack
	{

		public function PapaJohnBasicAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 500, "edu.ewu.components.attacks.papaJohnBasicAttack", "Cut", $bNetwork);
		}
		
	}

}