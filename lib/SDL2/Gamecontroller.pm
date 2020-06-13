package SDL2::Gamecontroller;

use strict;
use warnings;


#include "SDL_stdinc.h"
#include "SDL_error.h"
#include "SDL_rwops.h"
#include "SDL_joystick.h"
use SDL2::Stdinc;
use SDL2::Rwops;
use SDL2::Error;
use SDL2::Joystick;


my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;


	$ffi->type( 'opaque' => 'SDL_GameController_ptr' );               #struct


	# typedef enum
	# {
	#     SDL_CONTROLLER_BINDTYPE_NONE = 0,
	#     SDL_CONTROLLER_BINDTYPE_BUTTON,
	#     SDL_CONTROLLER_BINDTYPE_AXIS,
	#     SDL_CONTROLLER_BINDTYPE_HAT
	# } SDL_GameControllerBindType;
	$ffi->load_custom_type('::Enum', 'SDL_GameControllerBindType',
		{ ret => 'int', package => 'SDL2::Gamecontroller' },
		['SDL_CONTROLLER_BINDTYPE_NONE' => 0],
		'SDL_CONTROLLER_BINDTYPE_BUTTON',
		'SDL_CONTROLLER_BINDTYPE_AXIS',
		'SDL_CONTROLLER_BINDTYPE_HAT',
	);


	$ffi->type( 'opaque' => 'SDL_GameControllerButtonBind_ptr' );     #struct


	# typedef enum
	# {
	#     SDL_CONTROLLER_AXIS_INVALID = -1,
	#     SDL_CONTROLLER_AXIS_LEFTX,
	#     SDL_CONTROLLER_AXIS_LEFTY,
	#     SDL_CONTROLLER_AXIS_RIGHTX,
	#     SDL_CONTROLLER_AXIS_RIGHTY,
	#     SDL_CONTROLLER_AXIS_TRIGGERLEFT,
	#     SDL_CONTROLLER_AXIS_TRIGGERRIGHT,
	#     SDL_CONTROLLER_AXIS_MAX
	# } SDL_GameControllerAxis;
	$ffi->load_custom_type('::Enum', 'SDL_GameControllerAxis',
		{ ret => 'int', package => 'SDL2::Gamecontroller' },
		['SDL_CONTROLLER_AXIS_INVALID' => -1],
		'SDL_CONTROLLER_AXIS_LEFTX',
		'SDL_CONTROLLER_AXIS_LEFTY',
		'SDL_CONTROLLER_AXIS_RIGHTX',
		'SDL_CONTROLLER_AXIS_RIGHTY',
		'SDL_CONTROLLER_AXIS_TRIGGERLEFT',
		'SDL_CONTROLLER_AXIS_TRIGGERRIGHT',
		'SDL_CONTROLLER_AXIS_MAX',
	);

	# typedef enum
	# {
	#     SDL_CONTROLLER_BUTTON_INVALID = -1,
	#     SDL_CONTROLLER_BUTTON_A,
	#     SDL_CONTROLLER_BUTTON_B,
	#     SDL_CONTROLLER_BUTTON_X,
	#     SDL_CONTROLLER_BUTTON_Y,
	#     SDL_CONTROLLER_BUTTON_BACK,
	#     SDL_CONTROLLER_BUTTON_GUIDE,
	#     SDL_CONTROLLER_BUTTON_START,
	#     SDL_CONTROLLER_BUTTON_LEFTSTICK,
	#     SDL_CONTROLLER_BUTTON_RIGHTSTICK,
	#     SDL_CONTROLLER_BUTTON_LEFTSHOULDER,
	#     SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,
	#     SDL_CONTROLLER_BUTTON_DPAD_UP,
	#     SDL_CONTROLLER_BUTTON_DPAD_DOWN,
	#     SDL_CONTROLLER_BUTTON_DPAD_LEFT,
	#     SDL_CONTROLLER_BUTTON_DPAD_RIGHT,
	#     SDL_CONTROLLER_BUTTON_MAX
	# } SDL_GameControllerButton;
	$ffi->load_custom_type('::Enum', 'SDL_GameControllerButton',
		{ ret => 'int', package => 'SDL2::Gamecontroller' },
		['SDL_CONTROLLER_BUTTON_INVALID' => -1],
		'SDL_CONTROLLER_BUTTON_A',
		'SDL_CONTROLLER_BUTTON_B',
		'SDL_CONTROLLER_BUTTON_X',
		'SDL_CONTROLLER_BUTTON_Y',
		'SDL_CONTROLLER_BUTTON_BACK',
		'SDL_CONTROLLER_BUTTON_GUIDE',
		'SDL_CONTROLLER_BUTTON_START',
		'SDL_CONTROLLER_BUTTON_LEFTSTICK',
		'SDL_CONTROLLER_BUTTON_RIGHTSTICK',
		'SDL_CONTROLLER_BUTTON_LEFTSHOULDER',
		'SDL_CONTROLLER_BUTTON_RIGHTSHOULDER',
		'SDL_CONTROLLER_BUTTON_DPAD_UP',
		'SDL_CONTROLLER_BUTTON_DPAD_DOWN',
		'SDL_CONTROLLER_BUTTON_DPAD_LEFT',
		'SDL_CONTROLLER_BUTTON_DPAD_RIGHT',
		'SDL_CONTROLLER_BUTTON_MAX',
	);


	SDL2::Stdinc::attach( $ffi );
	SDL2::Rwops::attach( $ffi );
	SDL2::Error::attach( $ffi );
	SDL2::Joystick::attach( $ffi );


	# extern DECLSPEC int SDLCALL SDL_GameControllerAddMappingsFromRW(SDL_RWops * rw, int freerw);
	$ffi->attach( SDL_GameControllerAddMappingsFromRW => [ 'SDL_RWops_ptr', 'int'  ] => 'int' );


