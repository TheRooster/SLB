package edu.ewu.components
{
	import com.natejc.utils.StageRef;
	import flash.events.Event;
	
	/**
	 * Allow for easy managment of Collideable collisions.
	 * 
	 * @author Justin Breitenbach
	 */
	public class CollisionManager
	{
		/** String for Hero collision type. */
		public static const		TYPE_PLAYER						:String = "TypePlayer";
		/** String for Enemy collision type. */
		public static const		TYPE_ATTACK						:String = "TypeAttack";
		/** String for Hero collision type. */
		public static const		TYPE_COLLECTABLE				:String = "TypeCollectable";
		/** String for Hero collision type. */
		public static const		TYPE_WALL						:String = "TypeWall";
		
		/** Stores a reference to the singleton instance. */  
		private static const 	_instance						:CollisionManager 	= new CollisionManager(SingletonLock);
		/** Keeps track of objects in sub arrays based on type that ar being tracked */
		protected var			_aObjectsBeingTracked			:Array 				= new Array();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the CollisionManager object.
		 */
		public function CollisionManager($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("CollisionManager is a singleton and should not be instantiated. Use CollisionManager.instance instead");
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns instance of CollisionManager if it exists.
		 * 
		 * @return			Returns singleton instance of CollisionManager.
		 */
		public static function get instance():CollisionManager
		{
			return _instance;
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Begins testing collisions.
		 */
		public function begin():void
		{
			if (StageRef.stage)
			{
				StageRef.stage.addEventListener(Event.ENTER_FRAME, this.testAllCollisions);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends collision testing.
		 */
		public function end():void
		{
			if (StageRef.stage)
			{
				StageRef.stage.removeEventListener(Event.ENTER_FRAME, this.testAllCollisions);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Add Collideable to CollisionManager based upon its collision type.
		 *
		 * @param	$oGameObject	The Collideable to be added.
		 */
		public function add($oGameObject:Collideable):void
		{
			var aList:Array = this._aObjectsBeingTracked[$oGameObject.sCollisionType];
			aList ||= new Array();
			if (aList.indexOf($oGameObject) < 0)
			{
				aList.push($oGameObject);
			}
			this._aObjectsBeingTracked[$oGameObject.sCollisionType] = aList;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Remove Collideable from CollisionManager if it was found and return it.
		 *
		 * @param	$oGameObject	The Collideable to be removed.
		 * @return					Whether $oGameObject was removed.
		 */
		public function remove($oGameObject:Collideable):Boolean
		{
			var result:Boolean = false;
			var aList:Array = this._aObjectsBeingTracked[$oGameObject.sCollisionType];
			if (aList)
			{
				var index:uint = aList.indexOf($oGameObject);
				if (index >= 0)
				{
					result = true;
					aList.splice(index, 1);
				}
			}
			return result;
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Iterate through objects and test collisions.
		 * 
		 * @param	$e	The dispatched Event.ENTER_FRAME event.
		 */
		protected function testAllCollisions($e:Event = null ):void
		{
			var oObjectToTest:Collideable;
			var aCurrentObjects:Array;
			
			for (var sType:String in _aObjectsBeingTracked)
			{
				aCurrentObjects = _aObjectsBeingTracked[sType];
				for (var i:uint = 0; i < aCurrentObjects.length; i++)
				{
					this.testSingleObjectCollisions(aCurrentObjects[i]);
				}
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Test a single objects collisions with its collides with types.
		 */
		protected function testSingleObjectCollisions($oObjectToTest:Collideable):void
		{
			var aCollidableTypes:Array = $oObjectToTest.collidesWithTypes;
			var aObjectsOfCurrentType:Array;
			var oCurrentObject:Collideable;
			for (var i:uint = 0; i < aCollidableTypes.length; i++)
			{
				aObjectsOfCurrentType = this._aObjectsBeingTracked[aCollidableTypes[i]];
				if (aObjectsOfCurrentType)
				{
					for (var j:uint = 0; j < aObjectsOfCurrentType.length; j++)
					{
						oCurrentObject = aObjectsOfCurrentType[j];
						if ($oObjectToTest.collisionTestObject.hitTestObject(oCurrentObject.collisionTestObject))
						{
							$oObjectToTest.collidedWith(oCurrentObject);
						}
					}
				}
			}
		}
	}
}

class SingletonLock{};

