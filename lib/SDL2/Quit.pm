package SDL2::Quit;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_error.h"
use SDL2::Stdinc;
use SDL2::Error;


#define SDL_QuitRequested() (SDL_PumpEvents(), (SDL_PeepEvents(NULL,0,SDL_PEEKEVENT,SDL_QUIT,SDL_QUIT) > 0))
# sub SDL_QuitRequested {
# 	SDL_PumpEvents();

# 	return (SDL_PeepEvents(NULL,0,SDL_PEEKEVENT,SDL_QUIT,SDL_QUIT) > 0);
# }

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );

}

1;
