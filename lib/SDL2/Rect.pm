use strict;
use warnings;

package SDL2::Rect;

use SDL2::Stdinc;
use SDL2::Pixels;

use FFI::C::StructDef;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	SDL2::Stdinc::attach( $ffi );
	SDL2::Pixels::attach( $ffi );

	FFI::C::StructDef->new(
		$ffi,
		nullable =>  1,
		name     =>  'SDL_Rect',
		class    =>  'SDL2::Rect',
		members  =>  [
			x =>  'int',
			y =>  'int',
			w =>  'int',
			h =>  'int',
		],
	);


	$ffi->type( 'opaque' => 'SDL_Point_ptr'  );
	$ffi->type( 'opaque' => 'SDL_FPoint_ptr' );
	$ffi->type( SDL_Rect => 'SDL_Rect_ptr'   );
	$ffi->type( 'opaque' => 'SDL_FRect_ptr'  );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasIntersection(const SDL_Rect * A,
	#                                                      const SDL_Rect * B);
	# $ffi->type( 'opaque' => 'SDL_bool' );
	$ffi->attach( SDL_HasIntersection  => [ 'SDL_Rect', 'SDL_Rect' ] => 'SDL_bool'  );


	# extern DECLSPEC SDL_bool SDLCALL SDL_IntersectRect(const SDL_Rect * A,
	#                                                    const SDL_Rect * B,
	#                                                    SDL_Rect * result);
	$ffi->attach( SDL_IntersectRect  => [ 'SDL_Rect', 'SDL_Rect', 'SDL_Rect' ] => 'SDL_bool'  );


	# extern DECLSPEC void SDLCALL SDL_UnionRect(const SDL_Rect * A,
	#                                            const SDL_Rect * B,
	#                                            SDL_Rect * result);
	$ffi->attach( SDL_UnionRect  => [ 'SDL_Rect', 'SDL_Rect', 'SDL_Rect' ] => 'void'  );


	# extern DECLSPEC SDL_bool SDLCALL SDL_EnclosePoints(const SDL_Point * points,
	#                                                    int count,
	#                                                    const SDL_Rect * clip,
	#                                                    SDL_Rect * result);
	$ffi->attach( SDL_EnclosePoints  => [ 'SDL_Point_ptr', 'int', 'SDL_Rect', 'SDL_Rect' ] => 'SDL_bool'  );


	# extern DECLSPEC SDL_bool SDLCALL SDL_IntersectRectAndLine(const SDL_Rect *
	#                                                           rect, int *X1,
	#                                                           int *Y1, int *X2,
	#                                                           int *Y2);
	$ffi->attach( SDL_IntersectRectAndLine  => [  'SDL_Rect', 'int', 'int', 'int', 'int'  ] => 'SDL_bool'  );


}

1;
