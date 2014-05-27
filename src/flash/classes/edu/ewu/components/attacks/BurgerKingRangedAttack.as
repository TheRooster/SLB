package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingRangedAttack extends RonaldMcDonaldRangedAttack
	{
		public function BurgerKingRangedAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, 50+$nForce, 20 + $nDamage, $bNetwork);
		}
	}

}