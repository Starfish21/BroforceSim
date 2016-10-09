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

  main.createLineChart( "Fitness", new Rectangle( 10, 10, 430, 300 ), "Max", "Min", "Median" );
  main.createHistogram( "Population", new Rectangle( 420, 10, 200, 300 ) );

  main.createButton( "Save Image", new Rectangle( 410, 440, 100, 25 ), "R16",
                     new EventAction() {
                       public void run() {
                         saveFrame();
                       }
                     } );

  main.createButton( "Run Sim.", new Rectangle( 20, 440, 100, 25 ), "R16",
                     new EventAction() {
                       boolean run = false;
                       public void run() {
                         run = ( run ) ? false : true;
                         Label label = _event.getController().getCaptionLabel();

                         if ( run )
                           label.setText( "Stop Sim." );
                         else
                           label.setText( "Run Sim." );
                       }
                     } );

  main.createNavigationButton( "View Pop.", new Rectangle( 130, 440, 100, 25 ), "Population", "R16" );
  main.createNavigationButton( "Go back", new Rectangle( 520, 440, 100, 25 ), "Title", "R16" );

  main.createBox( 20, 345, 130, 80 );
  main.createBox( 160, 345, 130, 80 );
  main.createBox( 300, 345, 130, 80 );

  main.createLabel( "Worst", 25, 350, "R12" );
  main.createLabel( "Median", 165, 350, "R12" );
  main.createLabel( "Best", 305, 350, "R12" );

  main.setDrawer( new DrawAction() {
      BasicCreature creature = new BasicCreature();

      public void draw() {
        PGraphics p = creature.draw();
        // _menu.drawPGraphics( p, 0, 0, 100, 100 );
      }
    } );

  addMenu( "Main", main );
}

void createPopulationView()
{
  Menu population = new Menu( "Population", this );
  population.createNavigationButton( "Go back", new Rectangle( 520, 440, 100, 25 ), "Main", "R16" );

  addMenu( "Population", population );
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
  createPopulationView();
}

// Main loop.
void draw()
{
  background( 220 );
  drawMenu();
}

