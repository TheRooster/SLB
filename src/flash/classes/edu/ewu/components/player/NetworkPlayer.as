package edu.ewu.components.player 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.TweenMax;
	import edu.ewu.networking.NetworkManager;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class NetworkPlayer extends Player 
	{
		
		public function NetworkPlayer($pName:String, $charName:String) 
		{
			super($pName, $charName);
			
			
		}
		
		

		override public function initSprite($sprite:MovieClip)
		{
			super.initSprite($sprite);
			var myColor:uint =  int(Math.random() * 0xFFFFFF);
			TweenMax.to(this._sSprite, 1, { colorTransform: { tint:myColor, tintAmount:.7 }} );
		}
		
		
		
		
	}

}