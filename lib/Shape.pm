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
			my( $min_h, $min_w ) =  $shape->{ parent }->calc_min_size;
			$shape->{ parent }->min_h( $min_h );
			$shape->{ parent }->min_w( $min_w );
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



## Передвигает объект в соответствии с координатами курсора!!!
sub move_to {
	my( $shape, $x, $y, $border ) =  @_;

	my( $h, $w ) =  $shape->get_size;
	if( $border ) {
		my( $ph, $pw ) =  $shape->{ parent }->get_size;

		my $min_x =  0;
		my $min_y =  0;

		$shape->{ x } =  Util::max( Util::min( $x, $pw - $w ), $min_x );
		$shape->{ y } =  Util::max( Util::min( $y, $ph - $h ), $min_y );
	}
	else {
		$shape->{ x } =  $x;
		$shape->{ y } =  $y;
	}
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

	my $border  =  1;
	$shape->move_to( $shape->calc_move_values( $dx, $dy ), $border );
}



sub calc_move_values {
	my( $shape, $dx, $dy ) =  @_;

	return ( $shape->{ x } + $dx, $shape->{ y } + $dy );
}



## Создание группы из объектов выделенных полем selection
sub on_group {
	my( $shape, $h, $e, $group_info ) =  @_;

	my $rect =  Rect->new( $h->{ draw }->{ x }, $h->{ draw }->{ y } );
	$rect->{ parent } = $shape;# Объект не имеющий parent не сохранится в базе
	weaken $rect->{ parent };

	$rect->store;
	$rect->organize_group( $group_info->{ grouped } );

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

	$group->organize_group( $children );

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
	# $drop->draw_black;## Затираем перед тем, как удалим из $app_rect->{ children }

	push $group->{ children }->@*, $drop;## Добавили объект в группу
	$group->load_parent_data;

	$app_rect->{ children }->@* =  grep{ $_ != $drop } $app_rect->{ children }->@*;

	my @children =   $group->{ children }->@*;
	$group->organize_group( \@children );

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

	my $border =  1;
	$shape->resize_to( $shape->calc_size_values( $x, $y ), $border );
}



## Изменяет размер объекта в соответсвии с координатами курсора
sub resize_to {
	my( $shape, $h, $w, $border ) =  @_;

	if( $border ) {
		my $parent =  $shape->{ parent };
		my $max_h =  $shape->max_h // $parent->max_h;
		my $max_w =  $shape->max_w // $parent->max_w;
		my $min_h =  $shape->min_h // $parent->min_h;
		my $min_w =  $shape->min_w // $parent->min_w;

		$shape->set_size(
			Util::max( Util::min( $h, $max_h ), $min_h ),
			Util::max( Util::min( $w, $max_w ), $min_w ),
		);
	}
	else {

		$shape->set_size( $h, $w );
	}
}



# # Возвращает размер объекта ( h, w )
sub get_size {
	my( $shape ) =  @_;

	return ( $shape->{ h }, $shape->{ w } );
}



## Назначает размер объекта
sub set_size {
	my( $rect, $h, $w ) =  @_;

	$rect->{ h } =  $h;
	$rect->{ w } =  $w;
}



## Возвращает/присваивает max высоту объекта (max_h)
sub max_h {
	@_ > 1   or return shift->{ max_h };

	my( $shape, $max_h ) =  @_;

	return $shape->{ max_h } =  $max_h;
}



## Возвращает/присваивает max ширину объекта (max_w)
sub max_w {
	@_ > 1   or return shift->{ max_w };

	my( $shape, $max_w ) =  @_;

	return $shape->{ max_w } =  $max_w;
}



## Возвращает/присваивает min высоту объекта (min_h)
sub min_h {
	@_ > 1   or return shift->{ min_h };

	my( $shape, $min_h ) =  @_;

	return $shape->{ min_h } =  $min_h;
}



## Возвращает/присваивает min ширину объекта (min_w)
sub min_w {
	@_ > 1   or return shift->{ min_w };

	my( $shape, $min_w ) =  @_;

	return $shape->{ min_w } =  $min_w;
}



