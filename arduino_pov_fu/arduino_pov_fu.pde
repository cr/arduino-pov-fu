/********************************************************
 * A little Arduino POV-fu
 * by Christiane Ruetten, cr@23bit.net
 */

#include <avr/pgmspace.h>

/**********************************************************************
 * Animation handling
 */
 
#include "anim_data.h"

const int animXSize = ANIM_XSIZE;
const int animYSize = ANIM_YSIZE;
const int animFrames = ANIM_FRAMES;
const int animLength = ANIM_LENGTH;
int animSequenceCounter = 0;

int animFrame = 0;
int animXPos = 0;

long animPrevBarUpdate = 0;
long animRowDuration = 15625;
long animFrameDuration = 250000;

#define ANIM_FORWARD 0
#define ANIM_BACKWARD 1
char animSwingDirection = ANIM_FORWARD;

const int ledPins = 2;

int anim_data_read() {
  return pgm_read_word( pgmAnimData
    + animFrame*animXSize + animXPos ); 
}

void update_bar() {
  int value = anim_data_read();
  int pin;
  int bitmask;
  for( pin=ledPins, bitmask=1 ; pin<ledPins+10 ; pin++, bitmask*=2 ) {
    if( value&bitmask ) {
      digitalWrite( pin, HIGH );
    } else {
      digitalWrite( pin, LOW );
    }
  }
  animPrevBarUpdate = micros();
}

void clear_bar() {
  int pin;
  for( pin=ledPins ; pin<ledPins+10 ; pin++ ) {
    digitalWrite( pin, LOW );
  }
  animPrevBarUpdate = micros();
}

int bar_update_required() {
  return( (micros()-animPrevBarUpdate) >= animRowDuration );
}

void advance_frame() {
  animSequenceCounter = (animSequenceCounter+1) % animLength;
  animFrame = animSequence[animSequenceCounter];
  animXPos = (animSwingDirection == ANIM_FORWARD) ? 0 : (animXSize-1);
}

void advance_row() {
  if( animSwingDirection == ANIM_FORWARD ) {
    if( animXPos < animXSize - 1 ) animXPos++;
  } else {
    if( animXPos > 0 ) animXPos--;
  }
}

void anim_reset() {
  animSequenceCounter = 0; 
}

/**********************************************************************
 * Sensor handling
 */

// ADXL330 in analog mode
const int sensorXPin = A0;
const int sensorYPin = A1;

float sensorX0 = 0;
float sensorY0 = 0;
float sensorX = 0;
float sensorY = 0;
float sensorPrevX = 0;
float sensorPrevY = 0;

void calibrate_sensor() {
  int i;
  float x0, y0;

  // wait for any button-press movement to settle
  delay( 50 );

  for( i=20 ; i>0 ; i-- ) {
    x0 += analogRead( sensorXPin );
    y0 += analogRead( sensorYPin );
    delay( 10 );
  }
  x0/=20.0;
  y0/=20.0;

  Serial.print( "Calibrated (0,0) at (" );
  Serial.print( x0 );
  Serial.print(", ");
  Serial.print( y0 );
  Serial.println(")"); 

  sensorX0 = x0;
  sensorY0 = y0;
  
}

void read_sensor() {
  float xr, yr;
  sensorPrevX = sensorX;
  sensorPrevY = sensorY;
  xr = analogRead( A0 ) - sensorX0;
  yr = analogRead( A1 ) - sensorY0;
  sensorX = 0.707107 * (xr - yr);
  sensorY = 0.707107 * (xr + yr);
}

/**********************************************************************
 * State machine
 */

// Swing state machine states
// cave: used for array indexing
#define SWING_IDLE 0
#define SWING_POSITIVE 1
#define SWING_POSITIVE_MAX 2
#define SWING_POSITIVE_ZERO 3
#define SWING_NEGATIVE 4
#define SWING_NEGATIVE_MAX 5
#define SWING_NEGATIVE_ZERO 6

#define SWING_THRESHOLD 100
#define SWING_IDLE_TIMEOUT 300000

