package SDL2::Rwops;

use strict;
use warnings;


sub attach {

	my( $ffi ) =  @_;

	$ffi->type( 'opaque' => 'SDL_RWops_ptr' );

}

1;
