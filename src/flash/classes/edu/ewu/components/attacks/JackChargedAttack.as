package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class JackChargedAttack extends Attack
	{

		public function JackChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=0, $nDamage:uint=0, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 500, "edu.ewu.components.attacks.JackChargedAttack", "Thump",  $bNetwork);
		}
		
	}

}