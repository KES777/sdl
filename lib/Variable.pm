package Variable;

use strict;
use warnings;

use Rect;
use SDLx::Text;

use base 'Rect';
use Dumper;

sub new {
	my( $self, $name, $value ) =  ( shift, shift, shift );

	$self =  $self->SUPER::new( @_ );

	$self->{ name }  =  $name;
	$self->{ value } =  $value;

	return $self;
}



sub store {}



sub draw {
	my( $self, $x, $y ) = @_;

	$self->SUPER::draw( );

	my $value =  $self->{ name };
	if( length $value ) {
		my $text =  SDLx::Text->new(
			color   =>  [0, 0, 0], # "white"
			size    =>  16,
			h_align =>  'left',
			text    =>  $value ."",
		);
		$x +=  $self->{x} +($self->{w} - $text->w)/2;
		$y +=  $self->{y} +($self->{h} - $text->h)/2;
		$text->write_xy( AppRect::SCREEN(), $x, $y );
	}

	Dumper::dump( $x, $y, $self->{ value } )
		if $self->{ xx };
}



sub on_mouse_over {
	my( $self, $h, $e ) =  @_;

	$self->{ xx } =  1;
}

sub on_mouse_out {
	my( $self, $h, $e ) =  @_;

	delete $self->{ xx };
}

1;
