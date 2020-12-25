package SDL2::Error;

use strict;
use warnings;


my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# extern DECLSPEC int SDLCALL SDL_SetError(SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(1);
	# extern DECLSPEC const char *SDLCALL SDL_GetError(void);
	$ffi->attach( SDL_GetError => [ 'void' ] => 'string' );



	# extern DECLSPEC void SDLCALL SDL_ClearError(void);


}

1;
