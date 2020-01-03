package SDL2::Filesystem;

use strict;
use warnings;


use SDL2::Stdinc;


my $processed;
sub attach {
	!$processed   or return;
	$processed++;


	my( $ffi ) =  @_;

	SDL2::Stdinc::attach( $ffi );


	# extern DECLSPEC char *SDLCALL SDL_GetBasePath(void);
	$ffi->attach( SDL_GetBasePath => [ 'void'  ] => 'string' );

	# extern DECLSPEC char *SDLCALL SDL_GetPrefPath(const char *org, const char *app);
	$ffi->attach( SDL_GetPrefPath => [ 'string', 'string'  ] => 'string' );


}

1;