## Включает свойство click
sub on_click {
	my( $shape, $h, $e ) =  @_;

	$h->{ app }->refresh_over( $e->motion_x, $e->motion_y );
}



sub on_double_click {
	my( $shape, $h, $e ) =  @_;


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


# sub save_draw_coord {
# 	my( $shape ) =  @_;

# 	$shape->{ ox } =  $shape->{ x };
# 	$shape->{ oy } =  $shape->{ y };
# }


# sub refresh {
# 	my( $shape ) =  @_;

# 	$shape->draw_black;
# 	$shape->draw;
# 	$shape->save_draw_coord;
# }

sub draw_black {}



## Передаёт в назначенную($event) функцию всех детей перента с аргументами
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



## Смещение всех объектов поверхности в соответствии с координатами мыши
sub on_shift {
	my( $shape, $h, $x, $y ) =  @_;

	if( $shape->{ old_x }	&&	$shape->{ old_y } ) {
		my $border;
		$shape != $h->{ app }  or  $border =  1;

		my $dx =  $shape->{ old_x } - $x;
		my $dy =  $shape->{ old_y } - $y;

		for my $s( $shape->{ children }->@* ) {
			my $sx =  $s->{ x } - $dx;
			my $sy =  $s->{ y } - $dy;

			$s->move_to( $sx, $sy, $border );
		}
	}

	$shape->{ old_x } =  $x;
	$shape->{ old_y } =  $y;
}



## Отключение смещения объектов
sub off_shift {
	my( $shape ) =  @_;

	# $shape->propagate( "store" )## Функция store возвращает объект, из-за этого
	## propagate делает return. В итоге обрабатывается лишь один элемент из массива.
	for my $s( $shape->{ children }->@* ) {## При таком порядке не сохраняем min/max  в базу
		$s->store;
	}
	my( $min_h, $min_w ) =  $shape->calc_min_size;
	$shape->min_h( $min_h );
	$shape->min_w( $min_w );
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



## Назначение чилдренам их пэрэнта
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


## Рассчёт минимального размера группы в соответствии с размером её чилдренов
sub calc_min_size {
	my( $circle ) =  @_;

	my $h;
	my $w;
	my $padding =  10;
	for my $shape_i( $circle->{ children }->@* ) {
		my( $hi, $wi ) =  $shape_i->get_size;
		my( $x, $y)    =  ( $shape_i->{ x }, $shape_i->{ y } );

		$hi =  $y + $hi + $padding;
		$h  =  $hi > $h ? $hi : $h;

		$wi =  $x + $wi + $padding;
		$w  =  $wi > $w ? $wi : $w;
	}

	return ( $h, $w );
}



## Пересчитывает размер группы в соответствии с её содержимым
sub organize_group {
	my( $group, $children ) =  @_;

	my $padding =  10;
	my $h       =  $padding;
	my $w;
	for my $shape_i ( @$children ) {
		my( $hi, $wi ) =  $shape_i->get_size;

		$shape_i->move_to( $padding, $h );
		$h +=  $hi + $padding;
		$w =  $wi + $padding * 2 < $w ? $w : $wi + $padding * 2;
	}

	$group->set_group_size( $h, $w );
}


## Отрисовка всех объектов
sub draw {
	my( $shape, $x, $y ) = @_;

	my $screen =  AppRect::SCREEN();
	$x //=  0;
	$y //=  0;

	$x += $shape->{ x };
	$y += $shape->{ y };

	my( $h, $w ) =  $shape->get_size;
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
		$shape->{ c }->get()
	]);

	#size_button
	my( $sb_x, $sb_y, $sb_w, $sb_h ) =  $shape->get_sb_coords( $x, $y );
	$screen->draw_rect([
		$sb_x,
		$sb_y,
		$sb_w,
		$sb_h,
	],[
		33, 200, 150, 255
	]);


	$shape->propagate( draw => $x, $y );
}



1;
