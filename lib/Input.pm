package Input;

use strict;
use warnings;

use SDLx::Text;

use base 'Rect';
use Cursor;
use Variable;


sub new {
	my( $input, $shape ) =  ( shift, shift );

	my $input_field =  $input->SUPER::new( @_ );

	$input_field->{ cursor_pos } =  0;
	$input_field->{h} =  30;
	$input_field->{w} =  360;

	return $input_field;
}



sub draw {
	my( $if ) =  @_;

	my $screen =  AppRect::SCREEN();

	$screen->draw_rect( [ $if->{x}, $if->{y}, $if->{w}, $if->{h} ], [ 0, 0, 255, 0 ] );
	$screen->draw_rect( [ $if->{x}+2, $if->{y}+2, $if->{w}-4, $if->{h}-4 ], [ 255, 255, 255, 255 ] );
	return undef;
	# print "'Input' \n";
}



sub on_click {
	my( $if, $h, $e ) =  @_;

	my $x =  $if->{ x } + 10;
	$if->{ cursor } =  Cursor->new( $if->{x}+10, $if->{y}, 4, $if->{h} );

	# $h->{ app }->refresh_over( $e->motion_x, $e->motion_y );
}



sub on_keydown {
	my( $input_field, $h, $e ) =  @_;

	my $key =  $h->{ app }{ event_state };
# DB::x;
	if( $h->{ app }{ event_state }{ SDLK_x() } ) {
		print "x";
	}
	elsif( $key->{ SDLK_y() } ) {

	}
}




# sub on_mouse_over { }
# sub on_mouse_out { }
sub on_move { }
sub get_sb_coords { }

1;
