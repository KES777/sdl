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


	my $h =  $scroll->{ h } / $dimension  *$scroll->{ h };
	my $ruler =  _ruler->new( 0, 0, $scroll->{ w }, $h,
		Color->new( 50, 250, 50 )
	);
	$scroll->children( $ruler );


	return $scroll;
}


1;
