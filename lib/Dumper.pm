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
	my( $dumper, $data ) =  (shift, shift);

	my $obj =  $dumper->SUPER::new(@_);
	$obj->{data} =  $data;
	# $obj->{dx}   =  $dx;
	# $obj->{dy}   =  $dy;

	return $obj;
}



sub draw {
	my( $obj, $x, $y ) =  @_;

	my $x    =  $obj->{x} + $x;
	my $y    =  $obj->{y} + $y;
	my $data =  $obj->{data};
	my $type =  reftype $data;
	##
	if( $type  eq  'HASH' ) {
		( $obj->{ w }, $obj->{ h } ) =  draw_hash( $data, $x, $y );
		# print "'HASH' \n";
	}
	##
	elsif( ref $data  eq  'ARRAY' ) {
		( $obj->{ w }, $obj->{ h } ) =  draw_array( $data, $x, $y );
	}
	##
	elsif( $type  eq  'SCALAR' ) {
		( $obj->{ w }, $obj->{ h } ) =  draw_scalar( $data, $x, $y );
		# print "'SCALAR' \n";
	}
	return undef;
}



sub draw_scalar {
	my( $data, $x, $y ) =  @_;

	my $cw =  _dump( $x, $y, [ $data->$* ] );

	return $cw, $h;
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

	return $cw, $cy;
}



sub draw_hash {
	my( $hash, $x, $y ) =  @_;

	my $cw;
	my $cy =  0;
	my $n  =  0;
	for my $k ( sort keys $hash->%* ){
		$n < 10   or last;

		$cw =  _dump( $x, $y + $cy, [ $k, $hash->{ $k } ] );
		$n  +=   1;
		$cy +=  $h;
	}

	return $cw, $cy;
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
				h_align =>  'left',
				text    =>  $value ."",
			);
			my $x =  $x + $dx +($w + $dw - $text->w)/2;
			my $y =  $y + ($h - $text->h)/2;
			$text->write_xy( $screen, $x, $y );

		}
		$dx +=  $dx + $w;
		$dw  =  $w;
	}
	# print $x;
	return $dx;
}

sub store { }
# sub on_mouse_over { }
# sub on_mouse_out { }
# sub move_to { }
sub on_hint { }

1;
