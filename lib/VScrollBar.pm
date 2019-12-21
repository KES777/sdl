package _ruler_v;

use strict;
use warnings;

use Rect;


use base 'Rect';


sub on_move {
	my( $shape, $e, $h ) =  @_;

	my $dy =  $e->motion_y - $h->{ event_old_y };
	$h->{ event_old_y } =  $e->motion_y;
	my $dx     =  0;
	my $border =  1;
	$shape->move_to( $shape->calc_move_values( $dx, $dy ), $border );

	my $length =  $shape->{ parent }{ h } - $shape->{ h };
	my $pos    =  $shape->{ y };
	$shape->{ parent }{ pos } =  $pos / $length;
}



## Size_batton coords
sub get_sb_coords { }
sub store {}


package VScrollBar;

use strict;
use warnings;

use Rect;
use Color;


use base 'Rect';

my $r =  50;
my $g =  250;
my $b =  50;


sub new {
	my( $scroll, $dimension ) =  ( shift, shift );

	$scroll =  $scroll->SUPER::new( @_ );

	my $view  =  $scroll->{ h } / $dimension;
	# Nothing to scroll: 100% data is displayed
	$view < 1   or return $scroll;


	my $ruler =  _ruler_v->new(
		0, 0,                                      # X Y
		$scroll->{ w },                            # Width
		limit_min( $scroll->{ h } *$view, 10 ),    # Height
		Color->new( $r, $g, $b ),                  # Color
	);
	$scroll->children( $ruler );

	$scroll->{ pos } =  0;


	return $scroll;
}



sub limit_min {
	my( $value, $min ) =  @_;

	return $value >= $min? $value : $min;
}



sub limit_max {
	my( $value, $max ) =  @_;

	return $value <= $max? $value : $max;
}



## Size_batton coords
sub get_sb_coords { }
sub on_move { }
sub store { }


1;

