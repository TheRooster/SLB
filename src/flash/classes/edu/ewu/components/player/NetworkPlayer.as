package edu.ewu.components.player 
{
	import com.greensock.TweenMax;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class NetworkPlayer extends Player 
	{
		
		public function NetworkPlayer($pName:String, $charName:String) 
		{
			super($pName, $charName);
			
			//fade enemies to random color
			var myColor:uint =  int(Math.random() * 0xFFFFFF);
			TweenMax.to(this._sSprite, 1, { colorTransform: { tint:myColor, tintAmount:1 }} );
			
			
			
		}
		
	}

}