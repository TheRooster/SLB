package edu.ewu.components.collectables 
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TweenMax;
	import com.natejc.utils.StageRef;
	import edu.ewu.components.Collideable;
	import edu.ewu.components.CollisionManager;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.player.NetworkPlayer;
	import edu.ewu.components.player.Player;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.sounds.SoundManager;
	import flash.display.Sprite;
	import edu.ewu.networking.NetworkManager;
	import edu.ewu.ui.screens.ScreenManager;
	import edu.ewu.datastructures.Guid;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class Collectable extends Collideable 
	{
		private var _gId:String;
		
		public function get id():String
		{
			return _gId;
		}
		
		private var _sType:String;
		
		public function get type():String
		{
			return _sType;
		}
		
		protected var _classPath:String
		
		public function get classPath():String
		{
			return _classPath;
		}
		
		protected var _sAttribute:String;
		
		protected var _nAmount:Number;
		
		protected var _iDuration:uint;
		
		protected var _nOriginalValue:Number;
		
		protected var _sSprite:Sprite;
		
		protected var _sSound:String;
		
		/** Whether the collectable was created locally or not */
		protected var	_bNetwork	:Boolean;
		
		
		public function Collectable($gId, $sType:String, $bNetwork = false) 
		{
			super();
			
			if ($gId == "")
			{
				_gId = Guid.newGuid();
			}
			else
			{
				_gId = $gId;
			}
			
			this._sType = $sType;
			this.sCollisionType = CollisionManager.TYPE_COLLECTABLE;
			this.addCollidesWithType(CollisionManager.TYPE_PLAYER);
			this.addCollidesWithType(CollisionManager.TYPE_WALL);
			this.addCollidesWithType(CollisionManager.TYPE_PIT);
			this.addCollidesWithType(CollisionManager.TYPE_COLLECTABLE);
			
			//load xml here
			var loader:XMLLoader = new XMLLoader("resources/xml/" + _sType + ".xml", { name:_sType, onComplete:init  } );
			var imgLoader:ImageLoader = new ImageLoader("resources/images/" + _sType + ".png", { name:_sType + "_sprite", onComplete:initSprite } );
			loader.load();
			imgLoader.load();
			
			this._bNetwork = $bNetwork;

		}
		
		
		public function begin():void
		{
			if (_bNetwork == false)
			{
				NetworkManager.instance.sendData(NetworkManager.OPCODE_COLLECTABLE, this);
			}
		}
		
		
		public function init(e:LoaderEvent)
		{
			var stats:XML = XMLLoader(e.target).content;
			
			this._sAttribute = stats.affected;
			this._nAmount = Number(stats.amount);
			this._iDuration = Number(stats.duration);
			this._sSound = stats.sound;
		}
		
		public function initSprite(e:LoaderEvent)
		{
			this._sSprite = ImageLoader(e.target).content;
			this._sSprite.scaleX = .25;
			this._sSprite.scaleY = .25;
			this.visible = false;
			this.addChild(_sSprite);
			
			if (_bNetwork == false)
			{
				do
				{
					this.x = Math.random() * StageRef.stage.stageWidth;
					this.y = Math.random() * StageRef.stage.stageHeight;
				}while(CollisionManager.instance.doesObjectCollide(this));
				
				trace("X: " + this.x.toString());
				trace("Y: " + this.y.toString());
			}
			this.visible = true;
			CollisionManager.instance.add(this);
			this.begin();
			
		}
		
		

		
		
		public function onComplete($oObjectCollidedWith:Player)
		{
			$oObjectCollidedWith[_sAttribute] = _nOriginalValue;
			TweenMax.killTweensOf($oObjectCollidedWith, false, { glowFilter:true });
		}
		
		override public function  get collisionTestObject():Sprite
		{
			return this._sSprite;
		}
		
	}

}