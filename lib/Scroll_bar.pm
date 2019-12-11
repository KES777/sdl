package _ruler;

use strict;
use warnings;

use Rect;


use base 'Rect';



sub store {}

sub on_move {
	my( $shape, $e, $h ) =  @_;

	my $dy =  $e->motion_y -$h->{ event_old_y };
	$h->{ event_old_y } =  $e->motion_y;
	$shape->move_by( 0, $dy );
	$shape->clip;

	my $length =  $shape->{ parent }{ h } -$shape->{ h };
	my $pos    =  $shape->{ y };
	$shape->{ parent }{ pos } =  $pos / $length;
	print $shape->{ parent }{ pos }, "\n";
}



package Scroll_bar;

use strict;
use warnings;

use Rect;
use Color;


use base 'Rect';



sub store { }

sub new {
	my( $scroll, $dimension ) =  ( shift, shift );

	$scroll =  $scroll->SUPER::new( @_ );


	my $view  =  $scroll->{ h } / $dimension;
	my $ruler =  _ruler->new( 0, 0,
		$scroll->{ w },
		limit_min( $scroll->{ h } *$view, 10 ),
		Color->new( 50, 250, 50 )
	);
	$scroll->children( $ruler );


	return $scroll;
}



sub limit_min {
	my( $value, $min ) =  @_;

	return $value >= $min? $value : $min;
}


1;
