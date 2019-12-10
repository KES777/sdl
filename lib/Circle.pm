package Circle;

use strict;
use warnings;


use Scalar::Util qw(weaken);

use AppRect;
use Color;
use base 'Shape';


my $START_R =  25;

my $y_offset_n =  0;
my $x_offset   =  50;
my $y_offset   =  50;
sub new {
	if( ref $_[1] eq 'Schema::Result::Rect' ) {
		my( $rect, $db_rect ) =  @_;

		$rect =  $rect->new(
			$db_rect->x, $db_rect->y, $db_rect->radius,
			Color->new( $db_rect->r, $db_rect->g, $db_rect->b, $db_rect->a ),
		);
		$rect->{ id } =  $db_rect->id;
		return $rect;
	}


	my( $rect, $x, $y, $r, $c ) =  @_;

	$x //=  ($x_offset += 30);
	$y //=  $y_offset_n * 5  + ($y_offset +=  10);

	if( $x_offset > 600 ) {
		$x_offset =  40;
		$y_offset =  50;
		$y_offset_n++;
	}

	$rect =  $rect->SUPER::new();

	my %rect = (
		x      => $x,
		y      => $y,
		radius => $r // $START_R,
		c      => $c // Color->new,
	);
	$rect->@{ keys %rect } =  values %rect;

	return $rect;
}



sub draw_black {
	my( $circle, $screen, $x, $y ) = @_;

	$screen //=  AppRect::SCREEN();
	$x //=  0;
	$y //=  0;

	$x +=  $circle->{ ox } // $circle->{ x };
	$y +=  $circle->{ oy } // $circle->{ y };

	my $r    =  $circle->{ oradius } // $circle->{ radius };
	my $diam =  $r * 2;
	$screen->draw_rect([
		$x -$r,
		$y -$r,
		$diam,
		$diam,
	],[ 0, 0, 0, 0 ]);
}




sub draw {
	my( $circle, $screen, $x, $y ) = @_;

	if( !$circle->{ parent }{ id } ) {
		$circle->draw_black;
		$circle->save_draw_coord;
	}

	$screen //=  AppRect::SCREEN();
	$x //=  0;
	$y //=  0;

	$x += $circle->{ x };
	$y += $circle->{ y };

	my $r    =  $circle->{ radius };
	my $diam =  $r * 2;
	$screen->draw_rect([
		$x -$r,
		$y -$r,
		$diam,
		$diam,
	],[
		255,0,0,255
	]);
	#circuit
	$screen->draw_rect([
		$x -$r +2,
		$y -$r +2,
		$diam-4,
		$diam-4,
	],[
		$circle->{ c }->get()
	]);

	#size_button
	$screen->draw_rect([
		$x + $r -15,
		$y -5,
		15,
		10,
	],[
		33, 200, 150, 255
	]);


	if( $circle->{ children } ) {
		for my $s ( $circle->{ children }->@* ) {
			$s->draw( $screen, $x -$r, $y -$r );
		}
	}
}



## Сохраняет состояние объекта для draw_black его перед следующей отрисовкой
sub save_draw_coord {
	my( $circle ) =  @_;

	$circle->{ ox } =  $circle->{ x };
	$circle->{ oy } =  $circle->{ y };
	$circle->{ oradius } =  $circle->{ radius };
}



## Сохранение (обновление) объекта в базу
# sub store {
# 	my( $rect ) =  @_;

# 	if( $rect->{ id } ) {
# 		my $row =  Util::db()->resultset( 'Rect' )->search({
# 			id => $rect->{ id },
# 		})->first;
# 		$row->update({
# 			$rect->%{qw/ x y radius parent_id/},
# 			$rect->{ c }->geth,
# 		});
# 	}
# 	elsif( $rect->{ parent } ) {
# 		my $row =  Util::db()->resultset( 'Rect' )->create({
# 			$rect->%{qw/ x y radius /},
# 			$rect->{ c }->geth,
# 		});

# 		$rect->{ id } =  $row->id;
# 	}

