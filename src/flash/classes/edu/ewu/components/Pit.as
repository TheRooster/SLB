package edu.ewu.components 
{
	/**
	 * ...
	 * @author Justin Breitenbach
	 */
	public class Pit extends Collideable
	{
		
		public function Pit() 
		{
			super();
			this.visible = false;
			this.sCollisionType = CollisionManager.TYPE_PIT;
			CollisionManager.instance.add(this);
		}
		
	}

}