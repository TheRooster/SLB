package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class RonaldMcDonaldBasicAttack extends Attack
	{
		public function RonaldMcDonaldBasicAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, 2 * $nForce, 10 * $nDamage, 500, "edu.ewu.components.attacks.RonaldMcDonaldBasicAttack", "Thump", $bNetwork);
		}		
	}
}