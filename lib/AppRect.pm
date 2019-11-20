package AppRect;

use strict;
use warnings;


use SDLx::App;
use SDL::Event;


use Rect;
use Btn_del;
use Btn;


use base 'Rect';



sub new {
	my( $rect, $app_w, $app_h ) =  @_;

	my $app_rect =  $rect->SUPER::new( 0, 0, $app_w, $app_h );

	my $app =  $app_rect->{ app } =  SDLx::App->new(
		width      =>  $app_w,
		height     =>  $app_h,
		resizeable =>  1,
	);

	$app_rect->{ btn     } =  Btn->new( 0, 0, 50, 30 );
	$app_rect->{ btn_del } =  Btn_del->new;


	$app->add_show_handler ( sub{ $app_rect->draw } );
	$app->add_event_handler( sub{ _is_over   ( @_, $app_rect ) } );

	$app->add_event_handler( sub{ _observer( @_, $app_rect ) } );

	return $app_rect;
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



sub _is_over {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEMOTION
		or return;

	my $over;
	my @interface =  ( $app_rect->{ btn }, $app_rect->{ btn_del } );
	for my $shape ( $app_rect->{ children }->@*, @interface ) {
		$over =  $shape->is_over( $e->motion_x, $e->motion_y )
			or next;

		last;
	}

	$over   or return;

	$over->on_over( $e );

	# if( $app_rect->{ event_state }{ mbl } ) {
	# 	$over->moving_on( $event->motion_x, $event->motion_y );
	# }
}	




sub can_select {
	my( $app_rect, $x, $y ) =  @_;

	for my $child ( @$app_rect ){
		$child->is_over( $x, $y )   or next;

			return;
	}

	if( $app_rect->{ btn }->is_over( $event->motion_x, $event->motion_y ) ) { 
		return;
	}

	if( $app_rect->{ btn_del }->is_over( $event->motion_x, $event->motion_y ) ) { 
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

	$app_rect->{ app }->update;
}

1;
