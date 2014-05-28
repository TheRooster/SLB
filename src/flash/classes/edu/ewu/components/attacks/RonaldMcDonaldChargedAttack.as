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
			TweenMax.delayedCall(5, super($sCreator, $nX, $nY, $nAngle, $bNetwork));
		}
		
	}

}