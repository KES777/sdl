package _bar;

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
	my $arm =  _bar->new( 0, 0, $scroll->{ w }, $h );
	$arm->{ c } =  Color->new( 50, 250, 50 );

	$scroll->children( $arm );


	return $scroll;
}


1;
