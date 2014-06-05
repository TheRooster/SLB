package edu.ewu.components.attacks 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.player.Player;
	import edu.ewu.sounds.SoundManager;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public dynamic class ColonelSandersChargedSubAttack extends Attack 
	{
		
		private var _bDoneTweening:Boolean = false;
		
		public function ColonelSandersChargedSubAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean=false) 
		{
			//these ones we will call super on, because they're actually going to be created
			super($oCreator, $nX, $nY, $nAngle, $nForce, $nDamage, 1000, "edu.ewu.components.attacks.ColonelSandersChargedSubAttack", "Explosion", $bNetwork);
			TweenMax.to(this, .3, { scaleX:.3, scaleY:.3, onComplete:function() { this._bDoneTweening = true; }} );
		}
		
	
	
		
	}
}