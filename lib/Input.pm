package Input;

use strict;
use warnings;

use SDLx::Text;

use base 'Rect';
use Cursor;
use Variable;


sub new {
	my( $input, $obj ) =  ( shift, shift );

	my $input_field =  $input->SUPER::new( @_ );
	$obj->children( $input_field );
# DB::x;
	return $obj;
}



sub on_click {
	my( $shape, $h, $e ) =  @_;



	$h->{ app }->refresh_over( $e->motion_x, $e->motion_y );## проверить координаты!!!
}



1;
