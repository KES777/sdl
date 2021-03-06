use strict;
use warnings;

package SDL2::Surface;

use SDL2::Stdinc;
use SDL2::Rwops;
use SDL2::Blendmode;
use SDL2::Pixels;
use SDL2::Rect;

my $processed;
sub attach {
  !$processed   or return;
  $processed++;

	my( $ffi ) =  @_;

	$ffi->type( 'opaque' => 'SDL_Surface_ptr' );

  # typedef enum
  # {
  #     SDL_YUV_CONVERSION_JPEG,        /**< Full range JPEG */
  #     SDL_YUV_CONVERSION_BT601,       /**< BT.601 (the default) */
  #     SDL_YUV_CONVERSION_BT709,       /**< BT.709 */
  #     SDL_YUV_CONVERSION_AUTOMATIC    /**< BT.601 for SD content, BT.709 for HD content */
  # } SDL_YUV_CONVERSION_MODE;
  $ffi->load_custom_type('::Enum', 'SDL_YUV_CONVERSION_MODE',
    { ret => 'int', package => 'SDL2::Surface' },
    'SDL_YUV_CONVERSION_JPEG',        # /**< Full range JPEG */
    'SDL_YUV_CONVERSION_BT601',       # /**< BT.601 (the default) */
    'SDL_YUV_CONVERSION_BT709',       # /**< BT.709 */
    'SDL_YUV_CONVERSION_AUTOMATIC',   # /**< BT.601 for SD content, BT.709 for HD content */
  );


  SDL2::Stdinc::attach( $ffi );
  SDL2::Rwops::attach( $ffi );
  SDL2::Blendmode::attach( $ffi );
  SDL2::Pixels::attach( $ffi );
  SDL2::Rect::attach( $ffi );

	# extern DECLSPEC SDL_Surface *SDLCALL SDL_CreateRGBSurface
	#     (Uint32 flags, int width, int height, int depth,
	#      Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask);
	$ffi->attach( SDL_CreateRGBSurface  => [ 'uint32', 'int', 'int', 'int', 'uint32', 'uint32', 'uint32', 'uint32' ] => 'SDL_Surface_ptr'  );


	# extern DECLSPEC SDL_Surface *SDLCALL SDL_CreateRGBSurfaceWithFormat
	#     (Uint32 flags, int width, int height, int depth, Uint32 format);
	$ffi->attach( SDL_CreateRGBSurfaceWithFormat  => [ 'uint32', 'int', 'int', 'int', 'uint32' ] => 'SDL_Surface_ptr'  );


	# extern DECLSPEC SDL_Surface *SDLCALL SDL_CreateRGBSurfaceFrom(void *pixels,
	#                                                               int width,
	#                                                               int height,
	#                                                               int depth,
	#                                                               int pitch,
	#                                                               Uint32 Rmask,
	#                                                               Uint32 Gmask,
	#                                                               Uint32 Bmask,
	#                                                               Uint32 Amask);
	$ffi->attach( SDL_CreateRGBSurfaceFrom  => [ 'opaque', 'int', 'int', 'int', 'int', 'uint32', 'uint32', 'uint32', 'uint32' ] => 'SDL_Surface_ptr'  );


  # extern DECLSPEC SDL_Surface *SDLCALL SDL_CreateRGBSurfaceWithFormatFrom
  #     (void *pixels, int width, int height, int depth, int pitch, Uint32 format);
  $ffi->attach( SDL_CreateRGBSurfaceWithFormatFrom  => [ 'opaque', 'int', 'int', 'int', 'int', 'uint32' ] => 'SDL_Surface_ptr'  );


  # extern DECLSPEC void SDLCALL SDL_FreeSurface(SDL_Surface * surface);
  $ffi->attach( SDL_FreeSurface  => [ 'SDL_Surface_ptr' ] => 'void'  );


  # extern DECLSPEC int SDLCALL SDL_LockSurface(SDL_Surface * surface);
  $ffi->attach( SDL_LockSurface  => [ 'SDL_Surface_ptr' ] => 'int'  );


  # extern DECLSPEC void SDLCALL SDL_UnlockSurface(SDL_Surface * surface);
  $ffi->attach( SDL_UnlockSurface  => [ 'SDL_Surface_ptr' ] => 'void'  );


  # extern DECLSPEC SDL_Surface *SDLCALL SDL_LoadBMP_RW(SDL_RWops * src,
  #                                                     int freesrc);
  $ffi->attach( SDL_LoadBMP_RW  => [ 'SDL_RWops_ptr', 'int' ] => 'SDL_Surface_ptr'  );


  # extern DECLSPEC int SDLCALL SDL_SaveBMP_RW
  #     (SDL_Surface * surface, SDL_RWops * dst, int freedst);
  $ffi->attach( SDL_SaveBMP_RW  => [ 'SDL_Surface_ptr', 'SDL_RWops_ptr', 'int' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_SetSurfaceRLE(SDL_Surface * surface,
  #                                               int flag);
  $ffi->attach( SDL_SetSurfaceRLE  => [ 'SDL_Surface_ptr', 'int' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_SetColorKey(SDL_Surface * surface,
  #                                             int flag, Uint32 key);
  $ffi->attach( SDL_SetColorKey  => [ 'SDL_Surface_ptr', 'int', 'uint32' ] => 'int'  );


  # extern DECLSPEC SDL_bool SDLCALL SDL_HasColorKey(SDL_Surface * surface);
  $ffi->attach( SDL_HasColorKey  => [ 'SDL_Surface_ptr' ] => 'SDL_bool'  );


  # extern DECLSPEC int SDLCALL SDL_GetColorKey(SDL_Surface * surface,
                                              # Uint32 * key);
  $ffi->attach( SDL_GetColorKey  => [ 'SDL_Surface_ptr', 'uint32' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_SetSurfaceColorMod(SDL_Surface * surface,
  #                                                    Uint8 r, Uint8 g, Uint8 b);
  $ffi->attach( SDL_SetSurfaceColorMod  => [ 'SDL_Surface_ptr', 'uint8', 'uint8', 'uint8' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_GetSurfaceColorMod(SDL_Surface * surface,
  #                                                    Uint8 * r, Uint8 * g,
  #                                                    Uint8 * b);
  $ffi->attach( SDL_GetSurfaceColorMod  => [ 'SDL_Surface_ptr', 'uint8*', 'uint8*', 'uint8*' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_SetSurfaceAlphaMod(SDL_Surface * surface,
  #                                                    Uint8 alpha);
  $ffi->attach( SDL_SetSurfaceAlphaMod  => [ 'SDL_Surface_ptr', 'uint8' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_GetSurfaceAlphaMod(SDL_Surface * surface,
  #                                                    Uint8 * alpha);
  $ffi->attach( SDL_GetSurfaceAlphaMod  => [ 'SDL_Surface_ptr', 'uint8*' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_SetSurfaceBlendMode(SDL_Surface * surface,
  #                                                     SDL_BlendMode blendMode);
  $ffi->attach( SDL_SetSurfaceBlendMode  => [ 'SDL_Surface_ptr', 'SDL_BlendMode' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_GetSurfaceBlendMode(SDL_Surface * surface,
  #                                                     SDL_BlendMode *blendMode);
  $ffi->attach( SDL_GetSurfaceBlendMode  => [ 'SDL_Surface_ptr', 'SDL_BlendMode' ] => 'int'  );


  # extern DECLSPEC SDL_bool SDLCALL SDL_SetClipRect(SDL_Surface * surface,
  #                                                  const SDL_Rect * rect);
  $ffi->attach( SDL_SetClipRect  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr' ] => 'SDL_bool'  );


  # extern DECLSPEC void SDLCALL SDL_GetClipRect(SDL_Surface * surface,
  #                                              SDL_Rect * rect);
  $ffi->attach( SDL_GetClipRect  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr' ] => 'void'  );


  # extern DECLSPEC SDL_Surface *SDLCALL SDL_DuplicateSurface(SDL_Surface * surface);
  $ffi->attach( SDL_DuplicateSurface  => [ 'SDL_Surface_ptr' ] => 'SDL_Surface_ptr'  );


  # extern DECLSPEC SDL_Surface *SDLCALL SDL_ConvertSurface
  #     (SDL_Surface * src, const SDL_PixelFormat * fmt, Uint32 flags);
  $ffi->attach( SDL_ConvertSurface  => [ 'SDL_Surface_ptr', 'SDL_PixelFormat_ptr', 'uint32' ] => 'SDL_Surface_ptr'  );


  # extern DECLSPEC SDL_Surface *SDLCALL SDL_ConvertSurfaceFormat
  #     (SDL_Surface * src, Uint32 pixel_format, Uint32 flags);
  $ffi->attach( SDL_ConvertSurfaceFormat  => [ 'SDL_Surface_ptr', 'uint32', 'uint32' ] => 'SDL_Surface_ptr'  );


  # extern DECLSPEC int SDLCALL SDL_ConvertPixels(int width, int height,
  #                                               Uint32 src_format,
  #                                               const void * src, int src_pitch,
  #                                               Uint32 dst_format,
  #                                               void * dst, int dst_pitch);
  $ffi->attach( SDL_ConvertPixels  => [ 'int', 'int', 'uint32', 'opaque', 'int', 'uint32', 'opaque', 'int' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_FillRect
  #     (SDL_Surface * dst, const SDL_Rect * rect, Uint32 color);
  $ffi->attach( SDL_FillRect  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'uint32' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_FillRects
  #     (SDL_Surface * dst, const SDL_Rect * rects, int count, Uint32 color);
  $ffi->attach( SDL_FillRects  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'int', 'uint32' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_UpperBlit
  #     (SDL_Surface * src, const SDL_Rect * srcrect,
  #      SDL_Surface * dst, SDL_Rect * dstrect);
  $ffi->attach( SDL_UpperBlit  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'SDL_Surface_ptr', 'SDL_Rect_ptr' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_LowerBlit
  #     (SDL_Surface * src, SDL_Rect * srcrect,
  #      SDL_Surface * dst, SDL_Rect * dstrect);
  $ffi->attach( SDL_LowerBlit  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'SDL_Surface_ptr', 'SDL_Rect_ptr' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_SoftStretch(SDL_Surface * src,
  #                                             const SDL_Rect * srcrect,
  #                                             SDL_Surface * dst,
  #                                             const SDL_Rect * dstrect);
  $ffi->attach( SDL_SoftStretch  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'SDL_Surface_ptr', 'SDL_Rect_ptr' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_UpperBlitScaled
  #     (SDL_Surface * src, const SDL_Rect * srcrect,
  #     SDL_Surface * dst, SDL_Rect * dstrect);
  $ffi->attach( SDL_UpperBlitScaled  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'SDL_Surface_ptr', 'SDL_Rect_ptr' ] => 'int'  );


  # extern DECLSPEC int SDLCALL SDL_LowerBlitScaled
  #     (SDL_Surface * src, SDL_Rect * srcrect,
  #     SDL_Surface * dst, SDL_Rect * dstrect);
  $ffi->attach( SDL_LowerBlitScaled  => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'SDL_Surface_ptr', 'SDL_Rect_ptr' ] => 'int'  );


  # extern DECLSPEC void SDLCALL SDL_SetYUVConversionMode(SDL_YUV_CONVERSION_MODE mode);
  $ffi->attach( SDL_SetYUVConversionMode  => [ 'SDL_YUV_CONVERSION_MODE' ] => 'void'  );


  # extern DECLSPEC SDL_YUV_CONVERSION_MODE SDLCALL SDL_GetYUVConversionMode(void);
  $ffi->attach( SDL_GetYUVConversionMode  => [ 'void' ] => 'SDL_YUV_CONVERSION_MODE'  );


  # extern DECLSPEC SDL_YUV_CONVERSION_MODE SDLCALL SDL_GetYUVConversionModeForResolution(int width, int height);
  $ffi->attach( SDL_GetYUVConversionModeForResolution  => [ 'int', 'int' ] => 'SDL_YUV_CONVERSION_MODE'  );

}

1;
