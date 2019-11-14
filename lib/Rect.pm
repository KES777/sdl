package Rect;

use Color;

my $y_offset_n =  0;
my $x_offset   =  30;
my $y_offset   =  30;
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

	$x //=  ($x_offset += 30);
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
	);

	return bless \%rect, $rect;
}



sub draw_black {
	my( $rect, $screen, $x, $y ) = @_;

	$x //=  0;
	$y //=  0;

	$x += $rect->{ x };
	$y += $rect->{ y };


	$screen->draw_rect([
		$x,
		$y,
		$rect->{ w },
		$rect->{ h },
	],[ 0, 0, 0, 0 ]);
}



sub draw {
	my( $rect, $screen, $x, $y ) = @_;
	$x //=  0;
	$y //=  0;

	$x += $rect->{ x };
	$y += $rect->{ y };

	$screen->draw_rect([
		$x,
		$y,
		$rect->{ w },
		$rect->{ h },
	],[ 
		255,255,255,255
	]);
	#circuit
	$screen->draw_rect([
		$x +1,
		$y +1,
		$rect->{ w }-2,
		$rect->{ h }-2,
	],[ 
		$rect->{ c }->get()
	]);

	#size_button
	if( !$rect->{ selection } ) {

		$screen->draw_rect([
			$x + $rect->{ w } -15,
			$y + $rect->{ h } -10,
			15,
			10,
		],[ 
			33, 200, 150, 255
		]);
	}


	if( $rect->{ children } ) {
		# my $h =  10;
		for my $s ( $rect->{ children }->@* ) {
		# 	$s->{ x }      =  $rect->{ x } + 10;
		# 	$s->{ y }      =  $rect->{ y } + $h;
		# 	$s->{ c }{ r } =  $rect->{ c }{ r } + 80;

		# 	$h +=  $s->{ h } +10;

			$s->draw( $screen, $x, $y );
		}
	}
}



sub is_over {
	my( $rect, $x, $y ) =  @_;

	my $bool =  Util::mouse_target_square( $rect, $x, $y );
	if( $bool ) {
		# print "Over ", $rect->{ id }, "\n";
		for my $r ( $rect->{ children }->@* ) {
			if( my $over =  $r->is_over( $x, $y ) ) {
				return $over;
			}
		}

		return $rect;
	}

	return;
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

	for my $r ( $rect->{ children }->@* ) {
		$r->store;
	}

	return $rect;
}



sub parent {
	my( $rect, $id ) =  @_;

	Util::db()->resultset( 'Rect' )->search({
		id => $rect->{ id },
	})->first->update({ parent_id => $id });

	$rect->{ parent_id } =  $id;
}



sub moving_on {
	my( $rect, $tp_x, $tp_y ) =  @_;

	$rect->{ moving  } =  1;

	$rect->{ start_x } =  $rect->{ x };
	$rect->{ start_y } =  $rect->{ y };

	$rect->{ start_c } =  $rect->{ c };
	$rect->{ c       } =  Color->new( 0, 0, 200 );

	$rect->{ dx } =  $tp_x - $rect->{ x };
	$rect->{ dy } =  $tp_y - $rect->{ y };

}



sub moving_off {
	my( $rect ) =  @_;

	$rect->{ c } =  delete $rect->{ start_c };
	delete $rect->@{qw/ moving dx dy start_x start_y /};

	#for $btn_del
	if( $rect->{ c }->{ r } == 255 ) {
		return;
	}
	
	$rect->store;
}



sub can_drop {
	my( $rect, $squares, $drop_x, $drop_y ) =  @_;

	my( $group, $child );
	for my $s ( @$squares ) {
		$s != $rect   or next;
		my $curr =  $s->is_over( $drop_x, $drop_y )   or next;

		$group =  $s;
		$child =  $curr;
		# last;
	}

	$group   or return;

	return $group, $child;
}



sub can_group {
	my( $group, $square ) = @_;

	if( $group->{ x } < $square->{ x }
		&&  $group->{ y } < $square->{ y }
		&&  $group->{ x } + $group->{ w } > $square->{ x } + $square->{ w }
		&&  $group->{ y } + $group->{ h } > $square->{ y } + $square->{ h } ) {

		return $group;
	}
	
	# if( $group->{ w } < $square->{ w }
	# 	|| $group->{ h } < $square->{ h } ) {
	# 	return;
	# }
	# return $group;
}



