package edu.ewu.components.attacks 
{
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
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
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage,"edu.ewu.components.attacks.BurgerKingChargedAttack", $bNetwork); //maybe change attack sound to Yell?
			TweenMax.to(this, 1, { x:$nX + 300 * Math.cos(this.angle/180*Math.PI), y:$nY + 300 * Math.sin(this.angle/180*Math.PI) ,ease:Quad.easeIn } );
			TweenMax.to($oCreator, 1, { x:$nX + 300 * Math.cos(this.angle / 180 * Math.PI), y:$nY + 300 * Math.sin(this.angle / 180 * Math.PI), ease:Quad.easeIn, onComplete:$oCreator.chargedAttackComplete } );
		}
	}
}