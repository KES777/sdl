package Dumper;

use strict;
use warnings;

use Scalar::Util qw(blessed dualvar isdual readonly refaddr reftype
                    tainted weaken isweak isvstring looks_like_number
                    set_prototype);

use SDLx::Text;

use Color;
use base 'Rect';


## Размеры ячейки таблицы
my $w =  100;
my $h =  30;


sub new {
	my( $table, $data ) =  ( shift, shift );

	$table =  $table->SUPER::new( @_ );

	$table->{ data } =  $data;

	return $table;
}



# sub dump {
# 	my( $obj, $data ) =  @_;

# 	$obj->{ data } =  $data;
# }



sub draw {
	my( $obj ) =  @_;

	my $data  =  $obj->{ data };

	my $type =  reftype $data;
	##
	if( $type  eq  'HASH' ) {
		draw_hash( $obj, $data );
	}

	##
	elsif( $type  eq  'SCALAR' ) {
		draw_scalar( $obj, $data );
	}

	##
	elsif( ref $data  eq  'ARRAY' ) {
		draw_array( $obj, $data );
	}
}



sub draw_scalar {
	my( $obj ) =  shift;

	$obj->_draw( $obj->{ x }, $obj->{ y }, [ shift->$* ] );

	$obj->{ h } = $h;
}



sub draw_array {
	my( $obj, $array ) =  @_;

	my $n =  0;
	my $dy;
	for my $k ( $array->@* ){
		$n < 10   or last;
		$obj->_draw( $obj->{ x }, $obj->{ y } + $dy, [ $n, $k ] );

		$n  +=   1;
		$dy +=  $h;
		$obj->{ h } =  $dy;
	}
}



sub draw_hash {
	my( $obj, $hash ) =  @_;

	my $n  =  0;
	my $dy =  0;
	for my $k ( sort keys $hash->%* ){
		$n < 10   or last;
		$obj->_draw( $obj->{ x }, $obj->{ y } + $dy, [ $k, $hash->{ $k } ] );

		$n  +=   1;
		$dy +=  $h;
		$obj->{ h } =  $dy;
	}
}



sub _draw {
	my( $obj, $x, $y, $data ) =  @_;

	my $screen =  AppRect::SCREEN();

	my $dw =  0;
	my $dx =  0;
	for my $value ( @$data ) {
		$screen->draw_rect( [ $x + $dx, $y, $w + $dw, $h ], [ 0, 0, 255, 0 ] );
		$screen->draw_rect( [ $x + 2 + $dx, $y + 2, $w - 4 + $dw, $h - 4 ], [ 255, 255, 255, 255 ] );

		if( defined $value ) {
			my $length =  length $value;
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
		$obj->{ w } =  $dw;
	}
}



sub move_to { }

1;
