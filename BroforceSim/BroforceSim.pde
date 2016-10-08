import java.util.Map;
import java.util.ArrayList;

import processing.core.PApplet;

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
  float _x;
  float _y;
  int _w;
  int _h;
  color _c;

  Rectangle( float x, float y, int w, int h, int c )
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

// Interface Menu class. Defines how it is drawn and what menus follow it.
class Menu implements ControlListener
{
  String    _name; // Name of the Menu
  ControlP5 _cp5;  // ControlP5 Instance
  PApplet   _app;
  Runnable  _drawer = null;
  HashMap< String, EventAction > _buttons = new HashMap< String, EventAction >();
  ArrayList< Rectangle > _boxes = new ArrayList< Rectangle >();

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

  Menu( String name, PApplet app, Runnable drawer )
  {
    setup( name, app );
    _drawer = drawer;
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
  void createNavigationButton( String text, float x, float y, int w, int h, final Menu menu, String font )
  {
    String label = "button" + str( _buttonIndex++ );
    _cp5.addButton( label )
      .setLabel( text )
      .setPosition( x, y )
      .setSize( w, h )
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
    _buttons.put( text, new EventAction() {
        public void run() {
          println( "Recieved Event from " + _event.getLabel() );
          that.hide();
          setMenu( menu );
        }
      } );
  }

  void createBox( float x, float y, int w, int h )
  {
    _boxes.add( new Rectangle( x + 2, y + 2, w, h, 20 ) );
    _boxes.add( new Rectangle( x, y, w, h, 240 ) );
  }

  // Listener function
  void controlEvent(ControlEvent event)
  {
    EventAction action = _buttons.get( event.getLabel() );
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

    for ( Rectangle rect : _boxes )
    {
      rect.draw();
    }

    if ( _drawer != null )
      _drawer.run();
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

  Menu title, main;

  title = new Menu( "Title", this );
  title.createLabel( "BroforceSim 2.0", 230, 150, "R24" );
  title.createNavigationButton( "Let's go!", 270, 200, 100, 25, main, "R16" );
  title.addBox( 220, 140, 200, 100 );

  main = new Menu( "Main Menu", this );
  main.createNavigationButton( "Go back", 270, 180, 100, 25, title, "R16" );
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

