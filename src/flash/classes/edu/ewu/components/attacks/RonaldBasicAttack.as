package edu.ewu.components.attacks 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.natejc.utils.StageRef;
	import edu.ewu.components.CollisionManager;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.SoundManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class RonaldBasicAttack extends Attack
	{
		public function RonaldBasicAttack($sCreator:String, $nX:uint, $nY:uint, $nAngle:uint, $bNetwork:Boolean = false) 
		{
			super($sCreator, $nX, $nY, $nAngle, 200, 10, 500, "edu.ewu.components.attacks.RonaldBasicAttack", "Thump", $bNetwork);
		}		
	}

}