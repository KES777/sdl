package Btn_Circle;

use strict;
use warnings;


use Scalar::Util qw(weaken);


use Color;
use Circle;
use base 'Circle';


## Start position  стартовые координаты объекта
my $START_X =  0;
my $START_Y =  85;

## Start color  стартовый цвет объекта
my $r       =  255;
my $g       =  255;
my $b       =    0;


sub new {
	my( $btn_c ) =  @_;

	$btn_c  =  $btn_c->SUPER::new;

	$btn_c->set_color;
	$btn_c->set_start_position;

	return $btn_c;
}



## Возвращает объекту стартовую позицию
sub set_start_position {
	my( $btn_c ) =  @_;

	$btn_c->{ x } =  $START_X;
	$btn_c->{ y } =  $START_Y;
}



sub set_color {
	my( $btn_c ) =  @_;

	$btn_c->{ c } =   Color->new( $r, $g, $b );
}



## Создаёт новую фигуру(при нажатии кнопки мыши)
sub on_press {
	my( $btn_c, $h, $e ) =  @_;

	my $circle =  Circle->new;

	## Set object handle
	$circle->object_handle;

	## Set  the color
	$circle->{ c } =  $btn_c->{ c };

	$circle->{ parent } =  $btn_c->{ parent };
	weaken $circle->{ parent };

	$circle->store;
	push $btn_c->{ parent }->{ children }->@*, $circle;
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



sub on_move { }
sub get_sb_coords { }



1;
