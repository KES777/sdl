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
	# $btn_del->set_start_color;
}



## Меняет цвет объекта-кнопки (если над ней курсор)
sub on_mouse_over {
	# my( $btn_del ) =  @_;

	# $btn_del->{ c }{ b } =  250;
}



## Возвращает объекту-кнопке её цвет (когда курсор с неё уходит)
sub on_mouse_out {
	# my( $btn_del ) =  @_;

	# $btn_del->{ c }{ b } =  0;
}



sub get_sb_coords { }
sub store {}



1;
