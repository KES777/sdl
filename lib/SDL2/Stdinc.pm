package SDL2::Stdinc;

use strict;
use warnings;


my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# #define SDL_FALSE 0
	# #define SDL_TRUE 1
	use constant SDL_FALSE  => 0;
	use constant SDL_TRUE   => 1;

	# typedef enum
	# {
	#     SDL_FALSE = 0,
	#     SDL_TRUE = 1
	# } SDL_bool;
	$ffi->load_custom_type('::Enum', 'SDL_bool',
		['SDL_FALSE' => 0],
		['SDL_TRUE'  => 1],
	);

	# typedef enum
	# {
	#     DUMMY_ENUM_VALUE
	# } SDL_DUMMY_ENUM;
	$ffi->load_custom_type('::Enum', 'SDL_DUMMY_ENUM',
		'DUMMY_ENUM_VALUE',
	);

}

1;
