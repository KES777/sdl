package Scroll_bar;

use strict;
use warnings;


use Scalar::Util qw(weaken);

use Table;
use Rect;
use base 'Rect';

my $r =  255;
my $g =  255;
my $b =  255;



sub new {
	my( $scroll) =  shift;

	my $rect =  $scroll->SUPER::new( @_ );

		# $rect->{ c } =   Color->new( $r, $g, $b );

}



sub draw {
	my( $btn_del, $screen, $x, $y ) =  @_;

	$btn_del->draw_black;
	$btn_del->save_draw_coord;

	$screen //=  AppRect::SCREEN();
	$x //=  0;
	$y //=  0;

	$x += $btn_del->{ x };
	$y += $btn_del->{ y };

	$screen->draw_rect([
		$x,
		$y,
		$btn_del->{ w },
		$btn_del->{ h },
	],[
		0,0,255,255
	]);

	#circuit
	$screen->draw_rect([
		$x +2,
		$y +2,
		$btn_del->{ w }-4,
		$btn_del->{ h }-4,
	],[
		$btn_del->{ c }->get()
	]);

}



sub is_over_res_field{ }


1;
