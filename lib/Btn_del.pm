package Btn_del;

use Rect;
use base 'Rect';

sub new {
	my( $btn_del ) =  @_;

	$btn_del  =  $btn_del->SUPER::new( 250, 0, 50, 30 );
	$btn_del->{ c }->{ r }  =  255;
	$btn_del->{ c }->{ g }  =  0;
	$btn_del->{ c }->{ b }  =  0;

	return $btn_del;
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


##delete all shapes or any one
sub moving_off {
	my( $btn_del, $e, $app_rect ) =  @_;

	if( $app_rect->{ btn }->is_over( $e->motion_x, $e->motion_y ) ) {
		$app_rect->{ children } =  ();
		Util::db()->resultset( 'Rect' )->delete;
		$app_rect->draw_black;
			return;
	}

	my $x;
	for my $shape( $app_rect->{ children }->@* ) {
		if( $shape->is_over( $e->motion_x, $e->motion_y ) ) {
			$x =  $shape;
			$shape->draw_black;
		}

		if( $x ) {
			$x->child_destroy;
		}

		$app_rect->{ children }->@* =  grep{ $_ != $x } $app_rect->{ children }->@*;
	}
}



sub can_drop {
	my( $btn_del, $e ) =  @_;

}



##revers
sub drop {
	my( $btn_del ) =  @_;

	$btn_del->SUPER::moving_off;
	$btn_del->draw_black;
	$btn_del->{ x } =  250;
	$btn_del->{ y } =  0;
}



sub on_over {

}

1;
