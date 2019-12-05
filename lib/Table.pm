package Table;

use strict;
use warnings;

use SDLx::Text;

use AppRect;
use Color;
use base 'Rect';


## Размеры ячейки таблицы
my $w =  75;
my $h =  30;


sub _draw_row {
	my( $x, $y, $data ) =  @_;

	my $screen =  AppRect::SCREEN();
	my $dx =  0;
	for my $value ( @$data ) {
		$screen->draw_rect( [ $x +$dx, $y, $w, $h ], [ 0, 0, 255, 0 ] );
		$screen->draw_rect( [ $x +$dx + 2, $y + 2, $w - 4, $h - 4 ], [ 255, 255, 255, 255 ] );

		my $length =  length $value;
		my $text =  SDLx::Text->new(
			color   => [0, 0, 0], # "white"
            size    => 16,
            x       => $x + $dx + ($w - $length * 7) / 2,
            y       => $y + $h / 6,
            h_align => 'left',
            text    => $value,
        );

		$dx += $w;
        $text->write_to( $screen );
	}
}



sub draw {
	my( $rect ) = @_;

	my $dsRect =  Util::db()->resultset( 'Rect' );

	my @columns =  $dsRect->result_source->columns;

	_draw_row( 100, 100, \@columns );
	my $dy =  0;
	my $row_n =  0;
	my $row_displayed =  1;
	while( my $row =  $dsRect->next ) {
		$row_n++;

		$row_n >= $rect->{ display_from }   or next;
		$row_displayed <= 10  or last;##$rect->{ display_count }

		my $data;

		for my $col ( @columns ) {
			push @$data, $row->$col();
		}

		_draw_row( 100, 130 + $dy, $data );
		$dy +=  30;

		$row_displayed++;
	}
}



1;
