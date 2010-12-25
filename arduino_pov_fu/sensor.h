/**********************************************************************
 * Sensor handling
 */

#ifndef __SENSOR_H_
#define __SENSOR_H_

// unsure why this is required in an include file
#include "WProgram.h"

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

void sensor_calibrate() {
  int i;
  float x0, y0, z0;

  // wait for any button-press movement to settle
  delay( 50 );

  for( i=20 ; i>0 ; i-- ) {
    x0 += analogRead( sensorXPin );
    y0 += analogRead( sensorYPin );
    z0 += analogRead( sensorZPin );
    delay( 10 );
  }
  x0/=20.0;
  y0/=20.0;
  z0/=20.0;

  sensorX0 = x0;
  sensorY0 = y0;
  sensorZ0 = z0;
}

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

#endif // __SENSOR_H_
