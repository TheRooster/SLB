package edu.ewu.components 
{
	/**
	 * ...
	 * @author Justin Breitenbach
	 */
	public class Wall extends Collideable
	{
		
		public function Wall() 
		{
			super();
			this.visible = false;
			this.sCollisionType = CollisionManager.TYPE_WALL;
			CollisionManager.instance.add(this);
		}
		
	}

}