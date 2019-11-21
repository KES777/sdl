package Shape;

use strict;
use warnings;

use Scalar::Util qw(weaken);

use Rect;


sub is_moveable {
	my( $rect, $event_obj ) =  @_;

	$rect->moving_on( $event_obj->{ x }, $event_obj->{ y } );
	return $event_obj;
}



sub on_move {
	my( $shape, $h, $e ) =  @_;

	my $p =  $shape->{ parent };

	$shape->draw_black;
	$shape->move_to( $e->motion_x,  $e->motion_y, $p->{ w }, $p->{ h } );
}



sub on_press {
	my( $shape, $h, $e ) =  @_;

}



sub on_release {
	my( $shape, $h, $e ) =  @_;

	$shape->moving_off;
}


sub on_group {
	my( $shape, $h, $e, $group_info ) =  @_;

	my $rect =  Rect->new( $h->{ x }, $h->{ y } );
	$rect->{ parent } = $shape;
	weaken $rect->{ parent };
	$rect->store;
	$rect->to_group( $group_info->{ grouped } );
	$rect->{ children } =  $group_info->{ grouped };
	$rect->save_prev;  ## Change parent to new one

	$shape->{ children } =  $group_info->{ alone };
	push $shape->{ children }->@*, $rect;

	$shape->store;
}



sub is_drop {
}

1;
