package Circle;

use strict;
use warnings;


use Scalar::Util qw(weaken);

use AppRect;
use Color;
use base 'Shape';

my $MAX_R =  250;
my $MIN_R =   25;

my $START_R =  25;

my $y_offset_n =  0;
my $x_offset   =  50;
my $y_offset   =  50;
sub new {
	if( ref $_[1] eq 'Schema::Result::Rect' ) {
		my( $circle, $db_circle ) =  @_;

		$circle =  $circle->new(
			$db_circle->x, $db_circle->y, $db_circle->radius,
			Color->new( $db_circle->r, $db_circle->g, $db_circle->b, $db_circle->a ),
		);
		$circle->{ id } =  $db_circle->id;
		return $circle;
	}


	my( $circle, $x, $y, $r, $c ) =  @_;

	$x //=  ($x_offset += 30);
	$y //=  $y_offset_n * 5  + ($y_offset +=  10);

	if( $x_offset > 600 ) {
		$x_offset =  40;
		$y_offset =  50;
		$y_offset_n++;
	}

	$circle =  $circle->SUPER::new();

	my %circle = (
		x      => $x,
		y      => $y,
		radius => $r // $START_R,
		c      => $c // Color->new,

		min_r  => $MIN_R,
		max_r  => $MAX_R,
	);
	$circle->@{ keys %circle } =  values %circle;

	return $circle;
}



# sub save_draw_coord {
# 	my( $rect ) =  @_;

# 	$rect->SUPER::save_draw_coord;

# 	$rect->{ or } =  $rect->{ radius };

# }



## Сохраняет состояние объекта для draw_black его перед следующей отрисовкой
sub save_draw_coord {
	my( $circle ) =  @_;

	$circle->SUPER::save_draw_coord;

	$circle->{ oradius } =  $circle->{ radius };
}



sub mouse_target {
	my( $circle, $x, $y ) =  @_;

	my $r =  $circle->{ radius };
	my $diam = $r * 2;

	$x >= $circle->{ x }
	&&  $x <= $circle->{ x } + $diam
	&&  $y >= $circle->{ y }
	&&  $y <= $circle->{ y } + $diam
		or return;

	my $a =  abs( $x - $circle->{ x } - $r );
	my $b =  abs( $y - $circle->{ y } - $r );
	my $c =  sqrt( $a ** 2 + $b ** 2 );

	return $c <= $r;
}



## Проверяет находится ли курсор над полем для изменения размеров объекта
sub is_over_res_field {
	my( $circle, $x, $y ) =  @_;

	my $diam =  $circle->{ radius } * 2;
	return $x > $circle->{ x } + $diam - 15
		&& $x < $circle->{ x } + $diam
		&& $y > $circle->{ y } + $circle->{ radius } - 5
		&& $y < $circle->{ y } + $circle->{ radius } + 5
}



## Сохранение состояние объекта
sub save_state {
	my( $rect ) =  @_;


	$rect->{ start_x } =  $rect->{ x };
	$rect->{ start_y } =  $rect->{ y };

	$rect->{ start_c } =  $rect->{ c };
}



## Восстановление  состояния объекта
sub restore_state {
	my( $rect ) =  @_;

	$rect->{ c } =  delete $rect->{ start_c };
	delete $rect->@{qw/ start_x start_y /};
}






sub clip {}


# Делает проверку, что объект $rect находится внутри квадрата x,y,w,h
sub is_inside {
	my( $rect, $x, $y, $w, $h ) =  @_;

	return  $rect->{ x } - $rect->{ radius } > $x
		&&  $rect->{ x } + $rect->{ radius } < $x + $w
		&&  $rect->{ y } - $rect->{ radius } > $y
		&&  $rect->{ y } + $rect->{ radius } < $y + $h;
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



## Возвращает координаты (dx и dy) точки handle (привязки) объекта
sub object_handle {
	my( $circle ) =  @_;

	$circle->{ x } =  $circle->{ x } - $circle->{ radius };
	$circle->{ y } =  $circle->{ y } - $circle->{ radius };

	return $circle;
}



sub shape_handle {
	my( $circle ) =  @_;

	return ( $circle->{ radius }, $circle->{ radius } );
}



sub set_group_size {
	my( $circle, $h, $w ) =  @_;

	my $diam =  $h < $w ? $w : $h;
	$diam    =  $diam < 50 ? 50 : $diam;

	$circle->{ min_r } =  $circle->{ radius } =  $diam / 2;
}



sub set_shape_to {
	my( $circle, $padding, $dx, $dy, $gx, $gy, $h ) =  @_;

	$circle->move_to( $dx + $gx, $h + $dy + $gy );
}



sub resize_group {
	my( $parent ) =  @_;

	my @children =  $parent->{ children }->@*;
	$parent->organize_group( \@children );

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



## Возвращает размер объекта для resize
sub calc_size_values {
	my( $circle, $x, $y ) =  @_;

	my $ry = $y - $circle->{ y } - $circle->{ radius };
	my $rx = $x - $circle->{ x } - $circle->{ radius };

	my $r =  $ry > $rx ? $ry : $rx;

	return ( $r );
}



sub set_min_size {
	my( $circle, $h, $w ) =  @_;

	$circle->{ min_r } =  $h > $w ? $h / 2  : $w / 2;
}



## Возвращает размер объекта ( h, w )
sub get_size {
	my( $circle ) =  @_;

	my $diam =  $circle->{ radius } * 2;
	my $h =  $diam;
	my $w =  $diam;

	return ( $h, $w );
}



sub set_size {
	my( $circle, $h, $w ) =  @_;

	$circle->{ radius } =  $h > $w ? $h / 2 : $w / 2;
}



## Size_batton coords
sub get_sb_coords {
	my( $circle, $x, $y ) =  @_;

	return (
		$x + $circle->{ radius } * 2 - 15,
		$y + $circle->{ radius } - 5,
		15, 10,
	);
}




1;
