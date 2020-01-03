package SDL2::Scancode;

use strict;
use warnings;

use SDL2::Stdinc;

sub attach {

	my( $ffi ) =  @_;

	$ffi->type( 'int' => 'SDL_Scancode' );      #enum

	# SDL2::Stdinc::attach( $ffi );
}

1;
