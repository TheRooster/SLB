package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingChargedAttack extends Attack
	{
		
		public function BurgerKingChargedAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 1000, "edu.ewu.components.attacks.BurgerKingChargedAttack", "Thump", $bNetwork); //maybe change attack sound to Yell?
		}
		
	}

}