package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingRangedAttack extends RonaldMcDonaldRangedAttack
	{
		public function BurgerKingRangedAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, $bNetwork);
		}
	}

}