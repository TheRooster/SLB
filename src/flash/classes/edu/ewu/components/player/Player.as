package edu.ewu.components.player
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import edu.ewu.components.Collideable;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import edu.ewu.components.CollisionManager;
	
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class Player extends Collideable
	{
		protected var _sSprite:MovieClip;
		protected var _namePlate:TextField;
		protected var _charName:String;
		
		protected var _nXPos:uint;
		protected var _nYPos:uint;
		
		protected var _nSpeed:uint = 5;
		
		protected var _nWeight:uint;
		
		protected var _bAlive:Boolean;
		
		protected var _mcLightAttack:String;
		protected var _mcHeavyAttack:String;
		protected var _mcChargedAttack:String;
		
		public function Player($pName:String, $charName:String)
		{
			super();
			
			this._charName = $charName;
			if (LoaderMax.getContent(this._charName) == null)
			{
				//if the content isn't already loaded
				LoaderMax.activate([SWFLoader]);
				var loader:XMLLoader = new XMLLoader(this._charName, {onComplete: init});
			}
			else
			{
				init();
			}
			
			var fmt:TextFormat = new TextFormat("Courier New", 10, 0xFFFFFF);
			_namePlate = new TextField();
			_namePlate.defaultTextFormat = fmt;
			_namePlate.text = $pName.substr(0, 30); //max 30 character names
			_namePlate.x = this.width / 2 - _namePlate.textWidth * .5;
			_namePlate.y = -_namePlate.textHeight;
			_namePlate.selectable = false;
			
			this.addChild(_namePlate);
			
			this.sCollisionType = CollisionManager.TYPE_PLAYER;
			CollisionManager.instance.add(this);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function init():void
		{
			//init with xml
			
			var stats:XML = LoaderMax.getContent(this._charName);
			this._sSprite = LoaderMax.getContent(this._charName + "_Sprite").getSWFChild("character");
			
			this._sSprite.visible = true;
			this.addChild(this._sSprite);
		
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function get PlayerName()
		{
			return this._namePlate.text;
		}
		

	
	}

}