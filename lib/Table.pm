package Table;

use strict;
use warnings;

use SDLx::Text;

use HScrollBar;
use VScrollBar;
use AppRect;
use Color;
use base 'Rect';


## Размеры ячейки таблицы
my $w =  75;
my $h =  30;


sub new {
	my( $obj ) =  shift;

	$obj =  $obj->SUPER::new( @_ );

	##
	my $sw =  15;
	my $sh =  $obj->{ h } - $sw;
	my $sx =  $obj->{ w } - $sw;
	my $sy =  0;

	$obj->{ scroll_v } =  VScrollBar->new( 500, $sx, $sy, $sw, $sh );
	$obj->children( $obj->{ scroll_v } );

	##
	$sh =  15;
	$sw =  $obj->{ w } - $sh;
	$sx =  0;
	$sy =  $obj->{ h } - $sh;
	$obj->{ scroll_h } =  HScrollBar->new( 1500, $sx, $sy, $sw, $sh );##$dimension =  880;
	$obj->children( $obj->{ scroll_h } );

	return $obj;
}



sub _draw_row {
	my( $x, $y, $data ) =  @_;

	my $screen =  AppRect::SCREEN();
	my $dx =  0;
	for my $value ( @$data ) {
		$screen->draw_rect( [ $x +$dx, $y, $w, $h ], [ 0, 0, 255, 0 ] );
		$screen->draw_rect( [ $x +$dx + 2, $y + 2, $w - 4, $h - 4 ], [ 255, 255, 255, 255 ] );

		if( $value ) {
			my $length =  length $value;
			my $text =  SDLx::Text->new(
				color   => [0, 0, 0], # "white"
	            size    => 16,
	            x       => $x + $dx + ($w - $length * 7) / 2,
	            y       => $y + $h / 6,
	            h_align => 'left',
	            text    => $value,
	        );
	        $text->write_to( $screen );
    	}
			$dx += $w;
	}
}



sub draw {
	my( $rect ) = @_;

	$rect->SUPER::draw( );

	# Get table data
	my $dsRect  =  Util::db()->resultset( 'Rect' );
	my @columns =  $dsRect->result_source->columns;

	# Calc columns position
	my $hscroll_pos =  $rect->{ scroll_h }{ pos };
	my $size        =  $#columns + 1;
	my $col_from    =  $size * $hscroll_pos;

	##
	my $col_n         =  0;
	my $col_displayed =  1;
	my @_draw_col;

	for my $column ( @columns ) {
		$col_n++;

		$col_n >= $col_from   or next;## drow from
		$col_displayed <= 11  or last;## drow untill

		push @_draw_col, $column;

		$col_displayed++
	}


	# Draw headers
	_draw_row( $rect->{ x }, $rect->{ y }, \@_draw_col );

	# Calc row position
	my $vscroll_pos  =  $rect->{ scroll_v }{ pos };
	my $display_from =  $dsRect->count * $vscroll_pos;

	# Draw data
	my $dy            =  0;
	my $row_n         =  0;
	my $row_displayed =  1;
	while( my $row =  $dsRect->next ) {
		$row_n++;

		$row_n >= $display_from   or next;## drow from
		$row_displayed <= 10  or last;	  ## drow untill

		my $data;

		for my $col ( @_draw_col ) {
			push @$data, $row->$col();
		}

		_draw_row( 100, 130 + $dy, $data );
		$dy +=  30;

		$row_displayed++;
	}
}



## Size_batton coords
sub get_sb_coords { }
## Object moving
sub move_to { }
sub on_mouse_over { }

1;
