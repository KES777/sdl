package SDL2::Cpuinfo;

use strict;
use warnings;

use SDL2::Stdinc;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	SDL2::Stdinc::attach( $ffi );

	#define SDL_CACHELINE_SIZE  128
	use constant SDL_CACHELINE_SIZE  => 128;

	# extern DECLSPEC int SDLCALL SDL_GetCPUCount(void);
	$ffi->attach( SDL_GetCPUCount => [ 'void'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_GetCPUCacheLineSize(void);
	$ffi->attach( SDL_GetCPUCacheLineSize => [ 'void'  ] => 'int' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasRDTSC(void);
	$ffi->attach( SDL_HasRDTSC => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasAltiVec(void);
	$ffi->attach( SDL_HasAltiVec => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasMMX(void);
	$ffi->attach( SDL_HasMMX => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_Has3DNow(void);
	$ffi->attach( SDL_Has3DNow => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE(void);
	$ffi->attach( SDL_HasSSE => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE2(void);
	$ffi->attach( SDL_HasSSE2 => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE3(void);
	$ffi->attach( SDL_HasSSE3 => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE41(void);
	$ffi->attach( SDL_HasSSE41 => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE42(void);
	$ffi->attach( SDL_HasSSE42 => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasAVX(void);
	$ffi->attach( SDL_HasAVX => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasAVX2(void);
	$ffi->attach( SDL_HasAVX2 => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasAVX512F(void);
	$ffi->attach( SDL_HasAVX512F => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasNEON(void);
	$ffi->attach( SDL_HasNEON => [ 'void'  ] => 'SDL_bool' );

	# extern DECLSPEC int SDLCALL SDL_GetSystemRAM(void);
	$ffi->attach( SDL_GetSystemRAM => [ 'void'  ] => 'int' );

	# extern DECLSPEC size_t SDLCALL SDL_SIMDGetAlignment(void);
	$ffi->attach( SDL_SIMDGetAlignment => [ 'void'  ] => 'size_t' );

	# extern DECLSPEC void * SDLCALL SDL_SIMDAlloc(const size_t len);
	$ffi->attach( SDL_SIMDAlloc => [ 'size_t'  ] => 'opaque' );

	# extern DECLSPEC void SDLCALL SDL_SIMDFree(void *ptr);
	$ffi->attach( SDL_SIMDFree => [ 'opaque'  ] => 'void' );

}

1;
