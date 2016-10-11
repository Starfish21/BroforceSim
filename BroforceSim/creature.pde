interface ICreature
{
  void fromGene( String gene );
  String getGene();
  String getSpecies();
  PGraphics draw();
}

interface ICreatureFactory
{
  ICreature create();
}

class BasicCreature implements ICreature
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

  void fromGene( String gene )
  {
    int k = 0;
    for ( int i = 0; i < 10; i++ )
      for ( int j = 0; j < 10; j++ )
        set( i, j, boolean( int( gene.charAt( k++ ) ) ) );
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

    return str( sum % 10 );
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

class BasicCreatureFactory implements ICreatureFactory
{
  ICreature create()
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
  List< ICreature > _creatures;
  ICreatureFactory _factory;

  Population( int size, ICreatureFactory factory )
  {
    _size = size;
    _creatures = new ArrayList< ICreature >( size );
    _factory = factory;

    for ( int i = 0; i < size; i++ )
      _creatures.add( i, factory.create() );
  }

  ICreature get( int i )
  {
    return _creatures.get( i );
  }

  List< ICreature > getCreatures()
  {
    return _creatures;
  }

  void setCreatures( List< ICreature > creatures )
  {
    _creatures = creatures;
  }

  void remove( int i )
  {
    _creatures.remove( i );
  }

  int getSize()
  {
    return _size;
  }

  void fill()
  {
    if ( _creatures.size() > _size )
      _creatures = _creatures.subList( 0, _size );

    while ( _creatures.size() < _size )
      _creatures.add( _factory.create() );
  }

  void sort( final Map< String, Float > fitnesses )
  {
    Collections.sort( _creatures, new Comparator< ICreature >() {
        @Override
        public int compare( ICreature a, ICreature b )
        {
          return fitnesses.get( a.getGene() ).compareTo( fitnesses.get( b.getGene() ) );
        }
      } );
  }
}
