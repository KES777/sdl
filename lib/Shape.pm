package Shape;

use strict;
use warnings;

use Scalar::Util qw(weaken);

use Rect;


sub is_moveable {
	my( $shape, $event_obj ) =  @_;

	$shape->moving_on( $event_obj->{ x }, $event_obj->{ y } );
	return $event_obj;
}



sub on_over {
	my( $shape, $h, $app_rect ) =  @_;
	$app_rect->{ first } =  $shape;
}



sub on_move {
	my( $shape, $h, $e, $app_rect ) =  @_;

	my $p =  $shape->{ parent };

	$shape->draw_black;
	$shape->move_to( $e->motion_x,  $e->motion_y, $p->{ w }, $p->{ h } );

	$app_rect->{ first } =  $shape;
}



sub on_press {
	my( $shape, $h, $e ) =  @_;

}



sub on_release {
	my( $shape, $h, $e, $app_rect ) =  @_;

	$shape->moving_off( $e, $app_rect );

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



sub is_over_shape {
	my( $shape, $x, $y ) =  @_;

	my $over =  $shape->is_over( $x, $y );
		return $over;
}




sub is_over_rf {
	my( $shape, $x, $y ) =  @_;

	$shape->resize_field( $x, $y );
}



sub resize_shape {
	my( $shape, $x, $y, $app_rect ) =  @_;
# DB::x;
	$shape->resize_to( $x, $y );
}


1;
