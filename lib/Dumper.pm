package Dumper;

use strict;
use warnings;

use SDLx::Text;

use Color;
use base 'Rect';


## Размеры ячейки таблицы
my $w =  75;
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
	my( $obj,  ) =  @_;

# DB::x;
	my $hash  =  $obj->{ data };
	my $n  =  0;
	my $dy =  0;
	for my $k ( sort keys $hash->%* ){
		$n < 5   or last;
		_draw( $obj->{ x }, $obj->{ y } + $dy, [ $k, $hash->{ $k } ] );
	$dy +=  $h;
	$n  +=   1;
	}

}



sub _draw {
	my( $x, $y, $data ) =  @_;

	my $screen =  AppRect::SCREEN();

	my $dx =  0;
	for my $value ( @$data ) {
		$screen->draw_rect( [ $x + $dx, $y, $w, $h ], [ 0, 0, 255, 0 ] );
		$screen->draw_rect( [ $x + 2 + $dx, $y + 2, $w - 4, $h - 4 ], [ 255, 255, 255, 255 ] );

		if( defined $value ) {
			my $length =  length $value;
			my $text =  SDLx::Text->new(
				color   => [0, 0, 0], # "white"
				size    => 16,
				x       => $x + ($w - $length * 7) / 2,
				y       => $y + $h / 6,
				h_align => 'left',
				text    => $value ."",
			);
			$text->write_to( $screen );
		}

		$dx += $w;
	}

}




1;
