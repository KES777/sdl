package SDL2::Blendmode;

use strict;
use warnings;


sub attach {

	my( $ffi ) =  @_;

	$ffi->type( 'opaque' => 'SDL_BlendMode_ptr' );

}

1;
