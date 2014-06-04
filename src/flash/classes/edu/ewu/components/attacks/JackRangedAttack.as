package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class JackRangedAttack extends Attack
	{

		public function JackRangedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 500, "edu.ewu.components.attacks.JackRangedAttack", "Thump", $bNetwork);
		}
		
	}

}