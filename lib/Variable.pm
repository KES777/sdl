package Variable;

use strict;
use warnings;

use Rect;
use SDLx::Text;

use base 'Rect';


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
}

1;
