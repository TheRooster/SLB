package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	import edu.ewu.components.attacks.PapaJohnRangedSubAttack;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class PapaJohnRangedAttack
	{
		
		public var attackLeft:PapaJohnRangedSubAttack ;
		public var attackCenter:PapaJohnRangedSubAttack ;
		public var attackRight:PapaJohnRangedSubAttack ;

		public function PapaJohnRangedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			//this attack is special, we're not going to call super for it
			//super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, $bNetwork);
			attackLeft = new PapaJohnRangedSubAttack($oCreator, $nX, $nY, $nAngle-30 < 0?$nAngle+330:$nAngle-30, $nForce, $nDamage, $bNetwork);
			attackCenter = new PapaJohnRangedSubAttack($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, $bNetwork);
			attackLeft = new PapaJohnRangedSubAttack($oCreator, $nX, $nY, $nAngle+30 > 360? $nAngle-330:$nAngle+30, $nForce, $nDamage, $bNetwork);
			
			
		}
	}

}