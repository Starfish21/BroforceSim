interface IFitness
{
  float getFitness( ICreature creature );
}

interface IElitism
{
  List< ICreature > elitism( List< ICreature > population, Map< String, Float > fitness );
}

interface IDropout
{
  List< ICreature > dropout( List< ICreature > population, Map< String, Float > fitness );
}

interface ICrossover
{
  void crossover( ICreature a, ICreature b );
}

interface IMutation
{
  void mutate( ICreature c );
}

interface IAlgorithm
{
  void calcFitness();
  void nextGeneration();
  float getFitness( ICreature creature );
  Map< String, Float > getSpecies();
  ICreature getBest();
  ICreature getWorst();
  ICreature getMedian();
}

class Algorithm implements IAlgorithm
{
  IElitism _elitism;
  IDropout _dropout;
  IFitness _fitness;
  ICrossover _crossover;
  IMutation _mutation;

  Population _population;
  Map< String, Float > _scores = new HashMap< String, Float >();

  Algorithm( Population population, IElitism elitism, IDropout dropout, IFitness fitness,
             ICrossover crossover, IMutation mutation )
  {
    _population = population;
    _fitness = fitness;
    _elitism = elitism;
    _dropout = dropout;
    _crossover = crossover;
    _mutation = mutation;
  }

  void calcFitness()
  {
    _scores.clear();

    for ( int i = 0; i < _population.getSize(); i++ )
    {
      ICreature creature = _population.get( i );
      _scores.put( creature.getGene(), _fitness.getFitness( creature ) );
    }

    _population.sort( _scores );
  }

  ICreature weightedSelect( List< ICreature > creatures )
  {
    // float m = Collections.min( _scores.valueSet() );

    // float sum = 0;
    // for ( int i = 0; i < _creatures.size(); i++ )
    //   sum += getFitness( _creatures.get( i ) ) + m;

    // double value = random( 0, 1 ) * sum;
    // for( int i = 0; i < creatures.size(); i++) {
    //   value -= getFitness( creatures.get( i ) ) + m;

    //   if ( value <= 0 )
    //     return creatures.get( i );
    // }

    return creatures.get( creatures.size() - 1 );
  }

  float getFitness( ICreature creature )
  {
    if ( !_scores.containsKey( creature.getGene() ) )
      return 0;

    return _scores.get( creature.getGene() ).floatValue();
  }

  List< ICreature > doElitism( List< ICreature > creatures )
  {
    if ( _elitism != null )
      return _elitism.elitism( _population.getCreatures(), _scores );

    return new ArrayList< ICreature >();
  }

  List< ICreature > doDropout( List< ICreature > creatures )
  {
    if ( _dropout != null )
      return _dropout.dropout( creatures, _scores );

    return creatures;
  }

  void doCrossover( List< ICreature > creatures )
  {
    if ( _crossover == null )
      return;

    List< Integer > mates = new ArrayList< Integer >( creatures.size() );
    for ( int i = 0; i < mates.size(); i++ )
      mates.set( i, i );

    // Collections.shuffle( mates );

    for ( int i = 0; i < mates.size(); i += 2 )
      _crossover.crossover( creatures.get( mates.get( i ) ), creatures.get( mates.get( i + 1 ) ) );
  }

  void doMutation( List< ICreature > creatures )
  {
    if ( _mutation == null )
      return;

    for ( int i = 0; i < creatures.size(); i++ )
      _mutation.mutate( creatures.get( i ) );
  }

  void nextGeneration()
  {
    List< ICreature > creatures = _population.getCreatures();

    List< ICreature > elite = doElitism( creatures );
    creatures.removeAll( elite );

    List< ICreature > remaining = doDropout( creatures );

    doCrossover( remaining );
    doMutation( remaining );

    List< ICreature > newPop = new ArrayList< ICreature >();
    newPop.addAll( elite );
    newPop.addAll( remaining );

    println( newPop.size() );

    _population.setCreatures( newPop );
    _population.fill();
  }

  Map< String, Float > getSpecies()
  {
    Map< String, Float > map = new TreeMap< String, Float >();

    float v =  1. / _population.getSize();
    for ( int i = 0; i < _population.getSize(); i++ )
    {
      ICreature c = _population.get( i );
      if ( !map.containsKey( c.getSpecies() ) )
        map.put( c.getSpecies(), v );
      else
        map.put( c.getSpecies(), map.get( c.getSpecies() ) + v );
    }

    return map;
  }

  ICreature getBest()
  {
    return _population.get( _population.getSize() - 1 );
  }

  ICreature getWorst()
  {
    return _population.get( 0 );
  }

  ICreature getMedian()
  {
    return _population.get( _population.getSize() / 2 );
  }
}

class BasicCreatureFitness implements IFitness
{
  float getFitness( ICreature creature )
  {
    float score = 0;

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

class BasicCreatureDropout implements IDropout
{
  List< ICreature > dropout( List< ICreature > population, Map< String, Float > fitness )
  {
    return population.subList( 10, population.size() );
  }
}

class BasicCreatureElitism implements IElitism
{
  List< ICreature > elitism( List< ICreature > population, Map< String, Float > fitness )
  {
    // return population.subList( population.size() - 5, population.size() );
    List< ICreature > elite = new ArrayList< ICreature >();
    elite.add( population.get( population.size() - 1 ) );
    return elite;
  }
}

class BasicCreatureMutation implements IMutation
{
  float prob = 0.1;

  void mutate( ICreature c )
  {
    BasicCreature creature = ( BasicCreature ) c;

    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
      {
        if ( random( 0, 1 ) < prob )
          creature.set( i, j, ( creature.get( i, j ) ) ? false : true );
      }
  }
}

class BasicCreatureCrossover implements ICrossover
{
  float prob = 0.1;

  void crossover( ICreature a, ICreature b )
  {
    if ( prob < random( 0, 1 ) )
      return;

    String ag = a.getGene();
    String bg = b.getGene();

    int s = int( random( 0, ag.length() ) );

    String t = ag.substring( 0, s ) + bg.substring( s, bg.length() );
    b.fromGene( ag.substring( 0, s ) + bg.substring( s, bg.length() ) );
    a.fromGene( t );
  }
}


// Global variable for algorithm.
IAlgorithm alg = new Algorithm( new Population( 100, new BasicCreatureFactory() ),
                                new BasicCreatureElitism(),
                                new BasicCreatureDropout(),
                                new BasicCreatureFitness(),
                                new BasicCreatureCrossover(),
                                new BasicCreatureMutation() );
