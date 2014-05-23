package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingBasicAttack extends RonaldMcDonaldBasicAttack
	{
		public function BurgerKingBasicAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, $bNetwork);
		}
	}

}