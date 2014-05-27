package edu.ewu.components 
{
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import edu.ewu.components.player.Player;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class Collectable extends Collideable 
	{
		private var _sType:String;
		
		private var _sAttribute:String;
		
		private var _nAmount:Number;
		
		private var _iDuration:uint;
		
		private var _nOriginalValue:Number;
		
		private var _sSprite:Sprite;
		
		private var _oTweenMaxVars:Object;
		
		
		public function Collectable($sType:String) 
		{
			super();
			this._sType = $sType;
			this.sCollisionType = CollisionManager.TYPE_COLLECTABLE;
			this.addCollidesWithType(CollisionManager.TYPE_PLAYER);
			
			//load xml here
			var loader:XMLLoader = new XMLLoader("resources/xml/" + $sType + ".xml", { name:$sType, onComplete:init  } );
			var imgLoader:ImageLoader = new ImageLoader("resources/images/" + $sType + ".png", { name:$sType + "_sprite", onComplete:initSprite } );
			loader.load();
		}
		
		public function init()
		{
			var stats:XML = LoaderMax.getContent(this._sType);
			
			this._sAttribute = stats.affected;
			this._nAmount = Number(stats.amount);
			this._iDuration = Number(stats.duration);
			this._oTweenMaxVars = stats.vars;
			
			
		}
		
		
		public function initSprite()
		{
			this._sSprite = LoaderMax.getContent(this._sType + "_sprite");
			
			
			this.addChild(_sSprite);
			CollisionManager.instance.add(this);
			
		}
		
		
		
		override public function collidedWith($oObjectCollidedWith:Collideable):void
		{
			if ($oObjectCollidedWith is Player)
			{
				this._nOriginalValue = Player($oObjectCollidedWith)[_sAttribute];
				Player($oObjectCollidedWith)[_sAttribute] *= _nAmount;
				TweenMax.to($oObjectCollidedWith, .01, _oTweenMaxVars);
				TweenMax.delayedCall(this._iDuration, onComplete, [$oObjectCollidedWith]);
			}
		}
		
		public function onComplete($oObjectCollidedWith:Player)
		{
			$oObjectCollidedWith[_sAttribute] = _nOriginalValue;
		}
		
	}

}