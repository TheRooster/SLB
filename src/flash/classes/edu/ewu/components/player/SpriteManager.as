package edu.ewu.components.player 
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.senocular.display.duplicateDisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class SpriteManager 
	{
		private var _dSprites:Array = new Array();
		private var _aLoadStarted:Array = new Array();
		private static const _instance:SpriteManager= new SpriteManager(SingletonLock);
		
		
		/**
		 * Constructs the PlayerManager object.
		 */
		public function SpriteManager($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("PlayerManager is a singleton and should not be instantiated. Use PlayerManager.instance instead");
		}
		
		/*--------------------------------------------------------------------------------------------------------------------------------------*/
		
		/**
		 * Loads the specified .swf file into a movieclip or returns the movieclip if it's already loaded
		 * @param	$name the name of the character to load
		 * @return  The specified movieclip if it's loaded, or null if it isn't
		 */
		public function load($name:String, $source:Player)
		{
			if(_dSprites[$name] == null)
			{
				var loader:SWFLoader = new SWFLoader("resources/swfs/" + $name + ".swf", { name:$name + "_Sprite", onComplete:function() { _dSprites[$name] = MovieClip(loader.rawContent).getChildAt(0); $source.initSprite(_dSprites[$name]); } } );
				loader.load();
			}
			else
			{
				var clone:MovieClip = MovieClip(duplicateDisplayObject(_dSprites[$name], true));
				$source.initSprite(clone);
			}
		}
		
		/*--------------------------------------------------------------------------------------------------------------------------------------*/	

		
		/**
		 * Returns instance of SpriteManager if it exists.
		 * 
		 * @return			Returns singleton instance of SpriteManager.
		 */
		public static function get instance():SpriteManager
		{
			return _instance;
		}
	}
	



}
class SingletonLock { };
