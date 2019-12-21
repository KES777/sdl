package SDL2::Touch;

use strict;
use warnings;


use SDL2::Stdinc;
use SDL2::Error;
use SDL2::Video;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;


	my( $ffi ) =  @_;

	# typedef Sint64 SDL_TouchID;
	# typedef Sint64 SDL_FingerID;
	$ffi->type( 'sint64' => 'SDL_TouchID' );
	$ffi->type( 'sint64' => 'SDL_FingerID' );

	$ffi->type( 'int'    => 'SDL_TouchDeviceType' );     #enum
	$ffi->type( 'opaque' => 'SDL_Finger_ptr' );          #struct


# ????????????????((Uint32)-1)
	# define SDL_TOUCH_MOUSEID ((Uint32)-1)
	use constant SDL_TOUCH_MOUSEID   => '((Uint32)-1)';

	# define SDL_MOUSE_TOUCHID ((Sint64)-1)
	use constant SDL_MOUSE_TOUCHID   => '((Sint64)-1)';




	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );
	SDL2::Video::attach( $ffi );

	$ffi->attach( SDL_GetNumTouchDevices => [ 'void'  ] => 'int' );

	# extern DECLSPEC SDL_TouchID SDLCALL SDL_GetTouchDevice(int index);
	$ffi->attach( SDL_GetTouchDevice => [ 'int'  ] => 'SDL_TouchID' );

	# extern DECLSPEC SDL_TouchDeviceType SDLCALL SDL_GetTouchDeviceType(SDL_TouchID touchID);
	$ffi->attach( SDL_GetTouchDeviceType => [ 'SDL_TouchID'  ] => 'SDL_TouchDeviceType' );

	# extern DECLSPEC int SDLCALL SDL_GetNumTouchFingers(SDL_TouchID touchID);
	$ffi->attach( SDL_GetNumTouchFingers => [ 'SDL_TouchID'  ] => 'int' );

	# extern DECLSPEC SDL_Finger * SDLCALL SDL_GetTouchFinger(SDL_TouchID touchID, int index);
	$ffi->attach( SDL_GetTouchFinger => [ 'SDL_TouchID', 'int'  ] => 'SDL_Finger_ptr' );

}

1;
