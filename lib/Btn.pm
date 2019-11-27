package Btn;

use strict;
use warnings;


use Scalar::Util qw(weaken);


use Rect;
use base 'Rect';


my $START_X =  0;
my $START_Y =  0;


sub new {
	my( $btn ) =  @_;

	$btn  =  $btn->SUPER::new;

	$btn->set_start_position;

	return $btn;
}


## Возвращает объекту стартовую позицию
sub set_start_position {
	my( $btn_del ) =  @_;

	$btn_del->{ x } =  $START_X;
	$btn_del->{ y } =  $START_Y;
}


## Создаёт новую фигуру(при нажатии кнопки мыши)
sub on_press {
	my( $btn, $h, $e ) =  @_;

	my $rect =  Rect->new;
	$rect->{ parent } =  $btn->{ parent };
	weaken $rect->{ parent };

	$rect->store;
	push $btn->{ parent }->{ children }->@*, $rect;
}



sub draw {
	my( $app_rect, $app, $x, $y ) =  @_;

	$x //=  0;
	$y //=  0;

	$x += $app_rect->{ x };
	$y += $app_rect->{ y };

	$app->draw_rect([
		$x,
		$y,
		$app_rect->{ w },
		$app_rect->{ h },
	],[
		255,255,255,255
	]);
	#circuit
	$app->draw_rect([
		$x +1,
		$y +1,
		$app_rect->{ w }-2,
		$app_rect->{ h }-2,
	],[
		$app_rect->{ c }->get()
	]);
}



sub on_over {

}



sub is_moveable {

}



## Меняет цвет объекта-кнопки (если над ней курсор)
sub on_mouse_over {
	my( $btn ) =  @_;


	$btn->{ c }{ b } =  250;
}



## Возвращает объекту-кнопке её цвет (когда курсор с него уходит)
sub on_mouse_out {
	my( $btn ) =  @_;

	$btn->{ c }{ b } =  190;
}


1;
