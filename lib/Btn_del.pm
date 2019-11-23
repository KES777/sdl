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
	my( $btn_del, $app_rect, $e ) =  @_;

	DB::x;
	my $x = 3;
	if( $app_rect->{ btn }->is_over( $e->motion_x, $e->motion_y ) ) {
		$app_rect->{ children } =  ();
		Util::db()->resultset( 'Rect' )->delete;
		$app_rect->draw_black;
	}
	# my $x;
	# for my $shape( $app_rect->{ children }->@* ) {
	# 	if( $shape->is_over( $btn_del->{ x }, $btn_del->{ y } ) ) {
	# 		$x =  $shape;
	# 		$shape->child_destroy;
	# 		$shape->draw_black;
	# 	}
	# }

	# $app_rect->{ children }->@* =  grep{ $_ != $x } $app_rect->{ children };
}


#revers
sub is_drop {
	my( $shape ) =  @_;

	$shape->draw_black;
	$shape->{ x } =  250;
	$shape->{ y } =  0;
}



sub on_over {

}

1;
