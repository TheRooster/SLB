package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class RonaldKick extends Attack
	{
		
		public function RonaldKick($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, 100, 5, 500, "edu.ewu.components.attacks.RonaldKick", "Thump", $bNetwork);
		}
	}
}