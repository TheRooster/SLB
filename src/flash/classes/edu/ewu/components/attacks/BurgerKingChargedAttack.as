package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class BurgerKingChargedAttack extends Attack
	{
		public function BurgerKingChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 3000, "edu.ewu.components.attacks.BurgerKingChargedAttack", "Thump", $bNetwork); //maybe change attack sound to Yell?
			TweenMax.to(this, 3000, { x:$nX + 600 * Math.cos(this.angle), y:$nY + 300 * Math.sin(this.angle) } );
			TweenMax.to($oCreator, 3000, { x:$nX + 600 * Math.cos(this.angle), y:$nY + 300 * Math.sin(this.angle) } );
		}
	}
}