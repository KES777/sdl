package SDL2::Blendmode;

use strict;
use warnings;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	$ffi->type( 'int' => 'SDL_BlendMode' );               #enum
	$ffi->type( 'int' => 'SDL_BlendOperation' );          #enum
	$ffi->type( 'int' => 'SDL_BlendFactor' );             #enum


	# extern DECLSPEC SDL_BlendMode SDLCALL SDL_ComposeCustomBlendMode(SDL_BlendFactor srcColorFactor,
	#                                                                  SDL_BlendFactor dstColorFactor,
	#                                                                  SDL_BlendOperation colorOperation,
	#                                                                  SDL_BlendFactor srcAlphaFactor,
	#                                                                  SDL_BlendFactor dstAlphaFactor,
	#                                                                  SDL_BlendOperation alphaOperation);
	$ffi->attach( SDL_ComposeCustomBlendMode => [ 	'SDL_BlendFactor',
													'SDL_BlendFactor',
													'SDL_BlendOperation',
													'SDL_BlendFactor',
													'SDL_BlendFactor',
													'SDL_BlendOperation',
	] => 'SDL_BlendMode' );



}

1;
