package Dumper;

use strict;
use warnings;

use Scalar::Util qw/ reftype /;

use SDLx::Text;

use base 'Rect';
use Input;


## Размеры ячейки таблицы
my $w =  120;
my $h =  30;


sub new {
	my( $dumper, $shape ) =  @_;

	my $x   =  $shape->{x} + $w;
	my $y   =  $shape->{y} + $shape->{h} + $h;
	my $obj =  $dumper->SUPER::new( $x, $y );

	$obj->{data} =  $shape;
	return $obj;
}



sub draw {
	my( $obj ) =  @_;

	my $x    =  $obj->{x};
	my $y    =  $obj->{y};
	my $data =  $obj->{data};
	my $type =  reftype $data;
	##
	if( $type  eq  'HASH' ) {
		( $obj->{ w }, $obj->{ h } ) =  draw_hash( $data, $x, $y );
	}
	##
	elsif( ref $data  eq  'ARRAY' ) {
		draw_array( $data, $x, $y );
	}
	##
	elsif( $type  eq  'SCALAR' ) {
		draw_scalar( $data, $x, $y );
	}
}



sub draw_scalar {
	my( $data, $x, $y ) =  @_;

	_dump( $x, $y, [ $data->$* ] );
}



sub draw_array {
	my( $array, $x, $y ) =  @_;

	my $cw;
	my $cy =  0;
	my $n =  0;
	for my $k ( $array->@* ){
		$n < 10   or last;
		$cw =  _dump( $x, $y + $cy, [ $n, $k ] );

		$n  +=   1;
		$cy +=  $h;
	}
}



sub draw_hash {
	my( $x, $y, $hash ) =  @_;

	my $cw;
	my $cy =  0;
	my $n  =  0;
	for my $k ( sort keys $hash->%* ){
		$n < 10   or last;
		_dump( $x, $y + $cy, [ $k, $hash->{ $k } ] );

		$n  +=   1;
		$cy +=  $h;
	}
}



sub _draw_input {
	my( $obj ) =  @_;

	my( $s, $si ) =  ( '', '' );

	$obj->{ w } =  $obj->dump( $obj->{ x }, $obj->{ y } + $obj->{ h }, [ $s, $si ] );
	$obj->{ h } +=  $h;
}



sub _dump {
	my( $x, $y, $data ) =  @_;

	my $screen =  AppRect::SCREEN();

	my $dx =  0;
	my $dw =  0;
	for my $value ( @$data ) {
		$screen->draw_rect( [ $x + $dx, $y, $w + $dw, $h ], [ 0, 0, 255, 0 ] );
		$screen->draw_rect( [ $x + 2 + $dx, $y + 2, $w - 4 + $dw, $h - 4 ], [ 255, 255, 255, 255 ] );

		if( defined $value  &&  (my $length =  length $value) ) {
			my $text =  SDLx::Text->new(
				color   =>  [0, 0, 0], # "white"
				size    =>  16,
				# x       => $x + $dx + ($w + $dw - $length * 7) / 2,
				# y       => $y + $h / 6,
				h_align =>  'left',
				text    =>  $value ."",
			);
			my $x =  $x + $dx +($w + $dw - $text->w)/2;
			my $y =  $y + ($h - $text->h)/2;
			$text->write_xy( $screen, $x, $y );

		}
		$dx +=  $w;
		$dw  =  $w;
	}

	return $dx;
}



sub move_to { }

1;
