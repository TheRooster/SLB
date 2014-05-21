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
			
			this.sCollisionType = CollisionManager.TYPE_PIT;
			CollisionManager.instance.add(this);
		}
		
	}

}