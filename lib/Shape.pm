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



sub on_group {
	my( $shape, $h, $e, $group_info ) =  @_;

	my $rect =  Rect->new( $h->{ x }, $h->{ y } );
	$rect->{ parent } = $shape;
	weaken $rect->{ parent };
	$rect->store;
	$rect->calc_groupe_size( $group_info->{ grouped } );
	$rect->{ children } =  $group_info->{ grouped };
	$rect->save_prev;  ## Change parent to new one

	$shape->{ children } =  $group_info->{ alone };
	push $shape->{ children }->@*, $rect;

	$shape->store;
}



sub drop {
	my( $group, $drop, $app_rect, $drop_x, $drop_y ) =  @_;

	$drop->draw_black;
	$group->draw_black;
	$drop->parent( $group->{ id } );#сохраняем в базе parent_id

	push $group->{ children }->@*, $drop;
	$group->save_prev;#FIX
	$app_rect->{ children }->@* =  grep{ $_ != $drop } $app_rect->{ children }->@*;

	my @children =   $group->{ children }->@*;
	$group->calc_groupe_size( \@children );

	if( $group->{ parent }{ id } ) {
	$group->{ parent }->resize_group;
	}


}



sub is_over_shape {
	my( $shape, $x, $y ) =  @_;

	my $over =  $shape->is_over( $x, $y );
		return $over;
}



sub resize_shape {
	my( $shape, $x, $y, $app_rect ) =  @_;

	$shape->on_resize;
	$shape->draw_black;
	$shape->resize_to( $x, $y );
}



sub off_resize_shape {
	my( $shape, $app_rect ) =  @_;

	$shape->off_resize( $app_rect );
}



1;
