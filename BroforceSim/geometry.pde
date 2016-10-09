class Rectangle
{
  int _x;
  int _y;
  int _w;
  int _h;
  color _c;

  Rectangle( int x, int y, int w, int h )
  {
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    _c = color( 255 );
  }

  Rectangle( int x, int y, int w, int h, int c )
  {
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    _c = color( c );
  }

  void draw()
  {
    fill( _c );
    stroke( _c );
    rect( _x, _y, _w, _h );
  }
}
