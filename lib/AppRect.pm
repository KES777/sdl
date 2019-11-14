package AppRect;

use SDLx::App;

use Rect;
use base 'Rect';

sub new {
	my( $rect, $app ) =  @_;

	$rect =  $rect->SUPER::new( 0, 0, $app->width, $app->height );

	$rect->{ app } =  $app // SDLx::App->new( width => $app_w, height => $app_h, resizeable => 1);

	return $rect;
}


sub draw {
	my( $rect ) =  @_;

	#size_button
	if( !$rect->{ selection } ) {

		$rect->{ app }->draw_rect([
			$rect->{ x } + $rect->{ w } -15,
			$rect->{ y } + $rect->{ h } -10,
			15,
			10,
		],[ 
			33, 200, 150, 255
		]);
	}


	if( $rect->{ children } ) {
		for my $s ( $rect->{ children }->@* ) {
			$s   or next;
			$s->draw( $rect->{ app } );
		}
	}

	$rect->{ app }->update;
}

1;
