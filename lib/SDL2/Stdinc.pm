package SDL2::Stdinc;

use strict;
use warnings;


my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# #define SDL_FALSE 0
	# #define SDL_TRUE 1
	use constant SDL_FALSE  => 0;
	use constant SDL_TRUE   => 1;

	# typedef int SDL_bool;
	$ffi->type( 'int' => 'SDL_bool' );   #enum

}

1;
