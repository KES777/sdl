package SDL2::Mouse;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_error.h"
#include "SDL_video.h"
use SDL2::Stdinc;
use SDL2::Error;
use SDL2::Video;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# typedef struct SDL_Cursor SDL_Cursor;   /**< Implementation dependent */
	$ffi->type( 'opaque' => 'SDL_Cursor_ptr' );            #struct


	# typedef enum
	# {
	#     SDL_SYSTEM_CURSOR_ARROW,     /**< Arrow */
	#     SDL_SYSTEM_CURSOR_IBEAM,     /**< I-beam */
	#     SDL_SYSTEM_CURSOR_WAIT,      /**< Wait */
	#     SDL_SYSTEM_CURSOR_CROSSHAIR, /**< Crosshair */
	#     SDL_SYSTEM_CURSOR_WAITARROW, /**< Small wait cursor (or Wait if not available) */
	#     SDL_SYSTEM_CURSOR_SIZENWSE,  /**< Double arrow pointing northwest and southeast */
	#     SDL_SYSTEM_CURSOR_SIZENESW,  /**< Double arrow pointing northeast and southwest */
	#     SDL_SYSTEM_CURSOR_SIZEWE,    /**< Double arrow pointing west and east */
	#     SDL_SYSTEM_CURSOR_SIZENS,    /**< Double arrow pointing north and south */
	#     SDL_SYSTEM_CURSOR_SIZEALL,   /**< Four pointed arrow pointing north, south, east, and west */
	#     SDL_SYSTEM_CURSOR_NO,        /**< Slashed circle or crossbones */
	#     SDL_SYSTEM_CURSOR_HAND,      /**< Hand */
	#     SDL_NUM_SYSTEM_CURSORS
	# } SDL_SystemCursor;
	$ffi->load_custom_type('::Enum', 'SDL_SystemCursor',
		'SDL_SYSTEM_CURSOR_ARROW',     # /**< Arrow */
	    'SDL_SYSTEM_CURSOR_IBEAM',     # /**< I-beam */
	    'SDL_SYSTEM_CURSOR_WAIT',      # /**< Wait */
	    'SDL_SYSTEM_CURSOR_CROSSHAIR', # /**< Crosshair */
	    'SDL_SYSTEM_CURSOR_WAITARROW', # /**< Small wait cursor (or Wait if not available) */
	    'SDL_SYSTEM_CURSOR_SIZENWSE',  # /**< Double arrow pointing northwest and southeast */
	    'SDL_SYSTEM_CURSOR_SIZENESW',  # /**< Double arrow pointing northeast and southwest */
	    'SDL_SYSTEM_CURSOR_SIZEWE',    # /**< Double arrow pointing west and east */
	    'SDL_SYSTEM_CURSOR_SIZENS',    # /**< Double arrow pointing north and south */
	    'SDL_SYSTEM_CURSOR_SIZEALL',   # /**< Four pointed arrow pointing north, south, east, and west */
	    'SDL_SYSTEM_CURSOR_NO',        # /**< Slashed circle or crossbones */
	    'SDL_SYSTEM_CURSOR_HAND',      # /**< Hand */
	    'SDL_NUM_SYSTEM_CURSORS',
	);


	# typedef enum
	# {
	#     SDL_MOUSEWHEEL_NORMAL,    /**< The scroll direction is normal */
	#     SDL_MOUSEWHEEL_FLIPPED    /**< The scroll direction is flipped / natural */
	# } SDL_MouseWheelDirection;
	$ffi->load_custom_type('::Enum', 'SDL_MouseWheelDirection',
	    'SDL_MOUSEWHEEL_NORMAL',    # /**< The scroll direction is normal */
		'SDL_MOUSEWHEEL_FLIPPED',   # /**< The scroll direction is flipped / natural */
	);


	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );
	SDL2::Video::attach( $ffi );


	# extern DECLSPEC SDL_Window * SDLCALL SDL_GetMouseFocus(void);
	$ffi->attach( SDL_GetMouseFocus => [ 'void'  ] => 'SDL_Window_ptr' );

	# extern DECLSPEC Uint32 SDLCALL SDL_GetMouseState(int *x, int *y);
	$ffi->attach( SDL_GetMouseState => [ 'int*', 'int*'  ] => 'uint32' );

	# extern DECLSPEC Uint32 SDLCALL SDL_GetGlobalMouseState(int *x, int *y);
	$ffi->attach( SDL_GetGlobalMouseState => [ 'int*', 'int*'  ] => 'uint32' );

	# extern DECLSPEC Uint32 SDLCALL SDL_GetRelativeMouseState(int *x, int *y);
	$ffi->attach( SDL_GetRelativeMouseState => [ 'int*', 'int*'  ] => 'uint32' );

	# extern DECLSPEC void SDLCALL SDL_WarpMouseInWindow(SDL_Window * window,
	                                                   # int x, int y);
	$ffi->attach( SDL_WarpMouseInWindow => [ 'SDL_Window_ptr', 'int', 'int'  ] => 'void' );

	# extern DECLSPEC int SDLCALL SDL_WarpMouseGlobal(int x, int y);
	$ffi->attach( SDL_WarpMouseGlobal => [ 'int', 'int'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_SetRelativeMouseMode(SDL_bool enabled);
	$ffi->attach( SDL_SetRelativeMouseMode => [ 'SDL_bool'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_CaptureMouse(SDL_bool enabled);
	$ffi->attach( SDL_CaptureMouse => [ 'SDL_bool'  ] => 'int' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_GetRelativeMouseMode(void);
	$ffi->attach( SDL_GetRelativeMouseMode => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateCursor(const Uint8 * data,
	#                                                      const Uint8 * mask,
	#                                                      int w, int h, int hot_x,
	#                                                      int hot_y);
	$ffi->attach( SDL_CreateCursor => [ 'uint8', 'uint8', 'int', 'int', 'int', 'int' ] => 'SDL_Cursor_ptr' );

	# extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateColorCursor(SDL_Surface *surface,
	#                                                           int hot_x,
	#                                                           int hot_y);
	$ffi->attach( SDL_CreateColorCursor => [ 'SDL_Surface_ptr', 'int', 'int' ] => 'SDL_Cursor_ptr' );

	# extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateSystemCursor(SDL_SystemCursor id);
	$ffi->attach( SDL_CreateSystemCursor => [ 'SDL_SystemCursor' ] => 'SDL_Cursor_ptr' );

	# extern DECLSPEC void SDLCALL SDL_SetCursor(SDL_Cursor * cursor);
	$ffi->attach( SDL_SetCursor => [ 'SDL_Cursor_ptr' ] => 'void' );

	# extern DECLSPEC SDL_Cursor *SDLCALL SDL_GetCursor(void);
	$ffi->attach( SDL_GetCursor => [ 'void' ] => 'SDL_Cursor_ptr' );

	# extern DECLSPEC SDL_Cursor *SDLCALL SDL_GetDefaultCursor(void);
	$ffi->attach( SDL_GetDefaultCursor => [ 'void' ] => 'SDL_Cursor_ptr' );

	# extern DECLSPEC void SDLCALL SDL_FreeCursor(SDL_Cursor * cursor);
	$ffi->attach( SDL_FreeCursor => [ 'SDL_Cursor_ptr' ] => 'void' );

	# extern DECLSPEC int SDLCALL SDL_ShowCursor(int toggle);
	$ffi->attach( SDL_ShowCursor => [ 'int'  ] => 'int' );


	#define SDL_BUTTON(X)       (1 << ((X)-1))
	# sub SDL_BUTTON { 1 << (( shift ) -1) }
	sub SDL_BUTTON {
		# my $X =  shift;
		my( $X ) =  @_;

		my $result =  1 << (( $X ) -1);

		return $result;
	}

	#define SDL_BUTTON_LEFT     1
	#define SDL_BUTTON_MIDDLE   2
	#define SDL_BUTTON_RIGHT    3
	#define SDL_BUTTON_X1       4
	#define SDL_BUTTON_X2       5
	use constant SDL_BUTTON_LEFT    => 1;
	use constant SDL_BUTTON_MIDDLE  => 2;
	use constant SDL_BUTTON_RIGHT   => 3;
	use constant SDL_BUTTON_X1      => 4;
	use constant SDL_BUTTON_X2      => 5;

	#define SDL_BUTTON_LMASK    SDL_BUTTON(SDL_BUTTON_LEFT)
	#define SDL_BUTTON_MMASK    SDL_BUTTON(SDL_BUTTON_MIDDLE)
	#define SDL_BUTTON_RMASK    SDL_BUTTON(SDL_BUTTON_RIGHT)
	#define SDL_BUTTON_X1MASK   SDL_BUTTON(SDL_BUTTON_X1)
	#define SDL_BUTTON_X2MASK   SDL_BUTTON(SDL_BUTTON_X2)
	use constant SDL_BUTTON_LMASK   =>  SDL_BUTTON(SDL_BUTTON_LEFT);
	use constant SDL_BUTTON_MMASK   =>  SDL_BUTTON(SDL_BUTTON_MIDDLE);
	use constant SDL_BUTTON_RMASK   =>  SDL_BUTTON(SDL_BUTTON_RIGHT);
	use constant SDL_BUTTON_X1MASK  =>  SDL_BUTTON(SDL_BUTTON_X1);
	use constant SDL_BUTTON_X2MASK  =>  SDL_BUTTON(SDL_BUTTON_X2);

}

1;
