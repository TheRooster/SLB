package edu.ewu.components 
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TweenMax;
	import com.natejc.utils.StageRef;
	import edu.ewu.components.player.LocalPlayer;
	import edu.ewu.components.player.NetworkPlayer;
	import edu.ewu.components.player.Player;
	import edu.ewu.networking.NetworkManager;
	import flash.display.Sprite;
	import edu.ewu.networking.NetworkManager;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class Collectable extends Collideable 
	{
		private var _sType:String;
		
		public function get type():String
		{
			return _sType;
		}
		
		private var _sAttribute:String;
		
		private var _nAmount:Number;
		
		private var _iDuration:uint;
		
		private var _nOriginalValue:Number;
		
		private var _sSprite:Sprite;
		
		private var _oTweenMaxVars:TweenMaxVars;
		
		/** Whether the collectable was created locally or not */
		protected var	_bNetwork	:Boolean;
		
		
		public function Collectable($sType:String, $bNetwork = false) 
		{
			super();
			this._sType = $sType;
			this.sCollisionType = CollisionManager.TYPE_COLLECTABLE;
			this.addCollidesWithType(CollisionManager.TYPE_PLAYER);
			this.addCollidesWithType(CollisionManager.TYPE_WALL);
			this.addCollidesWithType(CollisionManager.TYPE_PIT);
			
			//load xml here
			var loader:XMLLoader = new XMLLoader("resources/xml/" + _sType + ".xml", { name:_sType, onComplete:init  } );
			var imgLoader:ImageLoader = new ImageLoader("resources/images/" + _sType + ".png", { name:_sType + "_sprite", onComplete:initSprite } );
			loader.load();
			imgLoader.load();
			
			this._bNetwork = $bNetwork;
			
			if (this._bNetwork == false)
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
			this._oTweenMaxVars = new TweenMaxVars(objectFromXML(XML(stats.vars)));
			
			
		}
		
		
		function objectFromXML(xml:XML):Object
		{
			var obj:Object = {  };

           // Check if xml has no child nodes:
			if (xml.hasSimpleContent()) 
			{
				return String(xml);     // Return its value
			}

			// Parse out attributes:
			for each (var attr:XML in xml.@ * )
			{
				obj[String(attr.name())] = attr;
			}

			// Parse out nodes:
			for each (var node:XML in xml.*) 
			{
				obj[String(node.localName())] = objectFromXML(node);
			}

			return obj;
		}
		
		
		
		
		
		public function initSprite(e:LoaderEvent)
		{
			this._sSprite = ImageLoader(e.target).content;
			this._sSprite.visible = false;
			this._sSprite.scaleX = .25;
			this._sSprite.scaleY = .25;
			
			
			this.addCollidesWithType(CollisionManager.TYPE_COLLECTABLE);
			this.addCollidesWithType(CollisionManager.TYPE_PIT);
			this.addCollidesWithType(CollisionManager.TYPE_PLAYER);
			
			do
			{
				this._sSprite.x = Math.random() * StageRef.stage.stageWidth;
				this._sSprite.y = Math.random() * StageRef.stage.stageHeight;
			}while(CollisionManager.instance.doesObjectCollide(this));
			
			this._sSprite.visible = true;
			this.addChild(_sSprite);
			CollisionManager.instance.add(this);
			
		}
		
		
		
		override public function collidedWith($oObjectCollidedWith:Collideable):void
		{
			if ($oObjectCollidedWith is LocalPlayer)
			{
				CollisionManager.instance.remove(this);
				stage.removeChild(this);
				
				this._nOriginalValue = Player($oObjectCollidedWith)[_sAttribute];
				Player($oObjectCollidedWith)[_sAttribute] *= _nAmount;
				TweenMax.to($oObjectCollidedWith, .01, this._oTweenMaxVars);
				TweenMax.delayedCall(this._iDuration, onComplete, [$oObjectCollidedWith]);
			}
			else if ($oObjectCollidedWith is NetworkPlayer)
			{
				CollisionManager.instance.remove(this);
				stage.removeChild(this);
			}
		}
		
		public function onComplete($oObjectCollidedWith:Player)
		{
			$oObjectCollidedWith[_sAttribute] = _nOriginalValue;
		}
		
		override public function  get collisionTestObject():Sprite
		{
			return this._sSprite;
		}
		
	}

}