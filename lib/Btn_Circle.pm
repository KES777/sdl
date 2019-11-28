package Btn_Circle;

use strict;
use warnings;


use Scalar::Util qw(weaken);


use Color;
use Circle;
use base 'Circle';


## Start position  стартовые координаты объекта
my $START_X =  25;
my $START_Y =  85;

## Start color  стартовый цвет объекта
my $r       =  255;
my $g       =  255;
my $b       =    0;


sub new {
	my( $btn_c ) =  @_;

	$btn_c  =  $btn_c->SUPER::new;

	$btn_c->{ h } =  50;
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

	my $rect =  Circle->new;
	$rect->{ c } =  $btn_c->{ c };
	$rect->{ h } =  50;
	$rect->{ parent } =  $btn_c->{ parent };
	weaken $rect->{ parent };

	$rect->store;
	push $btn_c->{ parent }->{ children }->@*, $rect;
}




sub draw {
	my( $btn_c, $screen, $x, $y ) =  @_;

	$screen //=  AppRect::SCREEN();
	$x //=  0;
	$y //=  0;

	$x += $btn_c->{ x };
	$y += $btn_c->{ y };

	my $r    =  $btn_c->{ radius };
	my $diam =  $r * 2;
	$screen->draw_rect([
		$x - $r,
		$y - $r,
		$diam,
		$diam,
	],[
		255,255,255,255
	]);
	#circuit
	$screen->draw_rect([
		$x - $r +2,
		$y - $r +2,
		$diam-4,
		$diam-4,
	],[
		$btn_c->{ c }->get()
	]);
}



sub on_over {

}



sub is_moveable {

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


1;
