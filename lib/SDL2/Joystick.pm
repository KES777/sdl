package SDL2::Joystick;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_error.h"
use SDL2::Stdinc;
use SDL2::Error;


my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# struct _SDL_Joystick;
	# typedef struct _SDL_Joystick SDL_Joystick;
	$ffi->type( 'opaque' => 'SDL_Joystick_ptr' );           #struct
	$ffi->type( 'opaque' => 'SDL_JoystickGUID_ptr' );       #struct

	# typedef Sint32 SDL_JoystickID;
	$ffi->type( 'sint32' => 'SDL_JoystickID' );

	$ffi->type( 'int' => 'SDL_JoystickType' );              #enum
	$ffi->type( 'int' => 'SDL_JoystickPowerLevel' );        #enum

	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );

	# extern DECLSPEC void SDLCALL SDL_LockJoysticks(void);
	$ffi->attach( SDL_LockJoysticks => [ 'void'  ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_UnlockJoysticks(void);
	$ffi->attach( SDL_UnlockJoysticks => [ 'void'  ] => 'void' );

	# extern DECLSPEC int SDLCALL SDL_NumJoysticks(void);
	$ffi->attach( SDL_NumJoysticks => [ 'void'  ] => 'int' );

	# extern DECLSPEC const char *SDLCALL SDL_JoystickNameForIndex(int device_index);
	$ffi->attach( SDL_JoystickNameForIndex => [ 'int'  ] => 'string' );

	# extern DECLSPEC int SDLCALL SDL_JoystickGetDevicePlayerIndex(int device_index);
	$ffi->attach( SDL_JoystickGetDevicePlayerIndex => [ 'int'  ] => 'int' );

	# extern DECLSPEC SDL_JoystickGUID SDLCALL SDL_JoystickGetDeviceGUID(int device_index);
	$ffi->attach( SDL_JoystickGetDeviceGUID => [ 'int'  ] => 'SDL_JoystickGUID_ptr' );

	# extern DECLSPEC Uint16 SDLCALL SDL_JoystickGetDeviceVendor(int device_index);
	$ffi->attach( SDL_JoystickGetDeviceVendor => [ 'int'  ] => 'uint16' );

	# extern DECLSPEC Uint16 SDLCALL SDL_JoystickGetDeviceProduct(int device_index);
	$ffi->attach( SDL_JoystickGetDeviceProduct => [ 'int'  ] => 'uint16' );

	# extern DECLSPEC Uint16 SDLCALL SDL_JoystickGetDeviceProductVersion(int device_index);
	$ffi->attach( SDL_JoystickGetDeviceProductVersion => [ 'int'  ] => 'uint16' );

	# extern DECLSPEC SDL_JoystickType SDLCALL SDL_JoystickGetDeviceType(int device_index);
	$ffi->attach( SDL_JoystickGetDeviceType => [ 'int'  ] => 'SDL_JoystickType' );

	# extern DECLSPEC SDL_JoystickID SDLCALL SDL_JoystickGetDeviceInstanceID(int device_index);
	$ffi->attach( SDL_JoystickGetDeviceInstanceID => [ 'int'  ] => 'SDL_JoystickID' );

	# extern DECLSPEC SDL_Joystick *SDLCALL SDL_JoystickOpen(int device_index);
	$ffi->attach( SDL_JoystickOpen => [ 'int'  ] => 'SDL_Joystick_ptr' );

	# extern DECLSPEC SDL_Joystick *SDLCALL SDL_JoystickFromInstanceID(SDL_JoystickID joyid);
	$ffi->attach( SDL_JoystickFromInstanceID => [ 'SDL_JoystickID'  ] => 'SDL_Joystick_ptr' );

	# extern DECLSPEC const char *SDLCALL SDL_JoystickName(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickName => [ 'SDL_Joystick_ptr'  ] => 'string' );

	# extern DECLSPEC int SDLCALL SDL_JoystickGetPlayerIndex(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickGetPlayerIndex => [ 'SDL_Joystick_ptr'  ] => 'int' );

	# extern DECLSPEC SDL_JoystickGUID SDLCALL SDL_JoystickGetGUID(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickGetGUID => [ 'SDL_Joystick_ptr'  ] => 'SDL_JoystickGUID_ptr' );

	# extern DECLSPEC Uint16 SDLCALL SDL_JoystickGetVendor(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickGetVendor => [ 'SDL_Joystick_ptr'  ] => 'uint16' );

	# extern DECLSPEC Uint16 SDLCALL SDL_JoystickGetProduct(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickGetProduct => [ 'SDL_Joystick_ptr'  ] => 'uint16' );

	# extern DECLSPEC Uint16 SDLCALL SDL_JoystickGetProductVersion(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickGetProductVersion => [ 'SDL_Joystick_ptr'  ] => 'uint16' );

	# extern DECLSPEC SDL_JoystickType SDLCALL SDL_JoystickGetType(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickGetType => [ 'SDL_Joystick_ptr'  ] => 'SDL_JoystickType' );

	# extern DECLSPEC void SDLCALL SDL_JoystickGetGUIDString(SDL_JoystickGUID guid, char *pszGUID, int cbGUID);
	$ffi->attach( SDL_JoystickGetGUIDString => [ 'SDL_JoystickGUID_ptr', 'string', 'int' ] => 'void' );

	# extern DECLSPEC SDL_JoystickGUID SDLCALL SDL_JoystickGetGUIDFromString(const char *pchGUID);
	$ffi->attach( SDL_JoystickGetGUIDFromString => [ 'string' ] => 'SDL_JoystickGUID_ptr' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_JoystickGetAttached(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickGetAttached => [ 'SDL_Joystick_ptr'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_JoystickID SDLCALL SDL_JoystickInstanceID(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickInstanceID => [ 'SDL_Joystick_ptr'  ] => 'SDL_JoystickID' );

	# extern DECLSPEC int SDLCALL SDL_JoystickNumAxes(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickNumAxes => [ 'SDL_Joystick_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_JoystickNumBalls(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickNumBalls => [ 'SDL_Joystick_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_JoystickNumHats(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickNumHats => [ 'SDL_Joystick_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_JoystickNumButtons(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickNumButtons => [ 'SDL_Joystick_ptr'  ] => 'int' );

	# extern DECLSPEC void SDLCALL SDL_JoystickUpdate(void);
	$ffi->attach( SDL_JoystickUpdate => [ 'void'  ] => 'void' );

	# extern DECLSPEC int SDLCALL SDL_JoystickEventState(int state);
	$ffi->attach( SDL_JoystickEventState => [ 'int'  ] => 'int' );

	#define SDL_JOYSTICK_AXIS_MAX   32767
	#define SDL_JOYSTICK_AXIS_MIN   -32768
	use constant SDL_JOYSTICK_AXIS_MAX  => 32767;
	use constant SDL_JOYSTICK_AXIS_MIN  => -32768;

	# extern DECLSPEC Sint16 SDLCALL SDL_JoystickGetAxis(SDL_Joystick * joystick,
	#                                                    int axis);
	$ffi->attach( SDL_JoystickGetAxis => [ 'SDL_Joystick_ptr', 'int'  ] => 'sint16' );

# ?????????????????'sint16'
	# extern DECLSPEC SDL_bool SDLCALL SDL_JoystickGetAxisInitialState(SDL_Joystick * joystick,
	#                                                    int axis, Sint16 *state);
	$ffi->attach( SDL_JoystickGetAxisInitialState => [ 'SDL_Joystick_ptr', 'int', 'sint16*' ] => 'SDL_bool' );

	#define SDL_HAT_CENTERED    0x00
	#define SDL_HAT_UP          0x01
	#define SDL_HAT_RIGHT       0x02
	#define SDL_HAT_DOWN        0x04
	#define SDL_HAT_LEFT        0x08
	#define SDL_HAT_RIGHTUP     (SDL_HAT_RIGHT|SDL_HAT_UP)
	#define SDL_HAT_RIGHTDOWN   (SDL_HAT_RIGHT|SDL_HAT_DOWN)
	#define SDL_HAT_LEFTUP      (SDL_HAT_LEFT|SDL_HAT_UP)
	#define SDL_HAT_LEFTDOWN    (SDL_HAT_LEFT|SDL_HAT_DOWN)
	use constant SDL_HAT_CENTERED  =>  0x00;
	use constant SDL_HAT_UP        =>  0x01;
	use constant SDL_HAT_RIGHT     =>  0x02;
	use constant SDL_HAT_DOWN      =>  0x04;
	use constant SDL_HAT_LEFT      =>  0x08;
	use constant SDL_HAT_RIGHTUP   =>  (SDL_HAT_RIGHT|SDL_HAT_UP);
	use constant SDL_HAT_RIGHTDOWN =>  (SDL_HAT_RIGHT|SDL_HAT_DOWN);
	use constant SDL_HAT_LEFTUP    =>  (SDL_HAT_LEFT|SDL_HAT_UP);
	use constant SDL_HAT_LEFTDOWN  =>  (SDL_HAT_LEFT|SDL_HAT_DOWN);


	# extern DECLSPEC Uint8 SDLCALL SDL_JoystickGetHat(SDL_Joystick * joystick,
	#                                                  int hat);
	$ffi->attach( SDL_JoystickGetHat => [ 'SDL_Joystick_ptr', 'int' ] => 'uint8' );

	# extern DECLSPEC int SDLCALL SDL_JoystickGetBall(SDL_Joystick * joystick,
	#                                                 int ball, int *dx, int *dy);
	$ffi->attach( SDL_JoystickGetBall => [ 'SDL_Joystick_ptr', 'int', 'int*', 'int*' ] => 'int' );

	# extern DECLSPEC Uint8 SDLCALL SDL_JoystickGetButton(SDL_Joystick * joystick,
	#                                                     int button);
	$ffi->attach( SDL_JoystickGetButton => [ 'SDL_Joystick_ptr', 'int' ] => 'uint8' );

	# extern DECLSPEC int SDLCALL SDL_JoystickRumble(SDL_Joystick * joystick, Uint16 low_frequency_rumble, Uint16 high_frequency_rumble, Uint32 duration_ms);
	$ffi->attach( SDL_JoystickRumble => [ 'SDL_Joystick_ptr', 'uint16', 'uint16', 'uint32' ] => 'int' );

	# extern DECLSPEC void SDLCALL SDL_JoystickClose(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickClose => [ 'SDL_Joystick_ptr' ] => 'void' );

	# extern DECLSPEC SDL_JoystickPowerLevel SDLCALL SDL_JoystickCurrentPowerLevel(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickCurrentPowerLevel => [ 'SDL_Joystick_ptr' ] => 'SDL_JoystickPowerLevel' );

}

1;
