package SDL2::Keycode;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_scancode.h"
use SDL2::Stdinc;
use SDL2::Scancode;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# typedef Sint32 SDL_Keycode;
	$ffi->type( 'sint32' => 'SDL_Keycode' );


	$ffi->type( 'int' => 'SDL_Keymod' );      #enum

	SDL2::Stdinc::attach( $ffi );
	SDL2::Scancode::attach( $ffi );

}

1;
