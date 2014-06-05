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
		
		public var attacks:Array;

		public function ColonelSandersChargedAttack($oCreator:Player, $nX:uint, $nY:uint, $nAngle:uint, $nForce:uint=1, $nDamage:uint=1, $bNetwork:Boolean = false) 
		{
			for (var i:uint = 0; i < uint(Math.random() * 5); i ++)
			{
				var x:int = (Math.random() * 200) - 100;
				var y:int = (Math.random() * 200) - 100;
				attacks[i] = new ColonelSandersChargedSubAttack($oCreator, $nX + x, $nY + y, $nAngle, $nForce, $nDamage, $bNetwork);
			}
			
			
		}
	}

}