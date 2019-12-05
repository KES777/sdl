package SDL2::Rwops;

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

	#define SDL_RWOPS_UNKNOWN   0U  /**< Unknown stream type */
	#define SDL_RWOPS_WINFILE   1U  /**< Win32 file */
	#define SDL_RWOPS_STDFILE   2U  /**< Stdio file */
	#define SDL_RWOPS_JNIFILE   3U  /**< Android asset */
	#define SDL_RWOPS_MEMORY    4U  /**< Memory stream */
	#define SDL_RWOPS_MEMORY_RO 5U  /**< Read-Only memory stream */
	use constant SDL_RWOPS_UNKNOWN       => "0U";
	use constant SDL_RWOPS_WINFILE       => "1U";
	use constant SDL_RWOPS_STDFILE       => "2U";
	use constant SDL_RWOPS_JNIFILE       => "3U";
	use constant SDL_RWOPS_MEMORY        => "4U";
	use constant SDL_RWOPS_MEMORY_RO     => "5U";

	$ffi->type( 'opaque' => 'SDL_RWops_ptr' );       #struct

	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );

	# extern DECLSPEC SDL_RWops *SDLCALL SDL_RWFromFile(const char *file,
	#                                                   const char *mode);
	$ffi->attach( SDL_RWFromFile => [ 'string', 'string'  ] => 'SDL_RWops_ptr' );

# ?????????????????? 2 одинаковых
	# extern DECLSPEC SDL_RWops *SDLCALL SDL_RWFromFP(FILE * fp,
	#                                                 SDL_bool autoclose);
	# $ffi->attach( SDL_RWFromFP => [ 'FILE', 'SDL_bool'  ] => 'SDL_RWops_ptr' );

