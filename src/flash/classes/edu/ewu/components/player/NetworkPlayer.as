package edu.ewu.components.player 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.TweenMax;
	import edu.ewu.networking.NetworkManager;
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
		
		
		override protected function init(e:LoaderEvent):void
		{
			super.init(e);
			
						//fade enemies to random color
			var myColor:uint =  int(Math.random() * 0xFFFFFF);
			TweenMax.to(this._sSprite, 1, { colorTransform: { tint:myColor, tintAmount:1 }} );
			
		}
		
		
		
		
	}

}