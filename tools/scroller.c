#include <stdio.h>

#include "peace_verdana.h"

#define SCREEN_X 32
#define SCREEN_Y 10
#define BORDER_X 2
#define SCROLL_SPEED 3

void dumpframe(int x, int y) {
	int sx, sy;
	printf("  ");
	for( sx=0 ; sx<BORDER_X ; sx++ ) {
		printf( "0," );
	}
	for( sx=0 ; sx<SCREEN_X-2*BORDER_X ; sx++ ) {
		printf( "%d,",
			  header_data[(y+0)*width+x+sx]
			+ header_data[(y+1)*width+x+sx]*2
			+ header_data[(y+2)*width+x+sx]*4
			+ header_data[(y+3)*width+x+sx]*8
			+ header_data[(y+4)*width+x+sx]*16
			+ header_data[(y+5)*width+x+sx]*32
			+ header_data[(y+6)*width+x+sx]*64
			+ header_data[(y+7)*width+x+sx]*128
			+ header_data[(y+8)*width+x+sx]*256
			+ header_data[(y+9)*width+x+sx]*512
		);
	}
	for( sx=0 ; sx<BORDER_X ; sx++ ) {
		printf( "0," );
	}
	printf( "\n" );
}

int main() {
	int x, y, frames;
	y=0;
	frames=0;
	for( x=0 ; x<width-SCREEN_X-2*BORDER_X ; x+=SCROLL_SPEED ) {
		dumpframe(x, y);
		frames++;
	}
	printf( "# %d frames in total\n", frames );
	return 0;
}

