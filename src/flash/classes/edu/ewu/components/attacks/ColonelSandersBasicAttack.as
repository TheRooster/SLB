﻿package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class ColonelSandersBasicAttack extends Attack
	{
		public function ColonelSandersBasicAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			super($oCreator, $nX, $nY, $nAngle,  $nForce, $nDamage,"edu.ewu.components.attacks.ColonelSandersBasicAttack", $bNetwork);
		}		
	}
}