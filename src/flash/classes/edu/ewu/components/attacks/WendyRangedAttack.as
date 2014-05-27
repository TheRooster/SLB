package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class WendyRangedAttack extends RonaldMcDonaldRangedAttack
	{
		
		public function WendyRangedAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, $bNetwork);
		}
		
	}

}