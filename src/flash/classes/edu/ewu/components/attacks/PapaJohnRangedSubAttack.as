package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public dynamic class PapaJohnRangedSubAttack extends Attack 
	{
		
		public function PapaJohnRangedSubAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint, $nDamage:uint, $bNetwork:Boolean) 
		{
			//these ones we will call super on, because they're actually going to be created
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, "edu.ewu.components.attacks.PapaJohnRangedSubAttack", $bNetwork);
			
			TweenMax.to(this, this._nTime, { x:$nX + (300 * Math.cos(($nAngle / 180) * Math.PI)), y:$nY + (300 * Math.sin(($nAngle / 180) * Math.PI)) } );
		}
		
	}

}