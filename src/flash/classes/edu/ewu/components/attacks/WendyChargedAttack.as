package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class WendyChargedAttack extends Attack
	{
		 
		public function WendyChargedAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $bNetwork:Boolean = false) 
		{
			TweenMax.delayedCall(5, super($sCreator, $nX, $nY, $nAngle, $bNetwork));
		}
	}

}