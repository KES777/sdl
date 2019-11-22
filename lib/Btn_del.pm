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



sub on_btn_del {
	my( $btn_del, $app_rect ) =  @_;

	if( $app_rect->{ btn }->is_over( $btn_del->{ x }, $btn_del->{ y } ) ) {
		$app_rect->{ children } =  ();
		Util::db()->resultset( 'Rect' )->delete;
		$app_rect->draw_black;
	}
}



sub is_drop {
	my( $shape ) =  @_;

	$shape->draw_black;
	$shape->{ x } =  250;
	$shape->{ y } =  0;
}



sub on_over {

}

1;
