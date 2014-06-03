package edu.ewu.components.collectables 
{
	import com.greensock.TweenMax;
	import edu.ewu.components.Collideable;
	import edu.ewu.components.CollisionManager;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.player.NetworkPlayer;
	import edu.ewu.components.player.Player;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.SoundManager;
	import edu.ewu.ui.screens.ScreenManager;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class Burger extends Collectable
	{
		public function Burger($gId:String="", $bNetwork=false)
		{
			_classPath = "edu.ewu.components.collectables.Burger";
			super($gId,"Burger", $bNetwork);
		}
		
	
		override public function collidedWith($oObjectCollidedWith:Collideable):void
		{
			if ($oObjectCollidedWith is LocalPlayer)
			{
				CollisionManager.instance.remove(this);
				this.parent.removeChild(this);
					
				this._nOriginalValue = Player($oObjectCollidedWith)[_sAttribute];
				Player($oObjectCollidedWith)[_sAttribute] *= _nAmount;
				TweenMax.to($oObjectCollidedWith, .1, {glowFilter:{color:0x663300, alpha:1, blurX:30, blurY:30, repeat:-1, yoyo:true}});
				SoundManager.instance.playSound(this._sSound, true);
					
				TweenMax.delayedCall(this._iDuration, onComplete, [$oObjectCollidedWith]);
				NetworkManager.instance.removeCollectable(this);
			}
			else if ($oObjectCollidedWith is NetworkPlayer )
			{
				TweenMax.to($oObjectCollidedWith, .01, {glowFilter:{color:0x663300, alpha:1, blurX:30, blurY:30, repeat:-1}});
				CollisionManager.instance.remove(this);
				ScreenManager.instance.mcActiveScreen.removeChild(this);
				NetworkManager.instance.removeCollectable(this);
			}
		}
	}
}