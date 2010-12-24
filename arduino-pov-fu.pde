/********************************************************
 * A little POV test
 */


/**********************************************************************
 * Animation handling
 */
 
#include <avr/pgmspace.h>

#define ANIM_XSIZE 32
#define ANIM_YSIZE 10
#define ANIM_FRAMES 99
#define ANIM_LENGTH (6*16+97)

static int animSequence[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
  0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
  0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
  0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
  0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
  0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
  2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98
};

//2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203

PROGMEM prog_uint16_t pgmAnimData[] = {
  0,0,0,0,0,0,0,0,0,0,224,48,250,364,376,120,120,376,364,250,48,224,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,60,368,250,108,120,120,120,120,108,250,368,60,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,28,224,768,224,28,7,28,224,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,28,224,768,224,28,7,28,224,768,224,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,28,224,768,224,28,7,28,224,768,224,28,3,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,28,224,768,224,28,7,28,224,768,224,28,3,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,3,28,224,768,224,28,7,28,224,768,224,28,3,0,0,1023,529,0,0,
  0,0,0,0,0,0,0,0,0,0,0,3,28,224,768,224,28,7,28,224,768,224,28,3,0,0,1023,529,529,529,0,0,
  0,0,0,0,0,0,0,0,0,3,28,224,768,224,28,7,28,224,768,224,28,3,0,0,1023,529,529,529,529,529,0,0,
  0,0,0,0,0,0,0,3,28,224,768,224,28,7,28,224,768,224,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,
  0,0,0,0,0,3,28,224,768,224,28,7,28,224,768,224,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,
  0,0,0,3,28,224,768,224,28,7,28,224,768,224,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,
  0,0,28,224,768,224,28,7,28,224,768,224,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,0,
  0,0,768,224,28,7,28,224,768,224,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,120,390,0,0,
  0,0,28,7,28,224,768,224,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,120,390,258,513,0,0,
  0,0,28,224,768,224,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,120,390,258,513,513,513,0,0,
  0,0,768,224,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,
  0,0,28,3,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,0,0,
  0,0,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,120,390,0,0,
  0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,120,390,258,513,0,0,
  0,0,529,529,529,529,529,0,0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,120,390,258,513,513,513,0,0,
  0,0,529,529,529,0,0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,120,390,258,513,513,513,258,390,0,0,
  0,0,529,0,0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,120,390,258,513,513,513,258,390,120,0,0,0,
  0,0,0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,120,390,258,513,513,513,258,390,120,0,0,1023,0,0,
  0,0,0,0,0,0,120,390,258,513,513,513,769,386,0,0,120,390,258,513,513,513,258,390,120,0,0,1023,3,12,0,0,
  0,0,0,0,120,390,258,513,513,513,769,386,0,0,120,390,258,513,513,513,258,390,120,0,0,1023,3,12,48,96,0,0,
  0,0,120,390,258,513,513,513,769,386,0,0,120,390,258,513,513,513,258,390,120,0,0,1023,3,12,48,96,48,12,0,0,
  0,0,258,513,513,513,769,386,0,0,120,390,258,513,513,513,258,390,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,
  0,0,513,513,769,386,0,0,120,390,258,513,513,513,258,390,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,0,0,
  0,0,769,386,0,0,120,390,258,513,513,513,258,390,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,1023,529,0,0,
  0,0,0,0,120,390,258,513,513,513,258,390,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,1023,529,529,529,0,0,
  0,0,120,390,258,513,513,513,258,390,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,1023,529,529,529,529,529,0,0,
  0,0,258,513,513,513,258,390,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,
  0,0,513,513,258,390,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,
  0,0,258,390,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,
  0,0,120,0,0,1023,3,12,48,96,48,12,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,0,
  0,0,0,1023,3,12,48,96,48,12,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,513,1023,0,0,
  0,0,3,12,48,96,48,12,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,513,1023,513,0,0,0,
  0,0,48,96,48,12,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,513,1023,513,0,0,1023,0,0,
  0,0,48,12,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,0,0,
  0,0,3,1023,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,0,0,
  0,0,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,0,0,
  0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,
  0,0,529,529,529,529,529,0,0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,
  0,0,529,529,529,0,0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,
  0,0,529,0,0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,1023,33,0,0,
  0,0,0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,1023,33,33,33,0,0,
  0,0,0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,1023,33,33,33,33,18,0,0,
  0,0,513,1023,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,1023,33,33,33,33,18,12,0,0,0,
  0,0,513,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,0,0,
  0,0,0,1023,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,0,0,
  0,0,3,4,24,96,128,768,1023,0,0,0,0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,529,529,0,0,
  0,0,24,96,128,768,1023,0,0,0,0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,529,529,529,0,0,0,
  0,0,128,768,1023,0,0,0,0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,529,529,529,0,768,192,0,0,
  0,0,1023,0,0,0,0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,529,529,529,0,768,192,120,70,0,0,
  0,0,0,0,0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,529,529,529,0,768,192,120,70,65,65,0,0,
  0,0,0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,529,529,529,0,768,192,120,70,65,65,70,120,0,0,
  0,0,0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,529,529,529,0,768,192,120,70,65,65,70,120,192,768,0,0,
  0,0,1023,33,33,33,33,18,12,0,1023,529,529,529,529,529,529,0,768,192,120,70,65,65,70,120,192,768,0,120,0,0,
  0,0,33,33,33,18,12,0,1023,529,529,529,529,529,529,0,768,192,120,70,65,65,70,120,192,768,0,120,390,258,0,0,
  0,0,33,18,12,0,1023,529,529,529,529,529,529,0,768,192,120,70,65,65,70,120,192,768,0,120,390,258,513,513,0,0,
  0,0,12,0,1023,529,529,529,529,529,529,0,768,192,120,70,65,65,70,120,192,768,0,120,390,258,513,513,513,769,0,0,
  0,0,1023,529,529,529,529,529,529,0,768,192,120,70,65,65,70,120,192,768,0,120,390,258,513,513,513,769,386,0,0,0,
  0,0,529,529,529,529,529,0,768,192,120,70,65,65,70,120,192,768,0,120,390,258,513,513,513,769,386,0,0,1023,0,0,
  0,0,529,529,529,0,768,192,120,70,65,65,70,120,192,768,0,120,390,258,513,513,513,769,386,0,0,1023,529,529,0,0,
  0,0,529,0,768,192,120,70,65,65,70,120,192,768,0,120,390,258,513,513,513,769,386,0,0,1023,529,529,529,529,0,0,
  0,0,768,192,120,70,65,65,70,120,192,768,0,120,390,258,513,513,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,
  0,0,120,70,65,65,70,120,192,768,0,120,390,258,513,513,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,
  0,0,65,65,70,120,192,768,0,120,390,258,513,513,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,
  0,0,70,120,192,768,0,120,390,258,513,513,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,
  0,0,192,768,0,120,390,258,513,513,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,0,0,
  0,0,0,120,390,258,513,513,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,895,0,0,0,
  0,0,390,258,513,513,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,895,0,0,0,0,0,
  0,0,513,513,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,895,0,0,0,0,0,0,0,
  0,0,513,769,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,
  0,0,386,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,
  0,0,0,1023,529,529,529,529,529,529,0,0,0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,0,0,
  0,0,529,529,529,529,529,529,0,0,0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,
  0,0,529,529,529,529,0,0,0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,
  0,0,529,529,0,0,0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,514,514,0,0,
  0,0,0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,514,514,1023,512,0,0,
  0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,
  0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,0,
  0,0,895,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,514,0,0,
  0,0,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,0,0,
  0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,
  0,0,895,0,0,0,0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,
  0,0,0,0,0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,0,0,
  0,0,0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,
  0,0,895,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,0,0,
  0,0,0,0,0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,0,0,0,0,
  0,0,0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,0,0,895,0,0,0,
  0,0,514,514,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,
  0,0,1023,512,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,0,0,
  0,0,512,0,0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,514,514,1023,512,512,0,0,0,0,895,0,0,0,0,0,895,0,0,0,0,0,0,0,0,0,0,0,0,0
};

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

const int ledPins = 2;              // PWM pin for LED

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

int bar_update_required() {
  return( (micros()-animPrevBarUpdate) >= animRowDuration );
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

int idle_timeout() {
  return( micros() - swingStateTime[swingState] >= SWING_IDLE_TIMEOUT );
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


