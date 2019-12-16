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

	$h->{ event_start_x } =  $h->{ event_old_x } =  $e->motion_x;
	$h->{ event_start_y } =  $h->{ event_old_y } =  $e->motion_y;
	$shape->moving_enable( $e, $h );
}



sub on_drop {
	my( $shape, $e, $h ) =  @_;

	$shape->moving_disable( $e, $h );
	if( ( my $target =  $shape->can_drop( $e->motion_x, $e->motion_y, $h ) )
		&&  $h->{ app }{ event_state }{ SDLK_d() }
	) {
		$shape->drop( $target->{ target }, $h, $e->motion_x, $e->motion_y );
	}
	else {
		$shape->store;
		## Установка минимального размера группы
		if( $shape->{ parent_id } ) {
			$shape->{ parent }->set_min_size;
		}
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

	my $dx =  $e->motion_x -$h->{ event_old_x };
	my $dy =  $e->motion_y -$h->{ event_old_y };
	$h->{ event_old_x } =  $e->motion_x;
	$h->{ event_old_y } =  $e->motion_y;

	$shape->move_by( $dx, $dy );
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

	$shape->resize_to( $shape->calc_size_values( $x, $y ) );
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


sub on_triple_click {}



sub on_hint {
	my( $shape, $h, $e ) =  @_;

	# Table->new->draw;
	# $h->{ app }->refresh_over( $e->motion_x, $e->motion_y );
}



sub on_release { }

sub on_keydown { }
sub on_keyup   { }


sub save_draw_coord {
	my( $shape ) =  @_;

	$shape->{ ox } =  $shape->{ x };
	$shape->{ oy } =  $shape->{ y };
}


sub refresh {
	my( $shape ) =  @_;

	$shape->draw_black;
	$shape->draw;
	$shape->save_draw_coord;
}

sub draw_black {}
sub draw {
	shift->propagate( draw => @_ );
}



sub propagate {
	my( $shape, $event ) =  ( shift, shift );

	my $children =  $shape->{ children }   or return;

	for my $s ( @$children ) {
		$s   or next;
		if( my $target =  $s->$event( @_ ) ) {
			return $target;
		}
	}

	return;
}




# Функция возвращает объект, над которым находится мышка.
# Дополнительно сохранаяет информацию о координатах мыши.
sub is_over {
	my( $shape, $x, $y ) =  @_;

	if( $shape->mouse_target( $x, $y ) ) {
		# DB::x   if ref $shape eq 'Table';
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



## Пересчитывает размер группы в соответствии с её содержимым
sub organize_group {
	my( $group, $children ) =  @_;

	my $padding =  10;
	my $h       =  $padding;
	my $w;
	my( $gx, $gy ) =  $group->object_handle;

	for my $shape_i ( @$children ) {
		my( $hi, $wi ) =  $shape_i->get_size;
		my( $dx, $dy ) =  $shape_i->shape_handle;

		$shape_i->set_shape_to( $padding, $dx, $dy, $gx, $gy, $h );

		$h +=  $hi + $padding;
		$w =  $wi + $padding * 2 < $w ? $w : $wi + $padding * 2;
	}

	$group->set_group_size( $h, $w );
}



sub draw {
	my( $rect, $x, $y ) = @_;

	my $screen =  AppRect::SCREEN();
	$x //=  0;
	$y //=  0;

	$x += $rect->{ x };
	$y += $rect->{ y };

	my( $h, $w )   =  $rect->get_size;
	$screen->draw_rect([
		$x,
		$y,
		$w,
		$h,
	],[
		255,0,0,255
	]);
	#circuit
	$screen->draw_rect([
		$x +1,
		$y +1,
		$w-2,
		$h-2,
	],[
		$rect->{ c }->get()
	]);

	#size_button
	my( $sb_x, $sb_y, $sb_w, $sb_h ) =  $rect->get_sb_coords( $x, $y );
	$screen->draw_rect([
		$sb_x,
		$sb_y,
		$sb_w,
		$sb_h,
	],[
		33, 200, 150, 255
	]);


	$rect->propagate( draw => $x, $y );
}







1;
