package edu.ewu.components.attacks 
{
	/**
	 * ...
	 * @author Lindsey
	 */
	public class PapaJohnRangedAttack extends Attack
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