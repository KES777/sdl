package SDL2::Assert;

use strict;
use warnings;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;


	my( $ffi ) =  @_;

	# if( _MSC_VER ) {
	#   ->attach( __debugbreak => [], 'void' );
	# }
	# elsif {
	# }


}

1;
