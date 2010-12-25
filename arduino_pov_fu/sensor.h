/**********************************************************************
 * Sensor handling
 */

#ifndef __SENSOR_H_
#define __SENSOR_H_

// unsure why this is required in an include file
#include <WProgram.h>

#include "display.h"
#include "utilities.h"

#define SENSOR_CALIBRATION_THRES 8

// ADXL330 in analog mode
const int sensorXPin = A0;
const int sensorYPin = A1;
const int sensorZPin = A2;

float sensorX = 0;
float sensorY = 0;
float sensorZ = 0;
float sensorX0 = 0;
float sensorY0 = 0;
float sensorZ0 = 0;
float sensorPrevX = 0;
float sensorPrevY = 0;
float sensorPrevZ = 0;
float velocityX = 0;
float velocityY = 0;
float velocityZ = 0;
float locationX = 0;
float locationY = 0;
float locationZ = 0;

void sensor_read() {
  float xr, yr, zr;
  sensorPrevX = sensorX;
  sensorPrevY = sensorY;
  sensorPrevZ = sensorZ;
  xr = analogRead( sensorXPin ) - sensorX0;
  yr = analogRead( sensorYPin ) - sensorY0;
  zr = analogRead( sensorZPin ) - sensorZ0;
  sensorX = 0.707107 * (xr - yr);
  sensorY = 0.707107 * (xr + yr);
  sensorZ = zr;
  velocityX += sensorX;
  velocityY += sensorY;
  velocityZ += sensorZ;
  locationX += velocityX;
  locationY += velocityY;
  locationZ += velocityZ;
}

void sensor_calibrate() {
  int i;
  float x0, y0, z0, z1;

/*  for( i=20 ; i>0 ; i-- ) {
    x0 += analogRead( sensorXPin );
    y0 += analogRead( sensorYPin );
    z1 += analogRead( sensorZPin );    
    delay( 5 );
  }
  x0/=20.0;
  y0/=20.0;
  z1/=20.0;
*/
  
  sSeq seqX, seqY, seqZ;
  
  seq_init( seqX, 32 );
  seq_init( seqY, 32 );
  seq_init( seqZ, 32 );

  for( i=32 ; i>0 ; i-- ) {
    seq_push( seqX, analogRead( sensorXPin ) );
    seq_push( seqY, analogRead( sensorYPin ) );
    seq_push( seqZ, analogRead( sensorZPin ) );
    delay( 10 );
  }

  seq_stats( seqX );
  seq_stats( seqY );
  seq_stats( seqZ );

  x0 = seqX.average;
  y0 = seqY.average;
  z1 = seqZ.average;
  
  // set preliminary zero point so we can use sensor_read()
  sensorX0 = x0;
  sensorY0 = y0;
  sensorZ0 = z1; // only until we know better

  // minimize Z axis to put full g force into X/Y plane
  sSeq target;
  
  seq_init( seqX, 32 );
  seq_init( seqY, 32 );
  seq_init( seqZ, 32 );
  seq_init( target, 32 );
  
  byte haveX = 0;
  byte haveYZ = 0;
  byte level1 = 0;
  byte level2 = 0;
  byte level3 = 0;
  byte level4 = 0;
  byte level5 = 0;
  byte level6 = 0;
  byte level7 = 0;
  byte level8 = 0;

  while( !level8 ){
    sensor_read();
    seq_push( seqX, sensorX );
    seq_push( seqY, sensorY );
    seq_push( seqZ, sensorZ );
    seq_stats( seqX );
    seq_stats( seqY );
    seq_stats( seqZ );

    // all force in X/Y plane?
    haveX = abs(seqZ.average)>10
      && seqX.average<SENSOR_CALIBRATION_THRES
      && seqX.average>-SENSOR_CALIBRATION_THRES;
    haveYZ = abs(seqZ.average)>10
      && (seqY.average + seqZ.average)<SENSOR_CALIBRATION_THRES
      && (seqY.average + seqZ.average)>-SENSOR_CALIBRATION_THRES;

    if( haveX && haveYZ ) {
      seq_push( target, seqZ.average );
      seq_stats( target );
      
      level1 = target.fill > 10;
      level2 = level1 && (target.maximum - target.minimum) < 10.0;
      level3 = level2 && (target.maximum - target.minimum) < 5.0;
      level4 = level3 && (target.maximum - target.minimum) < 2.5;
      level5 = level4 && (target.maximum - target.minimum) < 1.5;
      level6 = level5 && (target.maximum - target.minimum) < 1.0;
      level7 = level6 && abs(target.average + seqY.average) < 4.0;
      level8 = level7 && abs(target.average + seqY.average) < 1.0;
    }

    display_set(  (level8 ? 1<<0 : 0)
                + (level7 ? 1<<1 : 0)
                + (level6 ? 1<<2 : 0)
                + (level5 ? 1<<3 : 0)
                + (level4 ? 1<<4 : 0)
                + (level3 ? 1<<5 : 0)
                + (level2 ? 1<<6 : 0)
                + (level1 ? 1<<7 : 0)
                + (haveYZ ? 1<<8 : 0)
                + ( haveX ? 1<<9 : 0)
               );

    delay( 10 );
  }

  sensorZ0 += target.average;

  for( i=10 ; i>0 ; i-- ) {
    display_set( (1<<DISPLAY_LED_COUNT)-1 );
    delay( 30 );
    display_clear();
    delay( 70 );
  }
  delay( 200 );
 
}

#endif // __SENSOR_H_
