package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class RonaldMcDonaldRangedAttack extends Attack
	{
		
		public function RonaldMcDonaldRangedAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, 100 + $nForce, 5 + $nDamage, 500, "edu.ewu.components.attacks.RonaldMcDonaldRangedAttack", "Thump", $bNetwork);
		}
	}
}