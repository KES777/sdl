package SDL2::Loadso;

use strict;
use warnings;


use SDL2::Stdinc;
use SDL2::Error;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );

	# extern DECLSPEC void *SDLCALL SDL_LoadObject(const char *sofile);
	$ffi->attach( SDL_LoadObject => [ 'string' ] => 'opaque' );

	# extern DECLSPEC void *SDLCALL SDL_LoadFunction(void *handle,
	#                                                const char *name);
	$ffi->attach( SDL_LoadFunction => [ 'opaque', 'string' ] => 'opaque' );

	# extern DECLSPEC void SDLCALL SDL_UnloadObject(void *handle);
	$ffi->attach( SDL_UnloadObject => [ 'opaque' ] => 'void' );

}

1;
