class EventAction implements Runnable
{
  ControlEvent _event;
  EventAction()
  {
  }

  void setEvent( ControlEvent event )
  {
    _event = event;
  }

  public void run()
  {
  };
}

class DrawAction
{
  Menu _menu;

  DrawAction()
  {
  }

  void setMenu( Menu menu )
  {
    _menu = menu;
  }

  void draw()
  {
  }
}

// Interface Menu class. Defines how it is drawn and what menus follow it.
class Menu implements ControlListener
{
  String    _name; // Name of the Menu
  ControlP5 _cp5;  // ControlP5 Instance
  PApplet   _app;
  DrawAction _drawer = null;
  HashMap< String, EventAction > _buttonActions = new HashMap< String, EventAction >();
  ArrayList< Rectangle > _boxes = new ArrayList< Rectangle >();
  HashMap< String, GPlot > _plots = new HashMap< String, GPlot >();

  void setup( String name, PApplet app )
  {
    _name = name;
    _cp5 = new ControlP5( app );
    _app = app;

    _cp5.addListener( this );
  }

  Menu( String name, PApplet app )
  {
    setup( name, app );
  }

  Menu( String name, PApplet app, DrawAction drawer )
  {
    setup( name, app );
    setDrawer( drawer );
  }

  void setDrawer( DrawAction drawer )
  {
    _drawer = drawer;
    _drawer.setMenu( this );
  }

  int _labelIndex = 0;
  void createLabel( String text, float x, float y, String font )
  {
    _cp5.addTextlabel( "label" + str( _labelIndex++ ) )
      .setText( text )
      .setPosition( x, y )
      .setColor( 20 )
      .setFont( getFont( font ) );
  }

  int _buttonIndex = 0;
  void createNavigationButton( String text, Rectangle dim, final String menu, String font )
  {
    String label = "button" + str( _buttonIndex++ );
    _cp5.addButton( label )
      .setLabel( text )
      .setPosition( dim._x, dim._y )
      .setSize( dim._w, dim._h )
      .setColorBackground( color( 20 ) )
      .setColorActive( color( 30 ) );

    // Set label properties
    _cp5.getController( label )
      .getCaptionLabel()
      .toUpperCase( false )
      .setColor( 230 )
      .setFont( getFont( font ) );

    final Menu that = this;
    // Set action when pressed
    _buttonActions.put( text, new EventAction() {
        public void run() {
          that.hide();
          setMenu( menu );
        }
      } );
  }

  GPlot createLineChart( String label, Rectangle dim, String... layers )
  {
    // Dumb magic number adjustment.
    dim._x -= 40;
    dim._y -= 10;
    dim._w -= 40;
    dim._h -= 30;

    GPlot plot = new GPlot( _app );
    plot.setTitleText( label );
    plot.setPos( dim._x, dim._y );
    plot.setDim( dim._w, dim._h );

    plot.activatePointLabels();

    int plotColor = 40;
    for ( String layer : layers )
    {
      plot.addLayer( layer, new GPointsArray(0) );
      plot.getLayer( layer ).setLineColor( color( plotColor ) );
      plotColor += 20;
    }

    _plots.put( label, plot );
    return plot;
  }

  GPlot createHistogram( String label, Rectangle dim )
  {
    // Dumb magic number adjustment.
    dim._x -= 40;
    dim._y -= 10;
    dim._w -= 40;
    dim._h -= 30;

    GPlot plot = new GPlot( _app );
    plot.setTitleText( label );
    plot.setPos( dim._x, dim._y );
    plot.setDim( dim._w, dim._h );

    plot.activatePointLabels();

    plot.startHistograms( GPlot.HORIZONTAL );
    plot.getHistogram().setDrawLabels( true );
    plot.getHistogram().setRotateLabels( true );
    plot.getHistogram().setBgColors( new color[] { color( 20, 50 ) } );

    _plots.put( label, plot );
    return plot;
  }

  void addPointToLineChart( String label, String line, float x, float y )
  {
    GPlot plot = _plots.get( label );
    GLayer layer = plot.getLayer( line );

    layer.addPoint( x, y );
  }

  void setHistogramData( String label, HashMap< String, Float > points )
  {
    GPointsArray data = new GPointsArray( points.size() );

    int i = 0;
    for ( String type : points.keySet() )
    {
      float count = points.get( type );
      float pos = i + 0.5 - points.size() / 2.0;
      data.add( count, pos, type );
      i++;
    }

    GPlot plot = _plots.get( label );
    plot.setPoints( data );
  }

  void createBox( int x, int y, int w, int h )
  {
    _boxes.add( new Rectangle( x + 2, y + 2, w, h, 20 ) );
    _boxes.add( new Rectangle( x, y, w, h, 240 ) );
  }

  // Listener function
  void controlEvent(ControlEvent event)
  {
    EventAction action = _buttonActions.get( event.getLabel() );
    action.setEvent( event );
    action.run();
  }

  public void show()
  {
    _cp5.show();
  }

  public void hide()
  {
    _cp5.hide();
  }

  public void draw()
  {
    String title = "BroforceSim 2.0 - " + _name;
    surface.setTitle( title );

    // Draw boxes.
    for ( Rectangle rect : _boxes )
    {
      rect.draw();
    }

    // Draw plots.
    for ( GPlot plot : _plots.values() )
    {
      plot.updateLimits();
      plot.beginDraw();
      plot.drawBox();
      plot.drawGridLines(GPlot.BOTH);
      plot.drawTitle();
      plot.drawXAxis();

      if (plot.getHistogram() == null)
        plot.drawYAxis();

      plot.drawTopAxis();
      plot.drawRightAxis();
      plot.drawLines();
      plot.drawHistograms();
      plot.endDraw();
    }

    if ( _drawer != null )
      _drawer.draw();
  }
}

HashMap< String, Menu > menus = new HashMap< String, Menu >();
Menu currentMenu;

void setMenu( String newMenu )
{
  currentMenu = menus.get( newMenu );
  currentMenu.show();
}

void addMenu( String label, Menu menu )
{
  menus.put( label, menu );
  menu.hide();
}

void drawMenu()
{
  currentMenu.draw();
}
