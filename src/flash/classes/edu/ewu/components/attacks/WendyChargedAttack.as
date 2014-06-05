package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class WendyChargedAttack extends Attack
	{
		public function WendyChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, -1*$nForce, $nDamage, "edu.ewu.components.attacks.WendyChargedAttack", $bNetwork);
		}
	}
}