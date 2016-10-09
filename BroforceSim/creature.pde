interface Creature
{
  PGraphics draw();
}

interface CreatureFactory
{
  Creature create();
}

interface Environment
{
  PGraphics draw();
}


class BasicCreature implements Creature
{
  boolean[][] data = new boolean[10][10];

  boolean get( int i, int j )
  {
    return data[ i ][ j ];
  }

  void set( int i, int j, boolean val )
  {
    data[ i ][ j ] = val;
  }

  PGraphics draw()
  {
    PGraphics g = createGraphics( 10, 10 );
    g.beginDraw();
    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
        if ( data[ i ][ j ] )
          g.point( i, j );
    g.endDraw();
    return g;
  }
}


class BasicCreatureFactory implements CreatureFactory
{
  BasicCreature create()
  {
    BasicCreature creature = new BasicCreature();
    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
        creature.set( i, j, ( random(0, 1) < 0.5 ) ? false : true );

    return creature;
  }
}


class Population
{
  int _size;
  ArrayList< Creature > _creatures;
  CreatureFactory _factory;

  Population( int size, CreatureFactory factory )
  {
    _size = size;
    _creatures = new ArrayList< Creature >( size );
    _factory = factory;

    for ( int i = 0; i < size; i++ )
      _creatures.set( i, factory.create() );
  }

  Creature get( int i )
  {
    return _creatures.get( i );
  }

  void remove( int i )
  {
    _creatures.remove( i );
  }

  void fill()
  {
    while ( _creatures.size() < _size )
    {
      _creatures.add( _factory.create() );
    }
  }
}

interface Algorithm
{
  double getParameter( String parameter );

  // Elitism
  // Dropout
  // Mutation
  // Crossover
}

interface Fitness
{
  double getFitness( Creature creature );
}

