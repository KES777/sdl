package SDL2::Stdinc;

use strict;
use warnings;


sub attach {
	my( $ffi ) =  @_;

	$ffi->type( 'opaque' => 'SDL_bool_ptr' );

}

1;
