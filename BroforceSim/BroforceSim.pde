import java.util.Map;
import java.util.ArrayList;

import processing.core.PApplet;

import grafica.*;
import controlP5.*;

/**
 ===================================================================================================
 FONTS
 ===================================================================================================
 */

// Container for all fonts.
HashMap<String, PFont> font = new HashMap<String, PFont>();

// Retrieve font from font container.
PFont getFont(String fontName)
{
  return font.get( fontName );
}

// Load all saved font files. TODO: Automatically scan font directory and load .vlw files.
void setupFonts()
{
  font.put( "R12", loadFont( "Roboto-Light-12.vlw" ) );
  font.put( "R16", loadFont( "Roboto-Light-16.vlw" ) );
  font.put( "R24", loadFont( "Roboto-Light-24.vlw" ) );
  font.put( "I12", loadFont( "Inconsolata-Regular-12.vlw" ) );

  // Set default font.
  textFont( getFont( "R12") );
}

/**
 ===================================================================================================
 SHAPES
 ===================================================================================================
*/

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


/**
 ===================================================================================================
 INTERFACE
 ===================================================================================================
*/

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
  void createNavigationButton( String text, Rectangle dim, final Menu menu, String font )
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
          println( "Recieved Event from " + _event.getLabel() );
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
    println( "Showing Menu (", _name, ")" );
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


/**
 ===================================================================================================
 MAIN METHODS
 ===================================================================================================
*/

Menu menu;

void setMenu( Menu newMenu )
{
  menu = newMenu;
  menu.show();
}

// Main method. Called before draw loop begins.
void setup()
{
  size( 640, 480 );
  surface.setTitle( "BroforceSim 2.0" );
  // surface.setResizable( true ); // TODO: Make this resizable friendly

  smooth( 1 );

  setupFonts();

  Menu title = new Menu( "Title", this );
  Menu main = new Menu( "Main Menu", this );

  title.createLabel( "BroforceSim 2.0", 230, 150, "R24" );
  title.createNavigationButton( "Let's go!",
                                new Rectangle( 270, 200, 100, 25 ),
                                main, "R16" );

  title.createBox( 220, 140, 200, 100 );

  main.createLineChart( "Fitness", new Rectangle( 10, 0, 430, 400 ), "Max", "Min", "Median" );
  main.createHistogram( "Population", new Rectangle( 420, 0, 200, 400 ) );

  main.createNavigationButton( "Go back",
                               new Rectangle( 520, 440, 100, 25 ),
                               title, "R16" );

  main.setDrawer( new DrawAction() {
      public void draw() {
      }
    } );
  main.hide();

  setMenu( title );

  println( "Initialization Complete" );
}

// Main loop.
void draw()
{
  background( 220 );
  menu.draw();
}

