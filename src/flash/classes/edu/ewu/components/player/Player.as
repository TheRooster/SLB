package edu.ewu.components.player
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
<<<<<<< HEAD
	import flash.display.DisplayObject;
=======
	import edu.ewu.components.Collideable;
>>>>>>> 5941e9013b9e30c9869303147550fe452f54669f
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
<<<<<<< HEAD
		
		protected var _sSprite:ContentDisplay;
=======
		protected var _sSprite:MovieClip;
>>>>>>> 5941e9013b9e30c9869303147550fe452f54669f
		protected var _namePlate:TextField;
		public var _charName:String;
		
		
		protected var _nSpeed:uint = 5;
		
		protected var _nWeight:uint;
		
		protected var _bAlive:Boolean;
		
		protected var _mcLightAttack:String;
		protected var _mcHeavyAttack:String;
		protected var _mcChargedAttack:String;
		
		public function Player($pName:String, $charName:String)
		{
			super();
			this._bAlive = true;
			
			this._charName = $charName;
			
			LoaderMax.activate([SWFLoader]);
			var loader:XMLLoader = new XMLLoader("resources/xml/" + _charName + ".xml", { name:this._charName, onComplete:init  } );
			loader.load();
			
			
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
		
		protected function init(e:LoaderEvent):void
		{
			//init with xml
			var stats:XML = LoaderMax.getContent(this._charName );
			this._sSprite = ContentDisplay(LoaderMax.getContent(this._charName + "_Sprite"));
			this._sSprite.centerRegistration = true;
			this._sSprite.width = 60;
			this._sSprite.height = 40;
			this._sSprite.scaleMode = "proportionalInside";
			this._sSprite.y += 20;
			
			
			
			//this._sSprite.visible = true;
			this.addChild(this._sSprite);
		
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function get PlayerName()
		{
			return this._namePlate.text;
		}
		

	
	}

}