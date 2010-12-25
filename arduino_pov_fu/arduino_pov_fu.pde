/********************************************************
 * A little Arduino POV-fu
 * by Christiane Ruetten, cr@23bit.net
 */

#include "sensor.h"
#include "state_machine.h"
#include "anim.h"

/**********************************************************************
 * Setup function
 */

void setup() {
  Serial.begin( 115200 );

  pinMode( 12, INPUT );

  int pin;
  for( pin=ledPins ; pin<ledPins+10 ; pin++ ) {
    pinMode( pin, OUTPUT );
    digitalWrite( pin, HIGH );
    delay( 20 );
    digitalWrite( pin, LOW );
  }

  sensor_calibrate();

  Serial.print( "Calibrated (0,0,-1) at (" );
  Serial.print( sensorX0 );
  Serial.print(",");
  Serial.print( sensorY0 );
  Serial.print(",");
  Serial.print( sensorZ0 );
  Serial.println(")"); 

  for( pin=ledPins+9 ; pin>=ledPins ; pin-- ) {
    digitalWrite( pin, HIGH );
    delay( 20 );
    digitalWrite( pin, LOW );
  }

  set_state( SWING_IDLE );

 // Sensor sampling test code
  delay(3000);
  int i;
  for( i=0 ; i<10000 ; i++ ) {
    sensor_read();
    Serial.print( micros() );
    Serial.print( " " );
    Serial.print( sensorX );
    Serial.print( " " );
    Serial.print( sensorY );
    Serial.print( " " );
    Serial.println( sensorZ );
  }  
  delay(300000);
  
}


/**********************************************************************
 * Main loop
 */

void loop() {

  if( swingState != SWING_IDLE ) {
    if( bar_update_required() ) {
      update_bar();
      advance_row();
    }
  } else {
    clear_bar();
  }

  // update sensor reading
  sensor_read();

  state_machine();
  
}