sub drop {
	my( $rect, $group, $child, $squares, $drop_x, $drop_y ) =  @_;

	$rect->parent( $group->{ id } );
	# $rect->{ x } =  $drop_x - $group->{ x } - $rect->{ dx };
	# $rect->{ y } =  $drop_y - $group->{ y } - $rect->{ dy }; 
	$rect->moving_off;
	# $rect->store;	

	push $group->{ children }->@*, $rect;
	@$squares =  grep{ $_ != $rect } @$squares;

	my @children =   $group->{ children }->@*;

	to_group( $group, @children );

	return 1;
}



sub to_group {
	my( $group, @children ) =  @_;

	my $w =   0;	
	my $h =  10;
	for my $s ( @children ) {
		$s->move_to( 10, $h );
		$s->{ c }{ r } =  $group->{ c }{ r } + 80;
		$s->store;

		$h +=  $s->{ h } +10;
		$w  =  $s->{ w } > $w ? $s->{ w } : $w;
	}

	$group->{ w } =  $w + 20;
	$group->{ h } =  $h;	
	$group->store;
}



sub moving_cancel {
	my( $rect, $app ) =  @_;

	$rect->draw_black( $app );

	$rect->{ x } =  $rect->{ start_x };
	$rect->{ y } =  $rect->{ start_y };

	$rect->moving_off;
}



sub move_to {
	my( $rect, $x, $y, $app_w, $app_h ) =  @_;

	$rect->{ x } =  $x - $rect->{ dx } //0;
	$rect->{ y } =  $y - $rect->{ dy } //0;

	if( $rect->{ x } < 0 ) {
		$rect->{ x } = 0;
	}
	if( $rect->{ y } < 0 ) {
		$rect->{ y } = 0;
	}
	if( $app_w  &&  $rect->{ x } > $app_w - $rect->{ w } ) {
		$rect->{ x } = $app_w - $rect->{ w };
	}
	if( $app_h  &&  $rect->{ y } > $app_h - $rect->{ h } ) {
		$rect->{ y } = $app_h - $rect->{ h };
	}

}



sub load_children {
	my( $rect ) = @_;

	my $child =  Util::db()->resultset( 'Rect' )->search({
		parent_id => $rect->{ id }
	});

	$rect->{ children } =  [ map{ Rect->new( $_ ) } $child->all ];

	# my @arr =  map sub{ Rect->new( $_ ) }, $child->all;
	# $rect->{ children } =  \@arr;

	# my $xxx =  [ 1, 2, 3 ]; # my @xxx =  ( 1, 2, 3 ); my $xxx =  \@xxx;


	for my $x ( $rect->{ children }->@* ) {
		$x->load_children;
	}
}



# sub map {
# 	my( $sub, @array ) =  @_;

# 	my @res;
# 	for my $item ( @array ) {
# 		push @res, $sub->( $item );
# 	}

# 	return @res;
# }

# sub{
# 	my( $_ ) =  @_;

# 	return Rect->new( $_ );
# }	


sub resize_on {
	my( $rect ) =  @_;

	$rect->{ resize } =  1;
	$rect->{ old_c  } =  $rect->{ c };
	$rect->{ c      } =  Color->new( 0, 200, 0 );
}



sub resize_to {
	my( $rect, $x, $y ) =  @_;

	$rect->{ w } = $x - $rect->{ x };
	if( $x - $rect->{ x } < 50 ) {
		$rect->{ w } = 50;
	}
	$rect->{ h } = $y - $rect->{ y };
	if( $y - $rect->{ y } < 30 ) {
		$rect->{ h } = 30;
	}

	$rect->{ children } or return;

	my $h = 10;
	for $square( $rect->{ children }->@* ) {
		$h += $square->{ h } + 10;

		if ( $rect->{ w } < $square->{ w } + 20 ) {
			$rect->{ w } = $square->{ w } + 20;
		}
	}

	$rect->{ h } < $h ?
		$rect->{ h } = $h:
			return;
		
}



sub resize_off {
	my( $rect ) = @_;

	$rect->{ c } =  delete $rect->{ old_c };
	delete $rect->@{qw/ resize /};
}



sub btn_d_come_back {
	my( $rect, $app ) = @_;

	$rect->draw_black( $app );
	$rect->moving_off;
	$rect->{ x } = 250;
	$rect->{ y } = 0;
}



sub child_delete {
	my( $square ) = @_;

	Util::db()->resultset( 'Rect' )->search({
		id => $square->{ id } 
	})->delete;

	if( $square->{ children }->@* ) {

		for my $child ( $square->{ children }->@* ) {
			$child->child_delete;
		}
	}
}




1;
