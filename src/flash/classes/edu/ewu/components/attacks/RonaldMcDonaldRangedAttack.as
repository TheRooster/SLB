package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class RonaldMcDonaldRangedAttack extends Attack
	{
		public function RonaldMcDonaldRangedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage,  "edu.ewu.components.attacks.RonaldMcDonaldRangedAttack", $bNetwork);
		}
	}
}