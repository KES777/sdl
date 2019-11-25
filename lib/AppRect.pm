package AppRect;

use strict;
use warnings;


use SDLx::App;
use SDL::Event;
use Scalar::Util qw/ weaken blessed /;


use Rect;
use Btn_del;
use Btn;


use base 'Rect';



my $APP;
sub SCREEN { return $APP }



sub new {
	my( $rect, $app_w, $app_h ) =  @_;

	my $app_rect =  $rect->SUPER::new( 0, 0, $app_w, $app_h );

	$APP =  $app_rect->{ app } =  SDLx::App->new(
		width      =>  $app_w,
		height     =>  $app_h,
		resizeable =>  1,
	);

	$app_rect->{ btn } =  Btn->new( 0, 0, 50, 30 );
	$app_rect->{ btn }{ parent } =  $app_rect;
	weaken $app_rect->{ btn }{ parent };

	$app_rect->{ btn_del } =  Btn_del->new;
	$app_rect->{ btn_del }{ parent } =  $app_rect;
	weaken $app_rect->{ btn_del }{ parent };

	$app_rect->{ children } =  [];
	$app_rect->load_children;

	# $APP->add_event_handler( sub{ _on_down( @_, $app_rect ) } );
	# $APP->add_event_handler( sub{ _on_move( @_, $app_rect ) } );

	$APP->add_show_handler ( sub{ $app_rect->draw } );



	$APP->add_event_handler( sub{ _on_mouse_move( @_, $app_rect ) } );
	$APP->add_event_handler( sub{ _is_mousedown ( @_, $app_rect ) } );
	$APP->add_event_handler( sub{ _is_mouseup   ( @_, $app_rect ) } );

	$APP->add_event_handler( sub{ _observer( @_, $app_rect ) } );

	return $app_rect;
}



sub _on_move {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEMOTION   or return;

	print "MOVE  ", $e->motion_x, "  ", $e->motion_y, "\n";
}



sub _on_down {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONDOWN   or return;
	print "DOWN  ", $e->button_x, "  ", $e->button_y, "\n";
}



my $event_types =  {
	SDL_MOUSEBUTTONDOWN() => sub {
	},
	SDL_MOUSEMOTION()     => sub {
		my( $app_rect ) =  @_;

		$app_rect->{ event_state }
	},
};
my $mouse_btn =  {
	SDL_BUTTON_LEFT()   =>  'mbl',
	SDL_BUTTON_MIDDLE() =>  'mbm',
	SDL_BUTTON_RIGHT()  =>  'mbr',
};
sub _observer {
	my( $e, $app, $app_rect ) =  @_;

	# $event_types->{ $e->type }->( $app_rect );


	if( $e->type == SDL_MOUSEMOTION ) {
		$app_rect->{ event_state }{ x } =  $e->motion_x;
		$app_rect->{ event_state }{ y } =  $e->motion_y;
	}

	if( $e->type == SDL_MOUSEBUTTONDOWN ) {
		$app_rect->{ event_state }{ $mouse_btn->{ $e->button_button } } =  1;
	}

	if( $e->type == SDL_MOUSEBUTTONUP ) {
		$app_rect->{ event_state }{ $mouse_btn->{ $e->button_button } } =  0;
	}

	if( $e->type == SDL_KEYDOWN ) {
		$app_rect->{ event_state }{ $e->key_sym } =  1;
	}

	if( $e->type == SDL_KEYUP ) {
		$app_rect->{ event_state }{ $e->key_sym } =  0;
	}
}






sub _is_group {
	my( $app_rect, $h, $e ) =  @_;

	my @alone;
	my @grouped;
	for my $shape ( $app_rect->{ children }->@* ) {
		$shape->is_inside( $h->@{qw/ x y w h /} )?
			push @grouped, $shape :
			push @alone, $shape;
	}

	@grouped   or return;

	return {
		target  =>  $app_rect,
		grouped =>  \@grouped,
		alone   =>  \@alone,
	};
}



sub _is_mousedown {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONDOWN
		or return;


	##
	if( my $h =  $app_rect->{ is_over_rf } ) {
		$app_rect->{ on_resize } =  $app_rect->{ is_over_rf };
			return;
	}


	##
	if( my $h =  $app_rect->{ is_over } ) {
		$h->{ target }->on_press( $h, $e );

		if( my $move =  $h->{ target }->is_moveable( $h, $e ) ) {
			$app_rect->{ is_moveable } =  $move;
		}
	}

	##
	if( !$app_rect->{ is_over }  &&  !$app_rect->{ is_selection } ) {
		$app_rect->{ is_selection } =  Selection->new(
			$e->motion_x, $e->motion_y, 0, 0,
			Color->new( 0, 0, 0 )
		);
	}
}



