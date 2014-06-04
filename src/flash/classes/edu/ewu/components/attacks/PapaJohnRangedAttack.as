package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class PapaJohnRangedAttack
	{

		public function PapaJohnRangedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			//this attack is special, we're not going to call super for it
			//super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, $bNetwork);
			
			var attackLeft = new PapaJohnRangedSubAttack($oCreator, $nX, $nY, $nAngle-30, $nForce, $nDamage, $bNetwork);
			var attackCenter = new PapaJohnRangedSubAttack($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, $bNetwork);
			var attackLeft = new PapaJohnRangedSubAttack($oCreator, $nX, $nY, $nAngle+30, $nForce, $nDamage, $bNetwork);
			
			
		}
	}

}