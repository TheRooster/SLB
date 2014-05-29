package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class RonaldMcDonaldChargedAttack extends Attack
	{
		
		public function RonaldMcDonaldChargedAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 1000, "edu.ewu.components.attacks.RonaldMcDonaldChargedAttack", "Explosion",  $bNetwork);
		}
		
	}

}