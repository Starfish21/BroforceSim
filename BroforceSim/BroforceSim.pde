import java.util.Map;
import java.util.ArrayList;

import processing.core.PApplet;

import grafica.*;
import controlP5.*;

void createTitle()
{
  Menu title = new Menu( "Title", this );

  title.createLabel( "BroforceSim 2.0", 230, 150, "R24" );
  title.createNavigationButton( "Let's go!",
                                new Rectangle( 270, 200, 100, 25 ),
                                "Main", "R16" );

  title.createBox( 220, 140, 200, 100 );

  addMenu( "Title", title );
  setMenu( "Title" );
}

void createMainMenu()
{
  Menu main = new Menu( "Main", this );

  main.createLineChart( "Fitness", new Rectangle( 10, 0, 430, 400 ), "Max", "Min", "Median" );
  main.createHistogram( "Population", new Rectangle( 420, 0, 200, 400 ) );

  main.createNavigationButton( "Go back",
                               new Rectangle( 520, 440, 100, 25 ),
                               "Title", "R16" );

  main.setDrawer( new DrawAction() {
      public void draw() {
      }
    } );

  addMenu( "Main", main );
}


// Main method. Called before draw loop begins.
void setup()
{
  size( 640, 480 );
  surface.setTitle( "BroforceSim 2.0" );
  // surface.setResizable( true ); // TODO: Make this resizable friendly

  smooth( 1 );

  setupFonts();

  createTitle();
  createMainMenu();
}

// Main loop.
void draw()
{
  background( 220 );
  drawMenu();
}

