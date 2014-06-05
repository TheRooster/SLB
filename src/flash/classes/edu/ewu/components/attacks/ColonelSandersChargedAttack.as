package edu.ewu.components.attacks 
{
	import edu.ewu.components.player.Player;
	import edu.ewu.components.attacks.ColonelSandersChargedSubAttack;
	/**
	 * ...
	 * @author Lindsey
	 */
	public class ColonelSandersChargedAttack
	{
		
		public var attacks:Array = new Array();

		public function ColonelSandersChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			for (var i:uint = 0; i < uint(Math.random() * 100); i ++)
			{
				var x:int = (Math.random() * 400) - 200;
				var y:int = (Math.random() * 400) - 200;
				attacks[i] = new ColonelSandersChargedSubAttack($oCreator, $nX + x, $nY + y, $nAngle, $nForce, $nDamage, $bNetwork);
			}
			
			
		}
	}

}