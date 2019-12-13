package Btn_del;

use strict;
use warnings;

use Rect;
use base 'Rect';

my $START_X =  250;
my $START_Y =    0;

my $r       =  255;
my $g       =    0;
my $b       =    0;


sub new {
	my( $btn_del ) =  @_;

	$btn_del  =  $btn_del->SUPER::new;

	$btn_del->set_start_color;
	$btn_del->set_start_position;

	return $btn_del;
}



sub set_start_color {
	my( $btn_del ) =  @_;

	$btn_del->{ c } =   Color->new( $r, $g, $b );
}


sub set_start_position {
	my( $btn_del ) =  @_;

	$btn_del->{ x } =  $START_X;
	$btn_del->{ y } =  $START_Y;
}


sub on_click { }
sub on_dbl_click { }


sub draw {
	my( $btn_del, $x, $y ) =  @_;

	# $btn_del->draw_black;
	# $btn_del->save_draw_coord;

	my $screen =  AppRect::SCREEN();
	$x //=  0;
	$y //=  0;

	$x += $btn_del->{ x };
	$y += $btn_del->{ y };

	$screen->draw_rect([
		$x,
		$y,
		$btn_del->{ w },
		$btn_del->{ h },
	],[
		255,255,255,255
	]);
	#circuit
	$screen->draw_rect([
		$x +1,
		$y +1,
		$btn_del->{ w }-2,
		$btn_del->{ h }-2,
	],[
		$btn_del->{ c }->get()
	]);
}



## delete all shapes or any one
sub moving_disable {
	my( $btn_del, $e, $h ) =  @_;

		my $app_rect =  $h->{ app };
		$btn_del->start_position;

	## Удаление всех объектов
	if( $app_rect->{ btn }->is_over( $e->motion_x, $e->motion_y ) ) {
		$app_rect->propagate( 'draw_black' );
		$app_rect->{ children } =  ();
		Util::db()->resultset( 'Rect' )->delete;
		# $app_rect->draw_black;## Затираем перед удалением
		return;
	}


	## Удаление одного объекта (группы)
	for my $shape( $app_rect->{ children }->@* ) {
		my $x;
		if( $shape->is_over( $e->motion_x, $e->motion_y ) ) {
			$x =  $shape;
			# $app_rect->draw_black;## Затираем перед удалением
			$app_rect->propagate( 'draw_black' );
			$x->child_destroy;#удаление из базы по id
		}

		$app_rect->{ children }->@* =  grep{ $_ != $x } $app_rect->{ children }->@*;
	}
}



## Возвращает кнопку на стартовую позицию
sub start_position {
	my( $btn_del ) =  @_;

	# $btn_del->restore_state;
	$btn_del->set_start_position;
	$btn_del->set_start_color;
}





## Меняет цвет объекта-кнопки (если над ней курсор)
sub on_mouse_over {
	my( $btn_del ) =  @_;

	$btn_del->{ c }{ b } =  250;
}



## Возвращает объекту-кнопке её цвет (когда курсор с неё уходит)
sub on_mouse_out {
	my( $btn_del ) =  @_;

	$btn_del->{ c }{ b } =  0;
}



1;
