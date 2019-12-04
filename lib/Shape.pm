package Shape;

use strict;
use warnings;

use Scalar::Util qw(weaken);

use Rect;


sub is_moveable {
	my( $shape, $event_obj ) =  @_;

	return $event_obj;
}



sub on_mouse_over {
	my( $shape, $h, $e ) =  @_;


}



sub on_mouse_out {
	my( $shape ) =  @_;
}



 sub moving_on {
	my( $shape, $e ) =  @_;

	$shape->save_state( $e->motion_x, $e->motion_y );
	$shape->{ c } =  Color->new( 0, 0, 200 );
}



sub moving_off {
	my( $shape ) =  @_;

	$shape->restore_state;
}



sub on_press {
	my( $shape, $h, $e ) =  @_;

	# warn "Object does not define this behavior yet. http://";
	# 	if DEBUG;
}


##
sub on_move {
	my( $shape, $h, $e, $app_rect ) =  @_;

	my $p =  $shape->{ parent };

	$shape->draw_black;
	$shape->move_to( $e->motion_x,  $e->motion_y, $p->{ w }, $p->{ h } );
}



## Создание группы из объектов выделенных полем selection
sub on_group {
	my( $shape, $h, $e, $group_info ) =  @_;

	my $rect =  Rect->new( $h->{ draw }->{ x }, $h->{ draw }->{ y } );
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


## Извлечение объекта из группы
sub drag {
	my( $shape, $h, $app_rect, $e ) =  @_;

	$h->{ owner }->draw_black;
	my $group =  $shape->{ parent };
	my $children =  $group->{ children };
	$shape->detach( $children );## Удаляем вытянутый объект из числа детей его родителя

	$group->calc_group_size( $children );

	if( $group->{ parent }{ id } ) {
		$group->{ parent }->resize_group;
	}

	$group->store_group;

	#изменить координаты на абсолютные
	my( $x, $y ) =  $shape->parent_coord( $shape->{ x }, $shape->{ y } );
	$shape->{ x } =  $x;
	$shape->{ y } =  $y;
	# DDP::p $shape;


	$shape->{ parent_id } =  undef;
	$shape->{ parent } =  $app_rect;
	#запушить в app_rect->{ children }
	push $app_rect->{ children }->@*, $shape;
}


## Координаты родителя
sub parent_coord {
	my( $shape, $x, $y ) =  @_;

	if( $shape->{ parent } ) {
		$x +=  $shape->{ parent }->{ x };
		$y +=  $shape->{ parent }->{ y };

		( $x, $y ) =  $shape->{ parent }->parent_coord( $x, $y );
	}

	return ( $x, $y );
}


## Удаляем извлечённый объект из числа детей его родителя
sub detach {
	my( $shape, $children ) =  @_;

	@$children =  grep{ $_ != $shape } @$children;
}


## Помещаем объект внутрь другого объекта, или группы
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


## Загружает из базы объекту его детей (создавая объекты для каждого ребёнка)
## Загружает по рекурсии всем вложеным объектам их детей
sub load_children {
	my( $rect ) = @_;

	my $child =  Util::db()->resultset( 'Rect' )->search({
		parent_id => $rect->{ id }
	});

	$rect->{ children } =  [ map{
		my $type =  defined $_->radius? 'Circle' : 'Rect';
		$type->new( $_ );
	} $child->all ];
	for my $x ( $rect->{ children }->@* ) {
		$x->{ parent_id } =  $rect->{ id };############parent_id
		$x->{ parent } =  $rect;
		weaken $x->{ parent };

		$x->load_children;
	}
}




## Сохраняем (обновляем) все объекты грууппы, которые менялись, в базу
sub store_group {
	my( $shape ) =  @_;

	$shape->store;

	if( my $p =  $shape->{ parent } ) {
		$p->store_group;
	}
}


## Изменение размеров объекта
sub resize {
	my( $shape, $x, $y ) =  @_;

	$shape->draw_black;
	$shape->resize_to( $x, $y );
}



## Включает свойство click/dbclick
sub on_click {
	my( $shape, $h, $e ) =  @_;

	# $shape->{ w } -=  30;
	$h->{ app }->refresh_over( $e->motion_x, $e->motion_y );
}



sub on_double_click {
	my( $shape, $h, $e ) =  @_;

	# $shape->{ w } +=  50;
	$h->{ app }->refresh_over( $e->motion_x, $e->motion_y );
}



sub on_hint {
	my( $shape, $h, $e ) =  @_;

	# $shape->{ x } -=  20;
	$h->{ app }->refresh_over( $e->motion_x, $e->motion_y );### вызывает on_press (создаёт новый объект)
}



sub on_release { }

sub on_keydown { }
sub on_keyup   { }

1;
