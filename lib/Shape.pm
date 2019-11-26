package Shape;

use strict;
use warnings;

use Scalar::Util qw(weaken);

use Rect;


# sub is_moveable {
# 	my( $shape, $event_obj ) =  @_;

# 	$shape->move_color( $event_obj->{ x }, $event_obj->{ y } );
# 	return $event_obj;
# }



sub on_press {
	my( $shape, $h, $e ) =  @_;

	# warn "Object does not define this behavior yet. http://";
	# 	if DEBUG;
}



sub on_move {
	my( $shape, $h, $e, $app_rect ) =  @_;

	my $p =  $shape->{ parent };

	$shape->draw_black;
	$shape->move_to( $e->motion_x,  $e->motion_y, $p->{ w }, $p->{ h } );
}





sub on_group {
	my( $shape, $h, $e, $group_info ) =  @_;

	my $rect =  Rect->new( $h->{ x }, $h->{ y } );
	$rect->{ parent } = $shape;# Объект не имеющий parent не сохранится в базе
	weaken $rect->{ parent };

	$rect->store;
	$rect->calc_group_size( $group_info->{ grouped } );

	$rect->{ children } =  $group_info->{ grouped };
	for my $child( $rect->{ children }->@* ) {
		$child->parent_id( $rect->{ id } );
	}

	$rect->load_parent_data;  ## Change parent to new one

	$shape->{ children } =  $group_info->{ alone };
	push $shape->{ children }->@*, $rect;
	$shape->store;
}



sub drop {
	my( $group, $drop, $app_rect, $drop_x, $drop_y ) =  @_;

	$drop->draw_black;
	$group->draw_black;
	$drop->parent_id( $group->{ id } );

	push $group->{ children }->@*, $drop;
	$group->load_parent_data;
	$app_rect->{ children }->@* =  grep{ $_ != $drop } $app_rect->{ children }->@*;

	my @children =   $group->{ children }->@*;
	$group->calc_group_size( \@children );

	if( $group->{ parent }{ id } ) {
		$group->{ parent }->resize_group;
	}

	$group->store_group;
}



sub store_group {
	my( $shape ) =  @_;

	$shape->store;

	if( my $p =  $shape->{ parent } ) {
		$p->store_group;
	}
}



sub resize {
	my( $shape, $x, $y ) =  @_;

	# $shape->on_resize;
	$shape->draw_black;
	$shape->resize_to( $x, $y );
}



1;