# 	for my $r ( $rect->{ children }->@* ) {
# 		$r->store;
# 	}

# 	return $rect;
# }



# Функция возвращает объект, над которым находится мышка.
# Дополнительно сохранаяет информацию о координатах мыши.
sub is_over_in {
	my( $shape, $x, $y ) =  @_;

	if( !$shape->{ parent_id } ) {
		my $target =   mouse_target_square( $shape, $x, $y );
			return $target, $x, $y;
	}
	else {
		$x = $x - $shape->{ parent }{ x } + $shape->{ parent }{ radius };
		$y = $y - $shape->{ parent }{ y } + $shape->{ parent }{ radius };
		my $target =  mouse_target_square( $shape, $x, $y );
			return $target, $x, $y;
	}
}




sub mouse_target_square {
	my( $circle, $x, $y ) =  @_;

	my $r =  $circle->{ radius };

	$x >= $circle->{ x } -$r
	&&  $x <= $circle->{ x } + $r
	&&  $y >= $circle->{ y } - $r
	&&  $y <= $circle->{ y } + $r
		or return;

	my $a =  abs( $x - $circle->{ x } );
	my $b =  abs( $y - $circle->{ y } );
	my $c =  sqrt( $a ** 2 + $b ** 2 );

	return $c <= $r;
}



sub is_over_res_field {
	my( $shape, $x, $y ) =  @_;

	$shape->Util::resize_field_circle( $x, $y );
}


## Сохранение состояние объекта
sub save_state {
	my( $rect, $tp_x, $tp_y ) =  @_; # tp - take point


	$rect->{ start_x } =  $rect->{ x };
	$rect->{ start_y } =  $rect->{ y };

	$rect->{ start_c } =  $rect->{ c };

	$rect->{ dx } =  $tp_x - $rect->{ x } - $rect->{ radius };
	$rect->{ dy } =  $tp_y - $rect->{ y } - $rect->{ radius };
}



## Восстановление  состояния объекта
sub restore_state {
	my( $rect ) =  @_;

	$rect->{ c } =  delete $rect->{ start_c };
	delete $rect->@{qw/ dx dy start_x start_y /};
}



## Передвигает объект в соответствии с координатами курсора
sub move_to {
	my( $rect, $x, $y, $app_w, $app_h ) =  @_;


	$rect->{ x } =  $x - $rect->{ dx } - $rect->{ radius } //0;
	$rect->{ y } =  $y - $rect->{ dy } - $rect->{ radius } //0;

	if( $rect->{ x } < $rect->{ radius } ) {
		$rect->{ x } = $rect->{ radius };
	}
	if( $rect->{ y } < $rect->{ radius } ) {
		$rect->{ y } = $rect->{ radius };
	}

	if( $app_w  &&  $rect->{ x } > $app_w - $rect->{ radius }) {
		$rect->{ x } = $app_w - $rect->{ radius };
	}
	if( $app_h  &&  $rect->{ y } > $app_h - $rect->{ radius }) {
		$rect->{ y } = $app_h - $rect->{ radius };
	}
}



# Делает проверку, что объект $rect находится внутри квадрата x,y,w,h
sub is_inside {
	my( $rect, $x, $y, $w, $h ) =  @_;

	return $rect->{ x } > $x  &&  $rect->{ x } + $rect->{ radius } * 2 < $x + $w
		&& $rect->{ y } > $y  &&  $rect->{ y } + $rect->{ radius } * 2 < $y + $h;
}



## Проверка условия, при котором возможно выполнить drop для объекта
## Проверка - находится ли объект над другим объектом(возвращает этот объект)
sub can_drop {
	my( $rect, $drop_x, $drop_y, $h ) =  @_;

	my( $group, $child );
	for my $s ( $h->{ app }{ children }->@* ) {
		$s != $rect   or next;
		my $curr =  $s->is_over( $drop_x, $drop_y )   or next;

		$group =  $s;
		$child =  $curr;
		# last;
		return $curr;
	}
}



