package SDL2::Gesture;

use strict;
use warnings;

use SDL2::Stdinc;
use SDL2::Error;
use SDL2::Video;
use SDL2::Touch;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;


	my( $ffi ) =  @_;


# ??????????????????
	# typedef Sint64 SDL_GestureID;
	$ffi->type( 'sint64' => 'SDL_GestureID' );


	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );
	SDL2::Video::attach( $ffi );
	SDL2::Touch::attach( $ffi );


	# extern DECLSPEC int SDLCALL SDL_RecordGesture(SDL_TouchID touchId);
	$ffi->attach( SDL_RecordGesture => [ 'SDL_TouchID'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_SaveAllDollarTemplates(SDL_RWops *dst);
	$ffi->attach( SDL_SaveAllDollarTemplates => [ 'SDL_RWops_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_SaveDollarTemplate(SDL_GestureID gestureId,SDL_RWops *dst);
	$ffi->attach( SDL_SaveDollarTemplate => [ 'SDL_GestureID', 'SDL_RWops_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_LoadDollarTemplates(SDL_TouchID touchId, SDL_RWops *src);
	$ffi->attach( SDL_LoadDollarTemplates => [ 'SDL_TouchID', 'SDL_RWops_ptr' ] => 'int' );


}

1;
