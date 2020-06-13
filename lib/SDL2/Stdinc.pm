package SDL2::Stdinc;

use strict;
use warnings;


	# #define SDL_FALSE 0
	sub SDL_FALSE() { 0 };
	# #define SDL_TRUE 1
	sub SDL_TRUE()  { 1 };

	#define SDL_FOURCC(A, B, C, D) \
    # ((SDL_static_cast(Uint32, SDL_static_cast(Uint8, (A))) << 0) | \
    #  (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (B))) << 8) | \
    #  (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (C))) << 16) | \
    #  (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (D))) << 24))
    sub SDL_FOURCC {
	  my( $A, $B, $C, $D ) =  @_;

	  return
	    ord($A)<< 0 & 0x000000FF | ord($B)<< 8 & 0x0000FF00 |
	    ord($C)<<16 & 0x00FF0000 | ord($D)<<24 & 0xFF000000;
	}





my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# typedef enum
	# {
	#     SDL_FALSE = 0,
	#     SDL_TRUE = 1
	# } SDL_bool;
	$ffi->load_custom_type('::Enum', 'SDL_bool',
		{ ret => 'int', package => 'SDL2::Stdinc' },
		['SDL_FALSE' => 0],
		['SDL_TRUE'  => 1],
	);

	# typedef enum
	# {
	#     DUMMY_ENUM_VALUE
	# } SDL_DUMMY_ENUM;
	$ffi->load_custom_type('::Enum', 'SDL_DUMMY_ENUM',
		{ ret => 'int', package => 'SDL2::Stdinc' },
		'DUMMY_ENUM_VALUE',
	);

}

1;
