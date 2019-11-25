package SDL2::Rect;

sub attach {
	my( $ffi ) =  @_;

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasIntersection(const SDL_Rect * A,
	#                                                      const SDL_Rect * B);
	$ffi->type( 'opaque' => 'SDL_bool_ptr' );
	$ffi->type( 'opaque' => 'SDL_Rect_ptr' );
	$ffi->attach( SDL_HasIntersection  => [ 'SDL_Rect_ptr', 'SDL_Rect_ptr' ] => 'SDL_bool_ptr'  );


	# extern DECLSPEC SDL_bool SDLCALL SDL_IntersectRect(const SDL_Rect * A,
	#                                                    const SDL_Rect * B,
	#                                                    SDL_Rect * result);
	$ffi->attach( SDL_IntersectRect  => [ 'SDL_Rect_ptr', 'SDL_Rect_ptr', 'SDL_Rect_ptr' ] => 'SDL_bool_ptr'  );


	# extern DECLSPEC void SDLCALL SDL_UnionRect(const SDL_Rect * A,
	#                                            const SDL_Rect * B,
	#                                            SDL_Rect * result);
	$ffi->attach( SDL_UnionRect  => [ 'SDL_Rect_ptr', 'SDL_Rect_ptr', 'SDL_Rect_ptr' ] => 'void'  );


	# extern DECLSPEC SDL_bool SDLCALL SDL_EnclosePoints(const SDL_Point * points,
	#                                                    int count,
	#                                                    const SDL_Rect * clip,
	#                                                    SDL_Rect * result);
	$ffi->type( 'opaque' => 'SDL_Point_ptr' );
	$ffi->attach( SDL_EnclosePoints  => [ 'SDL_Point_ptr', 'int', 'SDL_Rect_ptr', 'SDL_Rect_ptr' ] => 'SDL_bool_ptr'  );


	# extern DECLSPEC SDL_bool SDLCALL SDL_IntersectRectAndLine(const SDL_Rect *
	#                                                           rect, int *X1,
	#                                                           int *Y1, int *X2,
	#                                                           int *Y2);
	$ffi->attach( SDL_IntersectRectAndLine  => [  'SDL_Rect_ptr', 'int', 'int', 'int', 'int'  ] => 'SDL_bool_ptr'  );


}

1;
