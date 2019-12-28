package Input;

use strict;
use warnings;

use SDLx::Text;

use base 'Rect';
use Cursor;
use Variable;

my $r =  255;
my $g =  255;
my $b =  255;
my $a =  255;


sub new {
	my( $input, $shape ) =  (shift, shift);

	my $if  =  $input->SUPER::new(@_);
	$if->{status}     =  'service';
	$if->{cursor_pos} =  0;
	$if->{h}          =  30;
	$if->{w}          =  360;
	$if->set_color( $r, $g, $b, $a );

	return $if;
}



# sub draw {
# 	my( $if, $dx, $dy ) =  @_;

# 	my $x =  $if->{x} + $dx;
# 	my $y =  $if->{y} + $dy;

# 	my $screen =  AppRect::SCREEN();

# 	$screen->draw_rect( [ $x, $y, $if->{w}, $if->{h} ], [ 0, 0, 255, 0 ] );
# 	$screen->draw_rect( [ $x+2, $y+2, $if->{w}-4, $if->{h}-4 ], [ 255, 255, 255, 255 ] );
# 	return undef;
# }



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



sub store { }
# sub on_mouse_over { }
# sub on_mouse_out { }
# sub on_move { }
sub get_sb_coords { }

1;
