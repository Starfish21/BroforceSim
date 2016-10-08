import java.util.Map;

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
  Runnable  _drawer;
  HashMap< String, EventAction > _buttons = new HashMap< String, EventAction >();

  Menu(String name, PApplet app, Runnable drawer)
  {
    _name = name;
    _cp5 = new ControlP5( app );
    _app = app;
    _drawer = drawer;

    _cp5.addListener(this);
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

  title = new Menu( "Title", this, new Runnable() {
      public void run() {
        fill( 20 );
        stroke( 20 );
        rect( 222, 142, 200, 100 );

        fill( 240 );
        stroke( 240 );
        rect( 220, 140, 200, 100 );
      }
    } );

  main = new Menu( "Main Menu", this, new Runnable() {
      public void run() {
      }
    } );

  title.createLabel( "BroforceSim 2.0", 230, 150, "R24" );
  title.createNavigationButton( "Let's go!", 270, 200, 100, 25, main, "R16" );

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

