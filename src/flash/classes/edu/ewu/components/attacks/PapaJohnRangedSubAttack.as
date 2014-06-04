package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class PapaJohnRangedSubAttack extends Attack 
	{
		
		public function PapaJohnRangedSubAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint, $nDamage:uint, $bNetwork:Boolean) 
		{
			//these ones we will call super on, because they're actually going to be created
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 1000, "edu.ewu.components.attacks.PapaJohnRangedSubAttack", "Thump", $bNetwork);
			TweenMax.to(this, 1000, { x:100 * $nX * Math.sin(($nAngle / 180) * Math.PI), y:100 * $nY * Math.sin(($nAngle / 180) * Math.PI) } );
		}
		
	}

}