package Selection;

use AppRect;


use base 'Rect';



sub new {
	my $sel =  shift;

	$sel =  $sel->SUPER::new( @_ );

	$sel->{ sel_start_x } =  $sel->{ x };
	$sel->{ sel_start_y } =  $sel->{ y };

	return $sel;
}



sub resize {
	my( $sel, $mx, $my ) =  @_;

	my $tx =  $sel->{ sel_start_x };
	my $ty =  $sel->{ sel_start_y };

	if( $mx > $tx ) {
		$sel->{ w } =  $mx - $sel->{ x };
	}
	else {
		$sel->{ x } =  $mx;
		$sel->{ w } =  $tx - $mx;
	}

	if( $my > $ty ) {
		$sel->{ h } =  $my - $sel->{ y };
	}
	else {
		$sel->{ y } =  $my;
		$sel->{ h } =  $ty - $my;
	}
}


sub draw {
	my( $rect, $screen, $x, $y ) = @_;

	$screen //=  AppRect::SCREEN();

	$x //=  0;
	$y //=  0;

	$x += $rect->{ x };
	$y += $rect->{ y };

	$screen->draw_rect([
		$x,
		$y,
		$rect->{ w },
		$rect->{ h },
	],[
		255,255,255,255
	]);

	#circuit
	$screen->draw_rect([
		$x +1,
		$y +1,
		$rect->{ w }-2,
		$rect->{ h }-2,
	],[
		$rect->{ c }->get()
	]);
}



sub on_resize {
	my( $sel, $h, $e ) =  @_;

	$h->draw_black;
	$h->resize( $e->motion_x, $e->motion_y );
	$h->draw;
}



1;
