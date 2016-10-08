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

// Interface Menu class. Defines how it is drawn and what menus follow it.
class Menu implements ControlListener
{
  String    _name; // Name of the Menu
  ControlP5 _cp5;  // ControlP5 Instance
  PApplet   _app;
  Println   _console;
  Runnable  _drawer;

  Menu(String name, PApplet app, Runnable drawer)
  {
    _name = name;
    _cp5 = new ControlP5( app );
    _app = app;
    _drawer = drawer;

    _cp5.addListener(this);

    // Create console ontop of menu.
    Textarea text = _cp5.addTextarea("console")
      .setPosition  ( 5, 375 )
      .setSize      ( 200, 100 )
      .setFont      ( getFont( "I12" ) )
      .setLineHeight( 12 )
      .setColor     ( color( 20 ) )
      .setColorBackground( color( 0, 40 ) )
      .setColorForeground( color( 255, 40 ) );

    _console = _cp5.addConsole(text);
  }

  // Listener function
  void controlEvent(ControlEvent event)
  {
    if (event.getName().equals(_name)) {
      float value = event.getValue();
      println("got value");
    }
  }

  public void show()
  {
    console = _console;
    _cp5.show();
    println( "Showing Menu (", _name, ")" );
  }

  public void hide()
  {
    _cp5.hide();
  }

  public void draw()
  {
    _drawer.run();
  }
}


/**
 ===================================================================================================
 MAIN METHODS
 ===================================================================================================
*/

Menu menu;
Println console;

// Main method. Called before draw loop begins.
void setup()
{
  size( 640, 480 );
  surface.setTitle( "BroforceSim 2.0" );
  // surface.setResizable( true ); // TODO: Make this resizable friendly

  smooth( 1 );

  setupFonts();

  menu = new Menu( "Test", this, new Runnable() {
      public void run () {
        fill(255,0,0);
        rect(10,10,100,100);
      }
    }  );

  menu.show();

  println( "Initialization Complete" );
}

// Main loop.
void draw()
{
  background( 220 );
  menu.draw();
}

