package SDL2::Keyboard;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_error.h"
#include "SDL_keycode.h"
#include "SDL_video.h"
use SDL2::Stdinc;
use SDL2::Error;
use SDL2::Keycode;
use SDL2::Video;


my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;


	$ffi->type( 'opaque' => 'SDL_Keysym_ptr' );             #struct
	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );
	SDL2::Keycode::attach( $ffi );
	SDL2::Video::attach( $ffi );


	# extern DECLSPEC SDL_Window * SDLCALL SDL_GetKeyboardFocus(void);
	$ffi->attach( SDL_GetKeyboardFocus => [ 'void'  ] => 'SDL_Window_ptr' );

	# extern DECLSPEC const Uint8 *SDLCALL SDL_GetKeyboardState(int *numkeys);
	$ffi->attach( SDL_GetKeyboardState => [ 'int'  ] => 'uint8' );

	# extern DECLSPEC SDL_Keymod SDLCALL SDL_GetModState(void);
	$ffi->attach( SDL_GetModState => [ 'void'  ] => 'SDL_Keymod' );

	# extern DECLSPEC void SDLCALL SDL_SetModState(SDL_Keymod modstate);
	$ffi->attach( SDL_SetModState => [ 'SDL_Keymod'  ] => 'void' );

	# extern DECLSPEC SDL_Keycode SDLCALL SDL_GetKeyFromScancode(SDL_Scancode scancode);
	$ffi->attach( SDL_GetKeyFromScancode => [ 'SDL_Scancode'  ] => 'SDL_Keycode' );

	# extern DECLSPEC SDL_Scancode SDLCALL SDL_GetScancodeFromKey(SDL_Keycode key);
	$ffi->attach( SDL_GetScancodeFromKey => [ 'SDL_Keycode'  ] => 'SDL_Scancode' );

	# extern DECLSPEC const char *SDLCALL SDL_GetScancodeName(SDL_Scancode scancode);
	$ffi->attach( SDL_GetScancodeName => [ 'SDL_Scancode'  ] => 'string' );

	# extern DECLSPEC SDL_Scancode SDLCALL SDL_GetScancodeFromName(const char *name);
	$ffi->attach( SDL_GetScancodeFromName => [ 'string'  ] => 'SDL_Scancode' );

	# extern DECLSPEC const char *SDLCALL SDL_GetKeyName(SDL_Keycode key);
	$ffi->attach( SDL_GetKeyName => [ 'SDL_Keycode'  ] => 'string' );

	# extern DECLSPEC SDL_Keycode SDLCALL SDL_GetKeyFromName(const char *name);
	$ffi->attach( SDL_GetKeyFromName => [ 'string'  ] => 'SDL_Keycode' );

	# extern DECLSPEC void SDLCALL SDL_StartTextInput(void);
	$ffi->attach( SDL_StartTextInput => [ 'void'  ] => 'void' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_IsTextInputActive(void);
	$ffi->attach( SDL_IsTextInputActive => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC void SDLCALL SDL_StopTextInput(void);
	$ffi->attach( SDL_StopTextInput => [ 'void'  ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_SetTextInputRect(SDL_Rect *rect);
	$ffi->attach( SDL_SetTextInputRect => [ 'SDL_Rect_ptr'  ] => 'void' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasScreenKeyboardSupport(void);
	$ffi->attach( SDL_HasScreenKeyboardSupport => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_IsScreenKeyboardShown(SDL_Window *window);
	$ffi->attach( SDL_IsScreenKeyboardShown => [ 'SDL_Window_ptr'  ] => 'SDL_bool' );

}

1;
