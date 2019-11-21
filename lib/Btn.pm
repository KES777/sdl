package Btn;

use strict;
use warnings;


use Scalar::Util qw(weaken);


use Rect;
use base 'Rect';


sub new {
	my( $btn ) =  @_;

	$btn  =  $btn->SUPER::new( 0, 0, 50, 30 );

	return $btn;
}



sub on_press {
	my( $btn, $h, $e ) =  @_;

	my $rect =  Rect->new;
	$rect->{ parent } =  $btn->{ parent };
	weaken $rect->{ parent };
	$rect->store;
	push $btn->{ parent }->{ children }->@*, $rect;
}



sub draw {
	my( $app_rect, $app, $x, $y ) =  @_;

	$x //=  0;
	$y //=  0;

	$x += $app_rect->{ x };
	$y += $app_rect->{ y };

	$app->draw_rect([
		$x,
		$y,
		$app_rect->{ w },
		$app_rect->{ h },
	],[
		255,255,255,255
	]);
	#circuit
	$app->draw_rect([
		$x +1,
		$y +1,
		$app_rect->{ w }-2,
		$app_rect->{ h }-2,
	],[
		$app_rect->{ c }->get()
	]);
}



sub on_over {

}



sub is_moveable {

}



sub on_press {
	my( $btn, $h, $e ) =  @_;

	my $rect =  Rect->new->store;
	push $btn->{ parent }->{ children }->@*, $rect;
}

1;