# ?????????????????? 2 одинаковых
	# extern DECLSPEC SDL_RWops *SDLCALL SDL_RWFromFP(void * fp,
	#                                                 SDL_bool autoclose);
	$ffi->attach( SDL_RWFromFP => [ 'opaque', 'SDL_bool'  ] => 'SDL_RWops_ptr' );

	# extern DECLSPEC SDL_RWops *SDLCALL SDL_RWFromMem(void *mem, int size);
	$ffi->attach( SDL_RWFromMem => [ 'opaque', 'int'  ] => 'SDL_RWops_ptr' );

	# extern DECLSPEC SDL_RWops *SDLCALL SDL_RWFromConstMem(const void *mem,
	#                                                       int size);
	$ffi->attach( SDL_RWFromConstMem => [ 'opaque', 'int'  ] => 'SDL_RWops_ptr' );

	# extern DECLSPEC SDL_RWops *SDLCALL SDL_AllocRW(void);
	$ffi->attach( SDL_AllocRW => [ 'void'  ] => 'SDL_RWops_ptr' );

	# extern DECLSPEC void SDLCALL SDL_FreeRW(SDL_RWops * area);
	$ffi->attach( SDL_FreeRW => [ 'SDL_RWops_ptr'  ] => 'void' );

	#define RW_SEEK_SET 0       /**< Seek from the beginning of data */
	#define RW_SEEK_CUR 1       /**< Seek relative to current read point */
	#define RW_SEEK_END 2       /**< Seek relative to the end of data */
	use constant RW_SEEK_SET     => 0;
	use constant RW_SEEK_CUR     => 1;
	use constant RW_SEEK_END     => 2;

	# extern DECLSPEC Sint64 SDLCALL SDL_RWsize(SDL_RWops *context);
	$ffi->attach( SDL_RWsize => [ 'SDL_RWops_ptr'  ] => 'sint64' );

	# extern DECLSPEC Sint64 SDLCALL SDL_RWseek(SDL_RWops *context,
	                                          # Sint64 offset, int whence);
	$ffi->attach( SDL_RWseek => [ 'SDL_RWops_ptr', 'sint64', 'int' ] => 'sint64' );

	# extern DECLSPEC Sint64 SDLCALL SDL_RWtell(SDL_RWops *context);
	$ffi->attach( SDL_RWtell => [ 'SDL_RWops_ptr'  ] => 'sint64' );

	# extern DECLSPEC size_t SDLCALL SDL_RWread(SDL_RWops *context,
	#                                           void *ptr, size_t size, size_t maxnum);
	$ffi->attach( SDL_RWread => [ 'SDL_RWops_ptr', 'string', 'size_t', 'size_t' ] => 'size_t' );

	# extern DECLSPEC size_t SDLCALL SDL_RWwrite(SDL_RWops *context,
	#                                            const void *ptr, size_t size, size_t num);
	$ffi->attach( SDL_RWwrite => [ 'SDL_RWops_ptr', 'string', 'size_t', 'size_t' ] => 'size_t' );

	# extern DECLSPEC int SDLCALL SDL_RWclose(SDL_RWops *context);
	$ffi->attach( SDL_RWclose => [ 'SDL_RWops_ptr'  ] => 'int' );

	# extern DECLSPEC void *SDLCALL SDL_LoadFile_RW(SDL_RWops * src, size_t *datasize,
	                                                    # int freesrc);
	$ffi->attach( SDL_LoadFile_RW => [ 'SDL_RWops_ptr', 'size_t', 'int' ] => 'string' );

	# extern DECLSPEC void *SDLCALL SDL_LoadFile(const char *file, size_t *datasize);
	$ffi->attach( SDL_LoadFile => [ 'string', 'size_t' ] => 'string' );

	# extern DECLSPEC Uint8 SDLCALL SDL_ReadU8(SDL_RWops * src);
	$ffi->attach( SDL_ReadU8 => [ 'SDL_RWops_ptr'  ] => 'uint8' );

	# extern DECLSPEC Uint16 SDLCALL SDL_ReadLE16(SDL_RWops * src);
	$ffi->attach( SDL_ReadLE16 => [ 'SDL_RWops_ptr'  ] => 'uint16' );

	# extern DECLSPEC Uint16 SDLCALL SDL_ReadBE16(SDL_RWops * src);
	$ffi->attach( SDL_ReadBE16 => [ 'SDL_RWops_ptr'  ] => 'uint16' );

	# extern DECLSPEC Uint32 SDLCALL SDL_ReadLE32(SDL_RWops * src);
	$ffi->attach( SDL_ReadLE32 => [ 'SDL_RWops_ptr'  ] => 'uint32' );

	# extern DECLSPEC Uint32 SDLCALL SDL_ReadBE32(SDL_RWops * src);
	$ffi->attach( SDL_ReadBE32 => [ 'SDL_RWops_ptr'  ] => 'uint32' );

	# extern DECLSPEC Uint64 SDLCALL SDL_ReadLE64(SDL_RWops * src);
	$ffi->attach( SDL_ReadLE64 => [ 'SDL_RWops_ptr'  ] => 'uint64' );

	# extern DECLSPEC Uint64 SDLCALL SDL_ReadBE64(SDL_RWops * src);
	$ffi->attach( SDL_ReadBE64 => [ 'SDL_RWops_ptr'  ] => 'uint64' );

	# extern DECLSPEC size_t SDLCALL SDL_WriteU8(SDL_RWops * dst, Uint8 value);
	$ffi->attach( SDL_WriteU8 => [ 'SDL_RWops_ptr', 'uint8'  ] => 'size_t' );

	# extern DECLSPEC size_t SDLCALL SDL_WriteLE16(SDL_RWops * dst, Uint16 value);
	$ffi->attach( SDL_WriteLE16 => [ 'SDL_RWops_ptr', 'uint16'  ] => 'size_t' );

	# extern DECLSPEC size_t SDLCALL SDL_WriteBE16(SDL_RWops * dst, Uint16 value);
	$ffi->attach( SDL_WriteBE16 => [ 'SDL_RWops_ptr', 'uint16'  ] => 'size_t' );

	# extern DECLSPEC size_t SDLCALL SDL_WriteLE32(SDL_RWops * dst, Uint32 value);
	$ffi->attach( SDL_WriteLE32 => [ 'SDL_RWops_ptr', 'uint32'  ] => 'size_t' );

	# extern DECLSPEC size_t SDLCALL SDL_WriteBE32(SDL_RWops * dst, Uint32 value);
	$ffi->attach( SDL_WriteBE32 => [ 'SDL_RWops_ptr', 'uint32'  ] => 'size_t' );

	# extern DECLSPEC size_t SDLCALL SDL_WriteLE64(SDL_RWops * dst, Uint64 value);
	$ffi->attach( SDL_WriteLE64 => [ 'SDL_RWops_ptr', 'uint64'  ] => 'size_t' );

	# extern DECLSPEC size_t SDLCALL SDL_WriteBE64(SDL_RWops * dst, Uint64 value);
	$ffi->attach( SDL_WriteBE64 => [ 'SDL_RWops_ptr', 'uint64'  ] => 'size_t' );

}

1;
