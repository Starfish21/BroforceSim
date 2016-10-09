class Creature
{
  boolean[][] data = new boolean[10][10];

  Creature()
  {
    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
        data[ i ][ j ] = ( random(0, 1) < 0.5 ) ? false : true;
  }

  void draw( PGraphics g )
  {
    g.beginDraw();
    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
        if ( data[ i ][ j ] )
          g.point( i, j );
    g.endDraw();
  }
}

class Environment
{
  Environment( Rectangle[] obstacles )
  {
  }

  void draw( PGraphics g )
  {
  }
}

class Simulation
{
  Simulation( Creature creature, Environment environment )
  {
  }
}
