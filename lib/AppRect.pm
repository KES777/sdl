package AppRect;

use SDLx::App;
use Btn_del;

use Rect;
use base 'Rect';

sub new {
	my( $rect, $app_w, $app_h ) =  @_;

	$app_rect =  $rect->SUPER::new( 0, 0, $app_w, $app_h );

	$app_rect->{ app } =  $app // SDLx::App->new( width => $app_w, height => $app_h, resizeable => 1);

	$app_rect->{ btn     } =  Rect->new( 0, 0, 50, 30 );
	$app_rect->{ btn_del } =  Btn_del->new;

	return $app_rect;
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

	#size_button
	if( !$rect->{ selection } ) {

		$app_rect->{ app }->draw_rect([
			$app_rect->{ x } + $rect->{ w } -15,
			$app_rect->{ y } + $rect->{ h } -10,
			15,
			10,
		],[ 
			33, 200, 150, 255
		]);
	}


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
