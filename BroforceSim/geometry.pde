static final float EPSILON = 0.0001;

boolean floatEq( float a, float b )
{
  return ( abs( a - b ) < EPSILON ) ? true : false;
}

class Vector
{
  float _x;
  float _y;

  float getX()
  {
    return _x;
  }

  float getY()
  {
    return _y;
  }

  Vector( float x, float y )
  {
    _x = x;
    _y = y;
  }

  float cross( Vector other )
  {
    return getX() * other.getY() - getY() * other.getX();
  }

  float dot( Vector other )
  {
    return getX() * other.getX() + getY() * other.getY();
  }

  float mag()
  {
    return sqrt( dot( this ) );
  }
}

class Point
{
  float _x;
  float _y;

  float getX()
  {
    return _x;
  }

  float getY()
  {
    return _y;
  }

  Point( float x, float y )
  {
    _x = x;
    _y = y;
  }

  Vector minus( Point other )
  {
    return new Vector( _x - other.getX(), _y - other.getY() );
  }

  boolean equals( Point other )
  {
    if ( floatEq( other.getX(), _x ) && floatEq( other.getY(), _y ) )
      return true;

    return false;
  }
}

class Line
{
  Point _a;
  Point _b;

  Line( Point a, Point b )
  {
    _a = a;
    _b = b;
  }

  Point getA()
  {
    return _a;
  }

  Point getB()
  {
    return _b;
  }

  Line( float x1, float y1, float x2, float y2 )
  {
    _a = new Point( x1, y1 );
    _b = new Point( x2, y2 );
  }

  boolean intersects( Line line )
  {
    return true;
  }

  boolean intersects( Rectangle rect )
  {
    return true;
  }

  boolean contains( Point point )
  {
    Vector AtoP = point.minus( getA() );
    Vector AtoB = getB().minus( getA() );

    // Check if point lies along vector created by the points
    if ( floatEq( AtoP.cross( AtoB ), 0 ) )
      return false;

    // Check if point is inside the bounds of the line.
    Rectangle bbox = new Rectangle( getA(), getB() );

    if ( bbox.contains( point ) )
      return true;

    return false;
  }
}

class Rectangle
{
  Point _lu; // Left-upper point.
  Point _rb; // Right-bottom point.
  color _c;

  // Takes input and verifies that _lu is the left-upper corner and _rb is the
  // right-bottom corner.
  void validate()
  {
    _lu = new Point( min( _lu.getX(), _rb.getX() ),
                     min( _lu.getY(), _rb.getY() ) );
    _rb = new Point( max( _lu.getX(), _rb.getX() ),
                     max( _lu.getY(), _rb.getY() ) );
  }

  Rectangle( int x, int y, int w, int h )
  {
    this( x, y, w, h, 255 );
  }

  Rectangle( int x, int y, int w, int h, int c )
  {
    _lu = new Point( x, y );
    _rb = new Point( x + w, y + h );
    _c = color( c );
    validate();
  }

  Rectangle( Point a, Point b )
  {
    _lu = a;
    _rb = b;
    _c = color( 255 );
    validate();
  }

  float getWidth()
  {
    return _rb.getX() - _lu.getX();
  }

  float getHeight()
  {
    return _rb.getY() - _lu.getY();
  }

  float getXUpper()
  {
    return _lu.getX();
  }

  float getYUpper()
  {
    return _lu.getY();
  }

  float getXLower()
  {
    return _rb.getX();
  }

  float getYLower()
  {
    return _rb.getY();
  }

  boolean contains( Point point )
  {
    if ( point.getX() >= getXUpper()
         && point.getX() <= getXLower()
         && point.getY() >= getYUpper()
         && point.getY() <= getYLower() )
      return true;

    return false;
  }

  void draw( PGraphics p )
  {
    p.beginDraw();
    p.fill( _c );
    p.stroke( _c );
    p.rect( getXUpper(), getYUpper(), getWidth(), getHeight() );
    p.endDraw();
  }
}
