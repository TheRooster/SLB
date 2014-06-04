package edu.ewu.components.player 
{
  import org.flintparticles.common.actions.Age;
  import org.flintparticles.common.counters.Steady;
  import org.flintparticles.common.displayObjects.Line;
  import org.flintparticles.common.initializers.ColorInit;
  import org.flintparticles.common.initializers.Lifetime;
  import org.flintparticles.common.initializers.SharedImage;
  import org.flintparticles.twoD.actions.Move;
  import org.flintparticles.twoD.actions.RotateToDirection;
  import org.flintparticles.twoD.activities.FollowMouse;
  import org.flintparticles.twoD.emitters.Emitter2D;
  import org.flintparticles.twoD.initializers.Velocity;
  import org.flintparticles.twoD.zones.DiscZone;

  import flash.display.DisplayObject;
  import flash.geom.Point;

  public class Sparkler extends Emitter2D
  {
	  
    public function Sparkler( renderer:DisplayObject )
    {
      counter = new Steady( 150 );
      
      addInitializer( new SharedImage( new Line( 8 ) ) );
      addInitializer( new ColorInit( 0x00CCFF00, 0x0000FF00 ) );
      addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 350, 200 ) ) );
      addInitializer( new Lifetime( 0.2, 0.4 ) );
      
      addAction( new Age() );
      addAction( new Move() );
      addAction( new RotateToDirection() );
      
    }
  }


}