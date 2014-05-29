package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class WendyChargedAttack extends Attack
	{
		 
		public function WendyChargedAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 500, "edu.ewu.components.attacks.WendyChargedAttack", "whip",  $bNetwork);
		}
	}

}