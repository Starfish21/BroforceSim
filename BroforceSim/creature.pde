interface Creature
{
  PGraphics draw();
  String getGene();
  String getSpecies();
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

  String getGene()
  {
    String gene = "";
    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
      {
        if ( get( i, j ) )
          gene += "1";
        else
          gene += "0";
      }

    return gene;
  }

  String getSpecies()
  {
    int sum = 0;
    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
        sum += ( get( i, j ) ) ? 1 : -1;

    return str( sum );
  }

  PGraphics draw()
  {
    PGraphics p = createGraphics( 10, 10 );
    p.beginDraw();
    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
        if ( data[ i ][ j ] )
          p.point( i, j );
    p.endDraw();
    return p;
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
  List< Creature > _creatures;
  CreatureFactory _factory;

  Population( int size, CreatureFactory factory )
  {
    _size = size;
    _creatures = new ArrayList< Creature >( size );
    _factory = factory;

    for ( int i = 0; i < size; i++ )
      _creatures.add( i, factory.create() );
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

  void sort( final HashMap< String, Double > fitnesses )
  {
    Collections.sort( _creatures, new Comparator< Creature >() {
        @Override
        public int compare( Creature a, Creature b )
        {
          return fitnesses.get( a.getGene() ).compareTo( fitnesses.get( b.getGene() ) );
        }
      } );
  }
}

interface Algorithm
{
  void calcFitness();
  void nextGeneration();
  // Elitism
  // Dropout
  // Mutation
  // Crossover


  Creature getBest();
  Creature getWorst();
  Creature getMedian();
}

interface Fitness
{
  double getFitness( Creature creature );
}

class BasicCreatureFitness implements Fitness
{
  double getFitness( Creature creature )
  {
    double score = 0;

    BasicCreature c = ( BasicCreature ) creature;

    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
      {
        if ( i == j && c.get( i, j ) )
          score += 1;
        else if ( i != j && !c.get( i, j ) )
          score += 1;
        else
          score -= 1;
      }

    return score;
  }
}

class BasicCreatureAlgorithm implements Algorithm
{
  Population pop = new Population( 100, new BasicCreatureFactory() );
  BasicCreatureFitness calc = new BasicCreatureFitness();
  HashMap< String, Double > fitness = new HashMap< String, Double >();

  void calcFitness()
  {
    for ( int i = 0; i < 100; i++ )
    {
      fitness.put( pop.get( i ).getGene(), calc.getFitness( pop.get( i ) ) );
    }
    pop.sort( fitness );
  }

  void nextGeneration()
  {
    for ( int i = 0; i < 50; i++ )
      pop.remove( i );

    pop.fill();
  }

  float getFitness( Creature creature )
  {
    return fitness.get( creature.getGene() ).floatValue();
  }

  Map< String, Float > getSpecies()
  {
    Map< String, Float > map = new TreeMap< String, Float >();
    for ( int i = 0; i < 100; i++ )
    {
      Creature c = pop.get( i );
      if ( !map.containsKey( c.getSpecies() ) )
        map.put( c.getSpecies(), 1. );
      else
        map.put( c.getSpecies(), map.get( c.getSpecies() ) + 1 );
    }

    return map;
  }

  Creature getBest()
  {
    return pop.get( 99 );
  }

  Creature getWorst()
  {
    return pop.get( 0 );
  }

  Creature getMedian()
  {
    return pop.get( 50 );
  }
}