sub _is_mouseup {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONUP
		or return;

	##
	delete $app_rect->{ first };

	##
	if( my $h =  $app_rect->{ on_resize } ) {
		$h->off_resize_shape( $app_rect );
	}

	##
	if( my $h =  $app_rect->{ is_moveable } ) {
		if( my $drop =  $h->{ target }->is_drop_shape( $h, $e ) ) {
			$app_rect->{ is_dropable } =  $drop;
		}

		$h->{ target }->on_release( $h, $e, $app_rect );
		delete $app_rect->{ is_moveable };
	}

	##
	if( my $h =  $app_rect->{ is_selection } ) {
		if( my $group =  $app_rect->_is_group( $h, $e ) ) {
			$group->{ target }->on_group( $h, $e, $group );
		}

		$h->draw_black;
		delete $app_rect->{ is_selection };
	}
# DB::x;
	##
	if( my $h =  $app_rect->{ is_over } ) {
		if( $h->{ target } == $app_rect->{ btn_del } ) {
			$h->{ target }->on_btn_del( $app_rect, $e );
		}
	}
}



sub _on_mouse_move {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEMOTION
		or return;


	if( $app_rect->{ is_over_rf } =
		_is_over_rf( $app_rect, $e->motion_x, $e->motion_y ) ) {
			return;
	}

	if( my $h =  $app_rect->{ on_resize } ){
		$h->resize_shape( $e->motion_x, $e->motion_y, $app_rect );
	}


	## Actualize data
	$app_rect->{ is_over } =  _is_over( $app_rect, $e->motion_x, $e->motion_y );

	##
	if( my $h =  $app_rect->{ is_over } ) {
		$h->{ target }->on_over_shape( $h, $app_rect, $e );
	}

	if( !$app_rect->{ is_over } ) {
		delete $app_rect->{ first };
	}

	##
	if( my $h =  $app_rect->{ is_moveable } ) {
		$h->{ target }->on_move( $h, $e, $app_rect );
	}

	##
	if( my $h =  $app_rect->{ is_selection } ) {
		$h->on_resize( $h, $e );
	}
}



sub _is_over {
	my( $app_rect, $x, $y ) =  @_;

	my $over;
	my @interface =  ( $app_rect->{ btn }, $app_rect->{ btn_del } );
	for my $shape ( $app_rect->{ children }->@*, @interface ) {
		$over =  $shape->is_over_shape( $x, $y )
			or next;

		$over->{ owner } =  $shape;############?!
		last;
	}

	return $over;
}



sub _is_over_rf {
	my( $app_rect, $x, $y ) =  @_;
# DB::x;
	my $object;
	for my $shape ( $app_rect->{ children }->@* ) {
		$shape->is_over_rf( $x, $y )
			or next;
		$object =  $shape;
	}

	return $object;

}




sub can_select {
	my( $app_rect, $x, $y ) =  @_;

	for my $child ( @$app_rect ){
		$child->is_over( $x, $y )   or next;

			return;
	}

	if( $app_rect->{ btn }->is_over( $x, $y ) ) {
		return;
	}

	if( $app_rect->{ btn_del }->is_over( $x, $y ) ) {
		return;
	}

	return 1;
}



sub new_selecting_field {
	my( $rect, $x, $y ) =  @_;

	# xxxxx    or return;

	$rect->{ sel } =  Selection->new( $x, $y, 0, 0, Color->new( 0, 0, 0 ) );
}



sub draw {
	my( $app_rect ) =  @_;

	if( $app_rect->{ children } ) {
		for my $s ( $app_rect->{ children }->@* ) {
			$s   or next;
			$s->draw( $app_rect->{ app } );
		}
	}

	$app_rect->{ btn     }->draw( $app_rect->{ app } );
	$app_rect->{ btn_del }->draw( $app_rect->{ app } );
	if( $app_rect->{ first } ) {
		$app_rect->{ first }->draw( $app_rect->{ app } );
	}

	$app_rect->{ app }->update;
}

1;