int swingState;
long swingStateTime[8];

void set_state( int state ) {
   swingState = state;
   swingStateTime[state] = micros();
}

int positive_threshold_passed() {
  return( (sensorPrevX < SWING_THRESHOLD) && (sensorX >= SWING_THRESHOLD) );
}

int positive_max_passed() {
  return( sensorPrevX > sensorX );
}

int positive_zero_passed() {
  return( (sensorPrevX > 0) && (sensorX <= 0) );
}

int negative_threshold_passed() {
  return( (sensorPrevX > -SWING_THRESHOLD) && (sensorX <= -SWING_THRESHOLD) );
}

int negative_max_passed() {
  return( sensorPrevX < sensorX );
}

int negative_zero_passed() {
  return( (sensorPrevX < 0) && (sensorX >= 0) );
}

int idle_timeout() {
  return( micros() - swingStateTime[swingState] >= SWING_IDLE_TIMEOUT );
}

int left_frame_sync() {
   animFrameDuration = abs(swingStateTime[SWING_POSITIVE_MAX] - swingStateTime[SWING_NEGATIVE_MAX]);
   animRowDuration = 0.99 * animFrameDuration / animXSize;
   animSwingDirection = ANIM_FORWARD;
   advance_frame();
   // force update on next state cycle
   animPrevBarUpdate = 0;
}

int right_frame_sync() {
   animFrameDuration = abs(swingStateTime[SWING_POSITIVE_MAX] - swingStateTime[SWING_NEGATIVE_MAX]);
   animRowDuration = 0.99 * animFrameDuration / animXSize;
   animSwingDirection = ANIM_BACKWARD;
   advance_frame();
   // force update on next state cycle
   animPrevBarUpdate = 0;
}

/**********************************************************************
 * Setup function
 */

void setup() {
  Serial.begin( 115200 );

  int pin;
  for( pin=ledPins ; pin<ledPins+10 ; pin++ ) {
    pinMode( pin, OUTPUT );
    digitalWrite( pin, HIGH );
    delay( 20 );
    digitalWrite( pin, LOW );
  }

  calibrate_sensor();

  for( pin=ledPins+9 ; pin>=ledPins ; pin-- ) {
    digitalWrite( pin, HIGH );
    delay( 20 );
    digitalWrite( pin, LOW );
  }

  set_state( SWING_IDLE );

 /* Sensor sampling test code
  delay(3000);
  int i;
  for( i=0 ; i<1000 ; i++ ) {
    read_sensor();
    Serial.print(micros());
    Serial.print(" ");
    Serial.println(sensorX);
  }  
  delay(30000);
  */
  
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
  read_sensor();

  switch( swingState ) {

    case SWING_IDLE:
      if( positive_threshold_passed() ) set_state( SWING_POSITIVE );
      else if( negative_threshold_passed() ) set_state( SWING_NEGATIVE );
      anim_reset();
      delay(10);
      break;

    case SWING_POSITIVE:
      if( positive_max_passed() ) {
        set_state( SWING_POSITIVE_MAX );
        right_frame_sync();
      } 
      break;

    case SWING_POSITIVE_MAX:
      if( positive_zero_passed() ) {
        set_state( SWING_POSITIVE_ZERO );
      }
      break;

    case SWING_POSITIVE_ZERO:
      if( idle_timeout() ) set_state( SWING_IDLE );
      else if( negative_threshold_passed() ) {
        set_state( SWING_NEGATIVE );
      }
      break;

    case SWING_NEGATIVE:
      if( negative_max_passed() ) {
        set_state( SWING_NEGATIVE_MAX );
        left_frame_sync();
      } 
      break;

    case SWING_NEGATIVE_MAX:
      if( negative_zero_passed() ) {
        set_state( SWING_NEGATIVE_ZERO );
      }
      break;

    case SWING_NEGATIVE_ZERO:
      if( idle_timeout() ) set_state( SWING_IDLE );
      else if( positive_threshold_passed() ) {
        set_state( SWING_POSITIVE );
      }
      break;

  }
  
}



