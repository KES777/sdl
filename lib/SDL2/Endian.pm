package SDL2::Endian;

use strict;
use warnings;

#define SDL_LIL_ENDIAN  1234
#define SDL_BIG_ENDIAN  4321
sub SDL_LIL_ENDIAN  { 1234 };
sub SDL_BIG_ENDIAN  { 4321 };

# define SDL_BYTEORDER  __BYTE_ORDER
# cat /usr/include/x86_64-linux-gnu/bits/endian.h | grep __BYTE_ORDER
#define __BYTE_ORDER __LITTLE_ENDIAN
sub SDL_BYTEORDER { SDL_LIL_ENDIAN };


sub attach {

	my( $ffi ) =  @_;


}

1;
