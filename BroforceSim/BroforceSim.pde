import java.util.*;

import processing.core.PApplet;

import grafica.*;
import controlP5.*;

class Holder< T > {
  T _value;
  Holder( T value )
  {
    _value = value;
  }
}

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

  main.createLineChart( "Fitness", new Rectangle( 10, 10, 410, 300 ), "Max", "Min", "Median" );
  main.createHistogram( "Population", new Rectangle( 420, 10, 200, 300 ) );

  main.createButton( "Save Image", new Rectangle( 410, 440, 100, 25 ), "R16",
                     new EventAction() {
                       public void run() {
                         saveFrame();
                       }
                     } );

  final Holder< Boolean > run = new Holder< Boolean >( false );
  main.createButton( "Run Sim.", new Rectangle( 20, 440, 100, 25 ), "R16",
                     new EventAction() {
                       public void run() {
                         run._value = ( run._value ) ? false : true;
                         Label label = _event.getController().getCaptionLabel();

                         if ( run._value.booleanValue() )
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
      int step = 0;

      PGraphics worst = createGraphics( 1, 1 );
      PGraphics median = createGraphics( 1, 1 );
      PGraphics best = createGraphics( 1, 1 );

      public void draw() {
        _menu.drawPGraphics( worst, 75, 350, 70, 70 );
        _menu.drawPGraphics( median, 215, 350, 70, 70 );
        _menu.drawPGraphics( best, 355, 350, 70, 70 );

        if ( run._value )
        {
          alg.calcFitness();

          worst = alg.getWorst().draw();
          median = alg.getMedian().draw();
          best = alg.getBest().draw();

          _menu.addPointToLineChart( "Fitness", "Max", step, alg.getFitness( alg.getBest() ) );
          _menu.addPointToLineChart( "Fitness", "Min", step, alg.getFitness( alg.getWorst() ) );
          _menu.addPointToLineChart( "Fitness", "Median", step, alg.getFitness( alg.getMedian() ) );
          _menu.setHistogramData( "Population", alg.getSpecies() );
          step++;

          alg.nextGeneration();
        }
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