# ???????????????????
	#define SDL_GameControllerAddMappingsFromFile(file)   SDL_GameControllerAddMappingsFromRW(SDL_RWFromFile(file, "rb"), 1)


	# extern DECLSPEC int SDLCALL SDL_GameControllerAddMapping(const char* mappingString);
	$ffi->attach( SDL_GameControllerAddMapping => [ 'string'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_GameControllerNumMappings(void);
	$ffi->attach( SDL_GameControllerNumMappings => [ 'void'  ] => 'int' );

	# extern DECLSPEC char * SDLCALL SDL_GameControllerMappingForIndex(int mapping_index);
	$ffi->attach( SDL_GameControllerMappingForIndex => [ 'int'  ] => 'string' );

	# extern DECLSPEC char * SDLCALL SDL_GameControllerMappingForGUID(SDL_JoystickGUID guid);
	$ffi->attach( SDL_GameControllerMappingForGUID => [ 'SDL_JoystickGUID_ptr'  ] => 'string' );

	# extern DECLSPEC char * SDLCALL SDL_GameControllerMapping(SDL_GameController * gamecontroller);
	$ffi->attach( SDL_GameControllerMapping => [ 'SDL_GameController_ptr'  ] => 'string' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_IsGameController(int joystick_index);
	$ffi->attach( SDL_IsGameController => [ 'int'  ] => 'SDL_bool' );

	# extern DECLSPEC const char *SDLCALL SDL_GameControllerNameForIndex(int joystick_index);
	$ffi->attach( SDL_GameControllerNameForIndex => [ 'int'  ] => 'string' );

	# extern DECLSPEC char *SDLCALL SDL_GameControllerMappingForDeviceIndex(int joystick_index);
	$ffi->attach( SDL_GameControllerMappingForDeviceIndex => [ 'int'  ] => 'string' );

	# extern DECLSPEC SDL_GameController *SDLCALL SDL_GameControllerOpen(int joystick_index);
	$ffi->attach( SDL_GameControllerOpen => [ 'int'  ] => 'SDL_GameController_ptr' );

	# extern DECLSPEC SDL_GameController *SDLCALL SDL_GameControllerFromInstanceID(SDL_JoystickID joyid);
	$ffi->attach( SDL_GameControllerFromInstanceID => [ 'SDL_JoystickID'  ] => 'SDL_GameController_ptr' );

	# extern DECLSPEC const char *SDLCALL SDL_GameControllerName(SDL_GameController *gamecontroller);
	$ffi->attach( SDL_GameControllerName => [ 'SDL_GameController_ptr'  ] => 'string' );

	# extern DECLSPEC int SDLCALL SDL_GameControllerGetPlayerIndex(SDL_GameController *gamecontroller);
	$ffi->attach( SDL_GameControllerGetPlayerIndex => [ 'SDL_GameController_ptr'  ] => 'int' );

	# extern DECLSPEC Uint16 SDLCALL SDL_GameControllerGetVendor(SDL_GameController * gamecontroller);
	$ffi->attach( SDL_GameControllerGetVendor => [ 'SDL_GameController_ptr'  ] => 'uint16' );

	# extern DECLSPEC Uint16 SDLCALL SDL_GameControllerGetProduct(SDL_GameController * gamecontroller);
	$ffi->attach( SDL_GameControllerGetProduct => [ 'SDL_GameController_ptr'  ] => 'uint16' );

	# extern DECLSPEC Uint16 SDLCALL SDL_GameControllerGetProductVersion(SDL_GameController * gamecontroller);
	$ffi->attach( SDL_GameControllerGetProductVersion => [ 'SDL_GameController_ptr'  ] => 'uint16' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_GameControllerGetAttached(SDL_GameController *gamecontroller);
	$ffi->attach( SDL_GameControllerGetAttached => [ 'SDL_GameController_ptr'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_Joystick *SDLCALL SDL_GameControllerGetJoystick(SDL_GameController *gamecontroller);
	$ffi->attach( SDL_GameControllerGetJoystick => [ 'SDL_GameController_ptr'  ] => 'SDL_Joystick_ptr' );

	# extern DECLSPEC int SDLCALL SDL_GameControllerEventState(int state);
	$ffi->attach( SDL_GameControllerEventState => [ 'int'  ] => 'int' );

	# extern DECLSPEC void SDLCALL SDL_GameControllerUpdate(void);
	$ffi->attach( SDL_GameControllerUpdate => [ 'void'  ] => 'void' );

	# extern DECLSPEC SDL_GameControllerAxis SDLCALL SDL_GameControllerGetAxisFromString(const char *pchString);
	$ffi->attach( SDL_GameControllerGetAxisFromString => [ 'string'  ] => 'SDL_GameControllerAxis' );

	# extern DECLSPEC const char* SDLCALL SDL_GameControllerGetStringForAxis(SDL_GameControllerAxis axis);
	$ffi->attach( SDL_GameControllerGetStringForAxis => [ 'SDL_GameControllerAxis'  ] => 'string' );

	# extern DECLSPEC SDL_GameControllerButtonBind SDLCALL
	# SDL_GameControllerGetBindForAxis(SDL_GameController *gamecontroller,
	#                                  SDL_GameControllerAxis axis);
	$ffi->attach( SDL_GameControllerGetBindForAxis => [ 'SDL_GameController_ptr', 'SDL_GameControllerAxis'  ] => 'SDL_GameControllerButtonBind_ptr' );

	# extern DECLSPEC Sint16 SDLCALL
	# SDL_GameControllerGetAxis(SDL_GameController *gamecontroller,
	#                           SDL_GameControllerAxis axis);
	$ffi->attach( SDL_GameControllerGetAxis => [ 'SDL_GameController_ptr', 'SDL_GameControllerAxis'  ] => 'sint16' );

	# extern DECLSPEC SDL_GameControllerButton SDLCALL SDL_GameControllerGetButtonFromString(const char *pchString);
	$ffi->attach( SDL_GameControllerGetButtonFromString => [ 'string' ] => 'SDL_GameControllerButton' );

	# extern DECLSPEC const char* SDLCALL SDL_GameControllerGetStringForButton(SDL_GameControllerButton button);
	$ffi->attach( SDL_GameControllerGetStringForButton => [ 'SDL_GameControllerButton' ] => 'string' );

	# extern DECLSPEC SDL_GameControllerButtonBind SDLCALL
	# SDL_GameControllerGetBindForButton(SDL_GameController *gamecontroller,
	#                                    SDL_GameControllerButton button);
	$ffi->attach( SDL_GameControllerGetBindForButton => [ 'SDL_GameController_ptr', 'SDL_GameControllerButton' ] => 'SDL_GameControllerButtonBind_ptr' );


	# extern DECLSPEC Uint8 SDLCALL SDL_GameControllerGetButton(SDL_GameController *gamecontroller,
	#                                                           SDL_GameControllerButton button);
	$ffi->attach( SDL_GameControllerGetButton => [ 'SDL_GameController_ptr', 'SDL_GameControllerButton' ] => 'uint8' );

	# extern DECLSPEC int SDLCALL SDL_GameControllerRumble(SDL_GameController *gamecontroller, Uint16 low_frequency_rumble, Uint16 high_frequency_rumble, Uint32 duration_ms);
	$ffi->attach( SDL_GameControllerRumble => [ 'SDL_GameController_ptr', 'uint16', 'uint16', 'uint32' ] => 'int' );

	# extern DECLSPEC void SDLCALL SDL_GameControllerClose(SDL_GameController *gamecontroller);
	$ffi->attach( SDL_GameControllerClose => [ 'SDL_GameController_ptr' ] => 'void' );

}

1;
