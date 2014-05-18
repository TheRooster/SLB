package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BKBasicAttack extends RonaldBasicAttack
	{
		public function BKBasicAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, $bNetwork);
		}
	}

}