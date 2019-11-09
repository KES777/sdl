package Rect;

use Color;

my $y_offset_n =  0;
my $x_offset =  30;
my $y_offset =  30;
sub new {
	if( ref $_[1] eq 'Schema::Result::Rect' ) {
		my( $rect, $db_rect ) =  @_;

		$rect =  $rect->new( 
			$db_rect->x, $db_rect->y, $db_rect->w, $db_rect->h,
			Color->new( $db_rect->r, $db_rect->g, $db_rect->b, $db_rect->a ),
		);
		$rect->{ id } =  $db_rect->id;
		return $rect;
	}


	my( $rect, $x, $y, $w, $h, $c ) =  @_;

	$x //=  ($x_offset += 10);
	$y //=  $y_offset_n * 5  + ($y_offset +=  5);

	if( $x_offset > 600 ) {
		$x_offset =  30;
		$y_offset =  30;
		$y_offset_n++;  
	}

	# if( !defined $x ) {
	# 	$x_offset =  $x_offset + 10;
	# 	$x =  $x_offset;
	# }


	my %rect = (
		x      => $x,
		y      => $y,
		w      => $w // 50,
		h      => $h // 30,
		c      => $c // Color->new,
		parent_id => 0,
	);

	return bless \%rect, $rect;
}



sub draw_black {
	my( $rect, $screen ) = @_;

	$screen->draw_rect([
		$rect->{ x },
		$rect->{ y },
		$rect->{ w },
		$rect->{ h },
	],[ 0, 0, 0, 0 ]);
}



sub draw {
	my( $rect, $screen ) = @_;

	$screen->draw_rect([
		$rect->{ x },
		$rect->{ y },
		$rect->{ w },
		$rect->{ h },
	],[ 
		255,255,255,255
	]);

	$screen->draw_rect([
		$rect->{ x }+1,
		$rect->{ y }+1,
		$rect->{ w }-2,
		$rect->{ h }-2,
	],[ 
		$rect->{ c }->get()
	]);


	if( $rect->{ children } ) {
		my $h =  10;
		for my $c ( $rect->{ children }->@* ) {
			$c->{ x }      =  $rect->{ x } + 10;
			$c->{ y }      =  $rect->{ y } + $h;
			$c->{ c }{ r } =  $rect->{ c }{ r } + 80;

			$h +=  $c->{ h } +10;

			$c->draw( $screen );
		}
	}
}



sub is_over {
	my( $rect, $e ) =  @_;

	return Util::mouse_target_square( $e, $rect );
}



sub is_inside {
	my( $rect, $x, $y, $w, $h ) =  @_;

	return $rect->{ x } > $x  &&  $rect->{ x } < $x + $w
		&& $rect->{ y } > $y  &&  $rect->{ y } < $y + $h;
}



sub store {
	my( $rect ) =  @_;

	if( $rect->{ id } ) {
		my $row =  Util::db()->resultset( 'Rect' )->search({
			id => $rect->{ id },
		})->first;
		$row->update({
			$rect->%{qw/ x y w h /},
			$rect->{ c }->geth,
		});
	}
	else {
		my $row =  Util::db()->resultset( 'Rect' )->create({
			$rect->%{qw/ x y w h /},
			$rect->{ c }->geth,
		});

		$rect->{ id } =  $row->id;
	}

	return $rect;
}



sub parent {
	my( $rect, $id ) =  @_;

	my $row =  Util::db()->resultset( 'Rect' )->search({
		id => $rect->{ id },
	})->first;

	$row->update({ parent_id => $id });
}



sub moving_on {
	my( $rect, $x, $y ) =  @_;

	$rect->{ moving } =  1;
	$rect->{ old_c  } =  $rect->{ c };
	$rect->{ c      } =  Color->new( 0, 0, 200 );
	$rect->{ dx } =  $x - $rect->{ x };
	$rect->{ dy } =  $y - $rect->{ y };
}



sub moving_off {
	my( $rect ) =  @_;

	$rect->{ c } =  delete $rect->{ old_c };
	delete $rect->@{qw/ moving dx dy /};
}



sub move_to {
	my( $rect, $x, $y ) =  @_;

	$rect->{ x } =  $x - $rect->{ dx } //0;
	$rect->{ y } =  $y - $rect->{ dy } //0;
}

1;
