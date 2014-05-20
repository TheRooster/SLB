package edu.ewu.components 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Justin Breitenbach
	 */
	public class Collideable extends MovieClip
	{
		/** Movie clip used to hit this object */
		public var		mcHitTest				:Sprite;
		/** Type used for collisions in CollisionManager */
		public var		sCollisionType			:String;
		/** Array of other collision types that this object collides with. */
		protected var	_aCollidesWithTypes		:Array = new Array();
		
		public function Collideable() 
		{
			super();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns object to use for hit testing.
		 *
		 * @return			Sprite to be used with in hit tests.
		 */
		public function get collisionTestObject():Sprite
		{
			return this.mcHitTest ? this.mcHitTest : this;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Adds an entry to the _aCollidesWithTypes array if it isn't already a member
		 *
		 * @param	$type	Type that CollisionManager uses for collisions.
		 */
		public function addCollidesWithType($type:String):void
		{
			if (_aCollidesWithTypes.indexOf($type) < 0)
			{
				_aCollidesWithTypes.push($type);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns _aCollidesWithTypes
		 * 
		 * @return			An array of types that is used in CollisionManager to determine collisions.
		 */
		public function get collidesWithTypes():Array
		{
			return _aCollidesWithTypes;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Logic to be run when a collision is detected.
		 *
		 * @param	$oObjectCollidedWith	The object which was collided with.
		 */
		public function collidedWith($oObjectCollidedWith:Collideable):void
		{
			
		}
	}

}