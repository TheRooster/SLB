package edu.ewu.components.attacks 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	
	/**
	 * ...
	 * @author Jon Roster
	 */
	public dynamic class ColonelSandersRangedAttack extends Attack 
	{
		
		public function ColonelSandersRangedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint, $nDamage:uint, $bNetwork:Boolean=false) 
		{
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 500, "edu.ewu.components.attacks.ColonelSandersRangedAttack", "Thump", $bNetwork);
			TweenMax.to(this, .5, { scaleX:40} );
			
		}
		
	}

}