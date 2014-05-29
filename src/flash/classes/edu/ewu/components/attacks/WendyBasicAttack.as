package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class WendyBasicAttack extends RonaldMcDonaldBasicAttack
	{
	
		public function WendyBasicAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, $nForce, $nDamage,  $bNetwork);
		}
		
	}

}