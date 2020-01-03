package SDL2::Timer;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_error.h"
use SDL2::Stdinc;
use SDL2::Error;


#define SDL_TICKS_PASSED(A, B)  ((Sint32)((B) - (A)) <= 0)
sub SDL_TICKS_PASSED {
	my( $A, $B ) =  @_;

	return ((($B) - ($A)) <= 0);
}


my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;


	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );

	# extern DECLSPEC Uint32 SDLCALL SDL_GetTicks(void);
	$ffi->attach( SDL_GetTicks => [ 'void'  ] => 'uint32' );

	# extern DECLSPEC Uint64 SDLCALL SDL_GetPerformanceCounter(void);
	$ffi->attach( SDL_GetPerformanceCounter => [ 'void'  ] => 'uint64' );

	# extern DECLSPEC Uint64 SDLCALL SDL_GetPerformanceFrequency(void);
	$ffi->attach( SDL_GetPerformanceFrequency => [ 'void'  ] => 'uint64' );

	# extern DECLSPEC void SDLCALL SDL_Delay(Uint32 ms);
	$ffi->attach( SDL_Delay => [ 'uint32'  ] => 'void' );

# ????????????????????????
	# typedef Uint32 (SDLCALL * SDL_TimerCallback) (Uint32 interval, void *param);
	# $ffi->attach( SDL_TimerCallback => [ 'uint32', 'void' ] => 'uint32' );
	$ffi->type( 'int'    => 'SDL_TimerCallback' );

	# typedef int SDL_TimerID;
	$ffi->type( 'int' => 'SDL_TimerID' );

	# extern DECLSPEC SDL_TimerID SDLCALL SDL_AddTimer(Uint32 interval,
	#                                                  SDL_TimerCallback callback,
	#                                                  void *param);
	$ffi->attach( SDL_AddTimer => [ 'uint32', 'SDL_TimerCallback', 'opaque' ] => 'SDL_TimerID' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_RemoveTimer(SDL_TimerID id);
	$ffi->attach( SDL_RemoveTimer => [ 'SDL_TimerID'  ] => 'SDL_bool' );

}

1;