## Запись в базу parent_id для объекта
sub parent_id {
	my( $rect, $id ) =  @_;

	Util::db()->resultset( 'Rect' )->search({
		id => $rect->{ id },
	})->first->update({ parent_id => $id });

	$rect->{ parent_id } =  $id;
}



## Пересчитывает размер группы в соответствии с её содержимым
sub calc_group_size {
	my( $group, $children ) =  @_;

	my $w =   0;
	my $h =  10;

	for my $s ( @$children ) {
		if( $s->{ radius } ) {
			my $r =  $s->{ radius };
			$s->move_to( 10 + $r * 2, $h + $r * 2 );
			if( $s->{ c }{ b } < 225 ) {
				$s->{ c }{ b } =  $group->{ c }{ b } + 30;
			}

			$h +=  $r * 2 + 10;
			$w  =  $r * 2 > $w ? $r * 2 : $w;
		}
		else {
			$s->move_to( 10, $h );
			$s->{ c }{ r } =  $group->{ c }{ r } + 80;

			$h +=  $s->{ h } +10;
			$w  =  $s->{ w } > $w ? $s->{ w } : $w;
		}
	}

	my $res;

	$res =  $h < $w + 20 ? $w + 20 : $h;
	$group->{ radius } =  $res / 2;
	if( $group->{ radius } *2 < 50 ) {
		$group->{ radius } =  25;
	}

}



sub resize_group {
	my( $parent ) =  @_;

	my @children =  $parent->{ children }->@*;
	$parent->calc_group_size( \@children );

	if( $parent->{ parent }{ id } ) {
		$parent->{ parent }->resize_group;
	}
}




## Удаляет объект(пришедший в функцию) из числа детей его родителя
sub child_destroy {
	my( $square ) = @_;

	Util::db()->resultset( 'Rect' )->search({
		id => $square->{ id }
	})->delete;

	if( $square->{ children }->@* ) {

		for my $child ( $square->{ children }->@* ) {
			$child->child_destroy;
		}
	}
}



sub load_parent_data {
	my( $rect ) =  @_;
	for my $child( $rect->{ children }->@* ) {
		$child->{ parent } =   $rect;
		weaken $child->{ parent };
	}
}



sub resize_color {
	my( $rect ) =  @_;

	if( !$rect->{ start_c } ) {
		$rect->{ start_c  } =  $rect->{ c };
		$rect->{ c } =  Color->new( 0, 200, 0 );
	}
}



## Меняет цвет объекта-кнопки (если над ней курсор)
sub on_mouse_over {
	my( $btn ) =  @_;


	# $btn->{ c }{ b } =  250;
}



## Возвращает объекту-кнопке её цвет (когда курсор с него уходит)
sub on_mouse_out {
	my( $btn ) =  @_;

	# $btn->{ c }{ b } =  190;
}



sub on_press {
	my( $shape, $h, $e ) =  @_;

}



## Изменяет размер объекта в соответсвии с координатами курсора
sub resize_to {
	my( $rect, $x, $y ) =  @_;

	$rect->{ radius } =  $x - $rect->{ x };
	if( $x - $rect->{ x } < 25 ) {
		$rect->{ radius } =  25;
	}

	$rect->{ children } or return;

	my $h = 10;
	for my $square( $rect->{ children }->@* ) {
		if( !$square->{ h }  &&  !$square->{ w } ) {
			$square->{ h } =  $square->{ radius } * 2;
			$square->{ w } =  $square->{ radius } * 2;
		}

		$h +=  $square->{ h } + 10;

		if ( $rect->{ radius } < ( $square->{ w } + 20 ) / 2 ) {
			$rect->{ radius } =  ( $square->{ w } + 20 ) / 2;
		}
		if( $square->{ radius } ) {
			delete $square->{ h };
			delete $square->{ w };
		}
	}

	if( $rect->{ radius } < $h / 2 ) {
		$rect->{ radius } =  $h / 2;
	}
}




1;
