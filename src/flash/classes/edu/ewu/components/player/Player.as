package edu.ewu.components.player
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import flash.display.DisplayObject;
	import edu.ewu.components.Collideable;
	import flash.display.Loader;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import edu.ewu.components.CollisionManager;
	import edu.ewu.networking.NetworkManager;
	
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class Player extends Collideable
	{

		
		public var _sSprite:MovieClip;
		protected var _namePlate:TextField;
		public var _charName:String;
		public var _pName:String;
		
		
		
		
		
		
		
		
		public var nBaseDamage:Number;
		public var nBaseForce:Number;
		
		protected var _bAlive:Boolean;
		
		protected var _mcLightAttack:String;
		protected var _mcHeavyAttack:String;
		protected var _mcChargedAttack:String;
		
		protected var _nChargeDelay;
		public var nSpeed:uint = 5;
		public var nLives:uint;
		public var nHealth:uint;
		public var nWeight:uint;
		
		public var kills:uint;
		
		private var emitter:Emitter2D;
		
		protected var _bChargedAttackExecuting = false;
		
		
		public function Player($pName:String, $charName:String)
		{
			
			var renderer:BitmapRenderer = new BitmapRenderer( new Rectangle( 0, 0, 400, 400 ) );
			renderer.addFilter( new BlurFilter( 2, 2, 1 ) );
			renderer.addFilter( new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.95,0 ] ) );
			this.addChild( renderer );
      
			emitter = new Sparkler( renderer );
			renderer.addEmitter( emitter );
			
			super();
			this._bAlive = true;
			this.nLives = 3;
			
			
			this._charName = $charName;
			this._pName = $pName;

			var loader:XMLLoader = new XMLLoader("resources/xml/" + _charName + ".xml", { name:this._charName, onComplete:init  } );
			loader.load();
			
			var fmt:TextFormat = new TextFormat("Courier New", 10, 0xFFFFFF);
			_namePlate = new TextField();
			_namePlate.defaultTextFormat = fmt;
			_namePlate.text = $pName.substr(0, 30); //max 30 character names
			_namePlate.x = -(_namePlate.textWidth / 2);
			_namePlate.y = -_namePlate.textHeight - 40;
			_namePlate.selectable = false;
			
			this.addChild(_namePlate);
			
			this.sCollisionType = CollisionManager.TYPE_PLAYER;
			CollisionManager.instance.add(this);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		protected function init(e:LoaderEvent):void
		{
			//init with xml
			var stats:XML = XMLLoader(e.target).content;
			this.nWeight = uint(stats.stats.weight);
			this.nSpeed = uint(stats.stats.speed);
			this._nChargeDelay = Number(stats.stats.delay);
			
			var loader:SWFLoader = new SWFLoader("resources/swfs/" + this._charName + ".swf", { name:this._charName + "_Sprite", onComplete:function() { initSprite( MovieClip(MovieClip(loader.rawContent).getChildAt(0))); }} );
			loader.load();
			//SpriteManager.instance.load(this._charName, this);
			
			this.nLives = 3;
			this.nHealth = 0;
			this.kills = 0;
			this.nBaseDamage = 1;
			this.nBaseForce = 1;
		}
		
		
		public function initSprite($sprite:MovieClip)
		{
			this._sSprite = $sprite;
			this._sSprite.rotationZ = 90;
			
			this._sSprite.scaleX = .5;
			this._sSprite.scaleY = .5;
			
			this.addChild(this._sSprite);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function get PlayerName()
		{
			return this._namePlate.text;
		}
		
		
		
		public function chargedAttackComplete():void
		{
			this._bChargedAttackExecuting = false;
			this.gotoAndPlaySprite("Idle");
		}
		

		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Destroys player
		 */
		public function destroy():void
		{
			CollisionManager.instance.remove(this);
		}

		public function gotoAndPlaySprite($sAnimationName:String, $bNetworked:Boolean = false):void
		{
			if (this._sSprite != null)
			{
				this._sSprite.gotoAndPlay($sAnimationName);
				
				if ($sAnimationName == "Death")
				{
					TweenMax.to(this, 2, { scaleX:0, scaleY:0 } );
				}
				else
				{
					this.scaleX = 1;
					this.scaleY = 1;
				}
				
				if ($bNetworked == false)
				{
					NetworkManager.instance.sendData(NetworkManager.OPCODE_ANIM, { name:this.PlayerName, animName:$sAnimationName } );
				}
			}
		}
		
		//90 is because the sprite is by default facing 90 off of what flash considers 0 (Right)
		public function get SpriteRotation():Number
		{
			if (this._sSprite)
			{
				return this._sSprite.rotation - 90;
			}
			else
			{
				return 0;
			}
		}
	
		public function set SpriteRotation($nRotation:Number):void
		{
			if (this._sSprite)
			{
				this._sSprite.rotation = $nRotation + 90;
			}
		}
		
		public function get alive()
		{
			return this._bAlive;
		}
		
		public function set alive($bAlive:Boolean)
		{
			if (_bAlive != $bAlive)
			{
				_bAlive = $bAlive;
			}
		}
		
	}
}