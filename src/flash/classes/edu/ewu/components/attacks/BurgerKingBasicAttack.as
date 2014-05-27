package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingBasicAttack extends RonaldMcDonaldBasicAttack
	{
		public function BurgerKingBasicAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, 250+$nForce, 5+$nDamage, $bNetwork);
		}
	}

}