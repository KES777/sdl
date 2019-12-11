package Shape;

use strict;
use warnings;

use Scalar::Util qw(weaken);

use Rect;
use SDL::Event;


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



sub on_drag {
	my( $shape, $e, $h ) =  @_;

	if( $h->{ app }{ event_state }{ SDLK_d() }
		&&  $h->{ app } !=  $shape->{ parent }## или !$shape->{ parent_id }
	) {
		$shape->drag( $h );
	}

	$h->{ event_start_x } =  $e->motion_x;
	$h->{ event_start_y } =  $e->motion_y;
	$shape->moving_enable( $e, $h );
}



sub on_drop {
	my( $shape, $h, $e ) =  @_;

	$shape->moving_disable( $e, $h );
	if( my $target =  $shape->can_drop( $e->motion_x, $e->motion_y, $h ) ) {
		$shape->drop( $target->{ target }, $h, $e->motion_x, $e->motion_y );
	}
	else {
		$shape->store;
	}
}



sub moving_enable {
	my( $shape ) =  @_;

	$shape->save_state();
	$shape->{ c } =  Color->new( 0, 0, 200 );
}



sub moving_disable {
	my( $shape ) =  @_;

	$shape->restore_state;
}



sub on_press {
	my( $shape, $h, $e ) =  @_;

	# warn "Object does not define this behavior yet. http://";
	# 	if DEBUG;
}



## Передвигает объект в соответствии с координатами курсора
sub move_to {
	my( $shape, $x, $y ) =  @_;

	$shape->{ x } =  $x //0;
	$shape->{ y } =  $y //0;
}



sub move_by {
	my( $shape, $dx, $dy ) =  @_;

	$shape->{ x } +=  $dx //0;
	$shape->{ y } +=  $dy //0;
}



sub get_points {
	my( $shape ) =  @_;
	return [ $shape->{ x }, $shape->{ y } ];
}



sub clip {
	my( $shape, $target ) =  @_;

	$target //=  $shape->{ parent }
		or return;

	for my $point ( $shape->get_points ) {
		$target->mouse_target( @$point )
			or return;
	}

	return 1;
}



##
sub on_move {
	my( $shape, $e, $h ) =  @_;

	my $dx =  $e->motion_x -$h->{ event_start_x };
	my $dy =  $e->motion_y -$h->{ event_start_y };


	$shape->move_to(
		$h->{ target }{ start_x } +$dx,
		$h->{ target }{ start_y } +$dy,
	);
	$shape->clip;
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
	my( $shape, $h ) =  @_;

	my $app_rect =  $h->{ app };
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
		$x +=  $shape->{ parent }->{ x } - $shape->{ parent }->{ radius };
		$y +=  $shape->{ parent }->{ y } - $shape->{ parent }->{ radius };

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
	my( $drop, $group, $h,  $drop_x, $drop_y ) =  @_;

	my $app_rect =  $h->{ app };
	$drop->parent_id( $group->{ id } );## Присвоили id группы
	$drop->draw_black;## Затираем перед тем, как удалим из $app_rect->{ children }

	push $group->{ children }->@*, $drop;## Добавили объект в группу
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
	my( $shape ) = @_;

	my $child =  Util::db()->resultset( 'Rect' )->search({
		parent_id => $shape->{ id }
	});

	$shape->{ children } =  [ map{
		my $type =  defined $_->radius? 'Circle' : 'Rect';
		$type->new( $_ );
	} $child->all ];
	for my $x ( $shape->{ children }->@* ) {
		$x->{ parent_id } =  $shape->{ id };############parent_id
		$x->{ parent } =  $shape;
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

	$h->{ app }->draw_black;
	$h->{ app }->refresh_over( $e->motion_x, $e->motion_y );
}



sub on_hint {
	my( $shape, $h, $e ) =  @_;

	# Table->new->draw;
	# $h->{ app }->refresh_over( $e->motion_x, $e->motion_y );
}



sub on_release { }

sub on_keydown { }
sub on_keyup   { }

sub draw {
	shift->propagate( draw => @_ );
	# shift->propagate( 'draw', @_ );
}



sub propagate {
	my( $shape, $event ) =  ( shift, shift );

	if( $shape->{ children } ) {
		for my $s ( $shape->{ children }->@* ) {
			$s   or next;
			# $s->$event( @_ );## это не работает
			if( my $target =  $s->$event( @_ ) ) {
				return $target;
			}
		}
	}
}




# Функция возвращает объект, над которым находится мышка.
# Дополнительно сохранаяет информацию о координатах мыши.
sub is_over {
	my( $shape, $x, $y ) =  @_;

	if( $shape->mouse_target( $x, $y ) ) {
 		$x -=  $shape->{ x };
		$y -=  $shape->{ y };
		return $shape->propagate( is_over => $x, $y )  ||  {
			# Объект, над которым находится мышь
			target =>  $shape,
			# Координаты мыши отностельно левого верхнего угла объекта
			x =>  $x,
			y =>  $y,
		};
	}

	return;
}



sub new {
	my( $shape ) =  shift;

	return bless {}, $shape;
}



## Сохранение (обновление) объекта в базу
sub store {
	my( $shape ) =  @_;

	if( $shape->{ id } ) {
		my $row =  Util::db()->resultset( 'Rect' )->search({
			id => $shape->{ id },
		})->first;
		$row->update({
			$shape->%{qw/ x y w h radius parent_id/},
			$shape->{ c }->geth,
		});
	}
	elsif( $shape->{ parent } ) {
		my $row =  Util::db()->resultset( 'Rect' )->create({
			$shape->%{qw/ x y w h radius /},
			$shape->{ c }->geth,
		});

		$shape->{ id } =  $row->id;
	}

	for my $r ( $shape->{ children }->@* ) {
		$r->store;
	}

	return $shape;
}




sub draw_black {
	my( $shape ) =  @_;

	Rect->draw_black;
}



sub children {
	@_ > 1   or return shift->{ children };


	my( $shape, @children ) =  @_;

	for my $c ( @children ) {
		$c->{ parent } =  $shape;
		weaken $c->{ parent };
	}
	push $shape->{ children }->@*, @children;


	return $shape->{ children };
}



1;
