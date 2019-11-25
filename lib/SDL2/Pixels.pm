package SDL2::Pixels;

sub attach {
	my( $ffi ) =  @_;


	# extern DECLSPEC const char* SDLCALL SDL_GetPixelFormatName(Uint32 format);
	$ffi->attach( SDL_GetPixelFormatName  => [ 'uint32' ] => 'string'  );


	# extern DECLSPEC SDL_bool SDLCALL SDL_PixelFormatEnumToMasks(Uint32 format,
	#                                                             int *bpp,
	#                                                             Uint32 * Rmask,
	#                                                             Uint32 * Gmask,
	#                                                             Uint32 * Bmask,
	#                                                             Uint32 * Amask);
	$ffi->type( 'opaque' => 'SDL_bool_ptr' );
	$ffi->attach( SDL_PixelFormatEnumToMasks  => [ 'uint32', 'int', 'uint32*', 'uint32*', 'uint32*', 'uint32*' ] => 'SDL_bool_ptr'  );


	# extern DECLSPEC Uint32 SDLCALL SDL_MasksToPixelFormatEnum(int bpp,
	#                                                           Uint32 Rmask,
	#                                                           Uint32 Gmask,
	#                                                           Uint32 Bmask,
	#                                                           Uint32 Amask);
	$ffi->attach( SDL_MasksToPixelFormatEnum  => [ 'int', 'uint32*', 'uint32*', 'uint32*', 'uint32*' ] => 'uint32'  );


	# extern DECLSPEC void SDLCALL SDL_FreeFormat(SDL_PixelFormat *format);
	$ffi->type( 'opaque' => 'SDL_PixelFormat_ptr' );
	$ffi->attach( SDL_FreeFormat  => [ 'SDL_PixelFormat_ptr' ] => 'void'  );


	# extern DECLSPEC SDL_Palette *SDLCALL SDL_AllocPalette(int ncolors);
	$ffi->type( 'opaque' => 'SDL_Palette_ptr' );
	$ffi->attach( SDL_AllocPalette  => [ 'int' ] => 'SDL_Palette_ptr'  );


	# extern DECLSPEC int SDLCALL SDL_SetPixelFormatPalette(SDL_PixelFormat * format,
	#                                                       SDL_Palette *palette);
	$ffi->attach( SDL_SetPixelFormatPalette  => [ 'SDL_PixelFormat_ptr', 'SDL_Palette_ptr' ] => 'int'  );


	# extern DECLSPEC int SDLCALL SDL_SetPaletteColors(SDL_Palette * palette,
	#                                                  const SDL_Color * colors,
	#                                                  int firstcolor, int ncolors);
	$ffi->type( 'opaque' => 'SDL_Color_ptr' );
	$ffi->attach( SDL_SetPaletteColors  => [ 'SDL_Palette_ptr', 'SDL_Color_ptr', 'int', 'int' ] => 'int'  );


	# extern DECLSPEC void SDLCALL SDL_FreePalette(SDL_Palette * palette);
	$ffi->attach( SDL_FreePalette  => [ 'SDL_Palette_ptr' ] => 'void'  );


	# extern DECLSPEC Uint32 SDLCALL SDL_MapRGB(const SDL_PixelFormat * format,
	#                                           Uint8 r, Uint8 g, Uint8 b);
	$ffi->attach( SDL_MapRGB  => [ 'SDL_PixelFormat_ptr', 'uint8', 'uint8', 'uint8' ] => 'uint32'  );


	# extern DECLSPEC Uint32 SDLCALL SDL_MapRGBA(const SDL_PixelFormat * format,
	#                                            Uint8 r, Uint8 g, Uint8 b,
	#                                            Uint8 a);
	$ffi->attach( SDL_MapRGBA  => [ 'SDL_PixelFormat_ptr', 'uint8', 'uint8', 'uint8', 'uint8' ] => 'uint32'  );


	# extern DECLSPEC void SDLCALL SDL_GetRGB(Uint32 pixel,
	#                                         const SDL_PixelFormat * format,
	#                                         Uint8 * r, Uint8 * g, Uint8 * b);
	$ffi->attach( SDL_GetRGB  => [ 'uint32', 'SDL_PixelFormat_ptr', 'uint8*', 'uint8*', 'uint8*' ] => 'void'  );


	# extern DECLSPEC void SDLCALL SDL_GetRGBA(Uint32 pixel,
	#                                          const SDL_PixelFormat * format,
	#                                          Uint8 * r, Uint8 * g, Uint8 * b,
	#                                          Uint8 * a);
	$ffi->attach( SDL_GetRGBA  => [ 'uint32', 'SDL_PixelFormat_ptr', 'uint8*', 'uint8*', 'uint8*', 'uint8*' ] => 'void'  );


	# extern DECLSPEC void SDLCALL SDL_CalculateGammaRamp(float gamma, Uint16 * ramp);
	$ffi->attach( SDL_CalculateGammaRamp  => [ 'fload', 'uint16*' ] => 'void'  );

}

1;
