package Dumper;

use strict;
use warnings;

use Scalar::Util qw/ reftype /;

use SDLx::Text;



## Размеры ячейки таблицы
my $w =  100;
my $h =  30;



sub dump {
	my( $x, $y, $data ) =  @_;

	my $type =  reftype $data;
	##
	if( $type  eq  'HASH' ) {
		draw_hash( $x, $y, $data );
	}

	##
	elsif( $type  eq  'SCALAR' ) {
		draw_scalar( $x, $y, $data );
	}

	##
	elsif( ref $data  eq  'ARRAY' ) {
		draw_array( $x, $y, $data );
	}
}



sub draw_scalar {
	my( $x, $y, $data ) =  @_;

	_dump( $x, $y, [ $data->$* ] );
}



sub draw_array {
	my( $x, $y, $array ) =  @_;

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
				color   => [0, 0, 0], # "white"
				size    => 16,
				x       => $x + $dx + ($w + $dw - $length * 7) / 2,
				y       => $y + $h / 6,
				h_align => 'left',
				text    => $value ."",
			);
			$text->write_to( $screen );
		}

		$dx +=  $w;
		$dw +=  $dw + $w;
	}

	return $dw;
}



sub move_to { }

1;
