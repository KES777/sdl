package Btn;

use strict;
use warnings;


use Scalar::Util qw(weaken);

use Table;
use Rect;
use base 'Rect';


my $START_X =  0;
my $START_Y =  0;


sub new {
	my( $btn ) =  @_;

	$btn  =  $btn->SUPER::new;
	$btn->{ status } =  'service';
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
	my %x =  ( h => $rect->{h} );

	$rect->{data}   =  \%x;
	# $rect->{status} =  'Rect';

	$rect->store;
	push $btn->{ parent }->{ children }->@*, $rect;
}



sub on_hint{
	my( $btn, $h, $x, $y ) =  @_;

	push $h->{ app }->{ children }->@*, Table->new( 100, 100, 850, 355 );

	$h->{ app }->refresh_over( $x, $y );
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



sub on_over { }
sub on_move { }
sub get_sb_coords { }




1;
