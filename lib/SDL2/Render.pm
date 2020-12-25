package SDL2::Render;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_rect.h"
#include "SDL_video.h"
use SDL2::Stdinc;
use SDL2::Rect;
use SDL2::Video;

use FFI::C::StructDef;


my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;


  # typedef enum
  # {
  #     SDL_RENDERER_SOFTWARE = 0x00000001,         /**< The renderer is a software fallback */
  #     SDL_RENDERER_ACCELERATED = 0x00000002,      /**< The renderer uses hardware
  #                                                      acceleration */
  #     SDL_RENDERER_PRESENTVSYNC = 0x00000004,     /**< Present is synchronized
  #                                                      with the refresh rate */
  #     SDL_RENDERER_TARGETTEXTURE = 0x00000008     /**< The renderer supports
  #                                                      rendering to texture */
  # } SDL_RendererFlags;
  $ffi->load_custom_type('::Enum', 'SDL_RendererFlags',
    { ret => 'int', package => 'SDL2::Render' },
    ['SDL_RENDERER_SOFTWARE'      => 0x00000001],
    ['SDL_RENDERER_ACCELERATED'   => 0x00000002],
    ['SDL_RENDERER_PRESENTVSYNC'  => 0x00000004],
    ['SDL_RENDERER_TARGETTEXTURE' => 0x00000008],
  );

  # typedef struct SDL_RendererInfo
  # {
  #     const char *name;           /**< The name of the renderer */
  #     Uint32 flags;               /**< Supported ::SDL_RendererFlags */
  #     Uint32 num_texture_formats; /**< The number of available texture formats */
  #     Uint32 texture_formats[16]; /**< The available texture formats */
  #     int max_texture_width;      /**< The maximum texture width */
  #     int max_texture_height;     /**< The maximum texture height */
  # } SDL_RendererInfo;
  FFI::C::StructDef->new(
    $ffi,
    nullable =>  1,
    name     =>  'SDL_RendererInfo',
    class    =>  'SDL2::RendererInfo',
    members  =>  [
      name                =>  'opaque',
      flags               =>  'uint32',
      num_texture_formats =>  'uint32',
      texture_formats     =>  'uint32[16]',
      max_texture_width   =>  'int',
      max_texture_height  =>  'int',
    ],
  );

  $ffi->type( 'SDL_RendererInfo' => 'SDL_RendererInfo_ptr' );


  # typedef enum
  # {
  #     SDL_TEXTUREACCESS_STATIC,    /**< Changes rarely, not lockable */
  #     SDL_TEXTUREACCESS_STREAMING, /**< Changes frequently, lockable */
  #     SDL_TEXTUREACCESS_TARGET     /**< Texture can be used as a render target */
  # } SDL_TextureAccess;
  $ffi->load_custom_type('::Enum', 'SDL_TextureAccess',
    { ret => 'int', package => 'SDL2::Render' },
      'SDL_TEXTUREACCESS_STATIC',    # /**< Changes rarely, not lockable */
      'SDL_TEXTUREACCESS_STREAMING', # /**< Changes frequently, lockable */
      'SDL_TEXTUREACCESS_TARGET',    # /**< Texture can be used as a render target */
  );

  # typedef enum
  # {
  #     SDL_TEXTUREMODULATE_NONE = 0x00000000,     /**< No modulation */
  #     SDL_TEXTUREMODULATE_COLOR = 0x00000001,    /**< srcC = srcC * color */
  #     SDL_TEXTUREMODULATE_ALPHA = 0x00000002     /**< srcA = srcA * alpha */
  # } SDL_TextureModulate;
  $ffi->load_custom_type('::Enum', 'SDL_TextureModulate',
    { ret => 'int', package => 'SDL2::Render' },
    ['SDL_TEXTUREMODULATE_NONE'  => 0x00000000],     # /**< No modulation */
    ['SDL_TEXTUREMODULATE_COLOR' => 0x00000001],     # /**< srcC = srcC * color */
    ['SDL_TEXTUREMODULATE_ALPHA' => 0x00000002],     # /**< srcA = srcA * alpha */
  );

  # typedef enum
  # {
  #     SDL_FLIP_NONE = 0x00000000,     /**< Do not flip */
  #     SDL_FLIP_HORIZONTAL = 0x00000001,    /**< flip horizontally */
  #     SDL_FLIP_VERTICAL = 0x00000002     /**< flip vertically */
  # } SDL_RendererFlip;
  $ffi->load_custom_type('::Enum', 'SDL_RendererFlip',
    { ret => 'int', package => 'SDL2::Render' },
    ['SDL_FLIP_NONE'       => 0x00000000],    #  /**< Do not flip */
    ['SDL_FLIP_HORIZONTAL' => 0x00000001],    #  /**< flip horizontally */
    ['SDL_FLIP_VERTICAL'   => 0x00000002],    #  /**< flip vertically */
  );


	$ffi->type( 'opaque' => 'SDL_Renderer_ptr' );                #struct
	$ffi->type( 'opaque' => 'SDL_Texture_ptr' );                 #struct

	SDL2::Stdinc::attach( $ffi );
	SDL2::Rect::attach( $ffi );
	SDL2::Video::attach( $ffi );

  # extern DECLSPEC int SDLCALL SDL_GetNumRenderDrivers(void);
  $ffi->attach( SDL_GetNumRenderDrivers => [ 'void'  ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_GetRenderDriverInfo(int index,
  #                                                     SDL_RendererInfo * info);
  $ffi->attach( SDL_GetRenderDriverInfo => [ 'int', 'SDL_RendererInfo_ptr' ] => 'int' );

# ?????????????????????**
  # extern DECLSPEC int SDLCALL SDL_CreateWindowAndRenderer(
  #                                 int width, int height, Uint32 window_flags,
  #                                 SDL_Window **window, SDL_Renderer **renderer);
  $ffi->attach( SDL_CreateWindowAndRenderer => [ 'int', 'int', 'uint32', 'SDL_Window_ptr', 'SDL_Renderer_ptr' ] => 'int' );

  # extern DECLSPEC SDL_Renderer * SDLCALL SDL_CreateRenderer(SDL_Window * window,
  #                                                int index, Uint32 flags);
  $ffi->attach( SDL_CreateRenderer => [ 'SDL_Window_ptr', 'int', 'uint32' ] => 'SDL_Renderer_ptr' );

  # extern DECLSPEC SDL_Renderer * SDLCALL SDL_CreateSoftwareRenderer(SDL_Surface * surface);
  $ffi->attach( SDL_CreateSoftwareRenderer => [ 'SDL_Surface_ptr' ] => 'SDL_Renderer_ptr' );

  # extern DECLSPEC SDL_Renderer * SDLCALL SDL_GetRenderer(SDL_Window * window);
  $ffi->attach( SDL_GetRenderer => [ 'SDL_Window_ptr' ] => 'SDL_Renderer_ptr' );

  # extern DECLSPEC int SDLCALL SDL_GetRendererInfo(SDL_Renderer * renderer,
  #                                                 SDL_RendererInfo * info);
  $ffi->attach( SDL_GetRendererInfo => [ 'SDL_Renderer_ptr', 'SDL_RendererInfo_ptr' ] => 'int' );


  # extern DECLSPEC int SDLCALL SDL_GetRendererOutputSize(SDL_Renderer * renderer,
  #                                                       int *w, int *h);
  $ffi->attach( SDL_GetRendererOutputSize => [ 'SDL_Renderer_ptr', 'int', 'int' ] => 'int' );

  # extern DECLSPEC SDL_Texture * SDLCALL SDL_CreateTexture(SDL_Renderer * renderer,
  #                                                         Uint32 format,
  #                                                         int access, int w,
  #                                                         int h);
  $ffi->attach( SDL_CreateTexture => [ 'SDL_Renderer_ptr', 'uint32', 'int', 'int', 'int' ] => 'SDL_Texture_ptr' );


  # extern DECLSPEC SDL_Texture * SDLCALL SDL_CreateTextureFromSurface(SDL_Renderer * renderer, SDL_Surface * surface);
  $ffi->attach( SDL_CreateTextureFromSurface => [ 'SDL_Renderer_ptr', 'SDL_Surface_ptr' ] => 'SDL_Texture_ptr' );

  # extern DECLSPEC int SDLCALL SDL_QueryTexture(SDL_Texture * texture,
  #                                              Uint32 * format, int *access,
  #                                              int *w, int *h);
  $ffi->attach( SDL_QueryTexture => [ 'SDL_Texture_ptr', 'uint32', 'int', 'int', 'int' ] => 'int' );


  # extern DECLSPEC int SDLCALL SDL_SetTextureColorMod(SDL_Texture * texture,
  #                                                    Uint8 r, Uint8 g, Uint8 b);
  $ffi->attach( SDL_SetTextureColorMod => [ 'SDL_Texture_ptr', 'uint8', 'uint8', 'uint8' ] => 'int' );


  # extern DECLSPEC int SDLCALL SDL_GetTextureColorMod(SDL_Texture * texture,
  #                                                    Uint8 * r, Uint8 * g,
  #                                                    Uint8 * b);
  $ffi->attach( SDL_GetTextureColorMod => [ 'SDL_Texture_ptr', 'uint8*', 'uint8*', 'uint8*' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_SetTextureAlphaMod(SDL_Texture * texture,
  #                                                    Uint8 alpha);
  $ffi->attach( SDL_SetTextureAlphaMod => [ 'SDL_Texture_ptr', 'uint8' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_GetTextureAlphaMod(SDL_Texture * texture,
  #                                                    Uint8 * alpha);
  $ffi->attach( SDL_GetTextureAlphaMod => [ 'SDL_Texture_ptr', 'uint8*' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_SetTextureBlendMode(SDL_Texture * texture,
  #                                                     SDL_BlendMode blendMode);
  $ffi->attach( SDL_SetTextureBlendMode => [ 'SDL_Texture_ptr', 'SDL_BlendMode' ] => 'int' );

# ?????????????????*
  # extern DECLSPEC int SDLCALL SDL_GetTextureBlendMode(SDL_Texture * texture,
  #                                                     SDL_BlendMode *blendMode);
  $ffi->attach( SDL_GetTextureBlendMode => [ 'SDL_Texture_ptr', 'SDL_BlendMode' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_UpdateTexture(SDL_Texture * texture,
  #                                               const SDL_Rect * rect,
  #                                               const void *pixels, int pitch);
  $ffi->attach( SDL_UpdateTexture => [ 'SDL_Texture_ptr', 'SDL_Rect_ptr', 'opaque', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_UpdateYUVTexture(SDL_Texture * texture,
  #                                                  const SDL_Rect * rect,
  #                                                  const Uint8 *Yplane, int Ypitch,
  #                                                  const Uint8 *Uplane, int Upitch,
  #                                                  const Uint8 *Vplane, int Vpitch);
  $ffi->attach( SDL_UpdateYUVTexture => [ 'SDL_Texture_ptr', 'SDL_Rect_ptr', 'uint8*', 'int', 'uint8*', 'int', 'uint8*', 'int' ] => 'int' );

# ???????????????????????void**
  # extern DECLSPEC int SDLCALL SDL_LockTexture(SDL_Texture * texture,
  #                                             const SDL_Rect * rect,
  #                                             void **pixels, int *pitch);
  $ffi->attach( SDL_LockTexture => [ 'SDL_Texture_ptr', 'SDL_Rect_ptr', 'opaque*', 'int*' ] => 'int' );

  # extern DECLSPEC void SDLCALL SDL_UnlockTexture(SDL_Texture * texture);
  $ffi->attach( SDL_UnlockTexture => [ 'SDL_Texture_ptr' ] => 'void' );

  # extern DECLSPEC SDL_bool SDLCALL SDL_RenderTargetSupported(SDL_Renderer *renderer);
  $ffi->attach( SDL_RenderTargetSupported => [ 'SDL_Renderer_ptr' ] => 'SDL_bool' );

  # extern DECLSPEC int SDLCALL SDL_SetRenderTarget(SDL_Renderer *renderer,
  #                                                 SDL_Texture *texture);
  $ffi->attach( SDL_SetRenderTarget => [ 'SDL_Renderer_ptr', 'SDL_Texture_ptr' ] => 'int' );

  # extern DECLSPEC SDL_Texture * SDLCALL SDL_GetRenderTarget(SDL_Renderer *renderer);
  $ffi->attach( SDL_GetRenderTarget => [ 'SDL_Renderer_ptr' ] => 'SDL_Texture_ptr' );

  # extern DECLSPEC int SDLCALL SDL_RenderSetLogicalSize(SDL_Renderer * renderer, int w, int h);
  $ffi->attach( SDL_RenderSetLogicalSize => [ 'SDL_Renderer_ptr' ] => 'int' );

  # extern DECLSPEC void SDLCALL SDL_RenderGetLogicalSize(SDL_Renderer * renderer, int *w, int *h);
  $ffi->attach( SDL_RenderGetLogicalSize => [ 'SDL_Renderer_ptr', 'int*', 'int*' ] => 'void' );

  # extern DECLSPEC int SDLCALL SDL_RenderSetIntegerScale(SDL_Renderer * renderer,
  #                                                       SDL_bool enable);
  $ffi->attach( SDL_RenderSetIntegerScale => [ 'SDL_Renderer_ptr', 'SDL_bool' ] => 'int' );

  # extern DECLSPEC SDL_bool SDLCALL SDL_RenderGetIntegerScale(SDL_Renderer * renderer);
  $ffi->attach( SDL_RenderGetIntegerScale => [ 'SDL_Renderer_ptr' ] => 'SDL_bool' );

  # extern DECLSPEC int SDLCALL SDL_RenderSetViewport(SDL_Renderer * renderer,
  #                                                   const SDL_Rect * rect);
  $ffi->attach( SDL_RenderSetViewport => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr' ] => 'int' );

  # extern DECLSPEC void SDLCALL SDL_RenderGetViewport(SDL_Renderer * renderer,
  #                                                    SDL_Rect * rect);
  $ffi->attach( SDL_RenderGetViewport => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr' ] => 'void' );

  # extern DECLSPEC int SDLCALL SDL_RenderSetClipRect(SDL_Renderer * renderer,
  #                                                   const SDL_Rect * rect);
  $ffi->attach( SDL_RenderSetClipRect => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr' ] => 'int' );

  # extern DECLSPEC void SDLCALL SDL_RenderGetClipRect(SDL_Renderer * renderer,
  #                                                    SDL_Rect * rect);
  $ffi->attach( SDL_RenderGetClipRect => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr' ] => 'void' );

  # extern DECLSPEC SDL_bool SDLCALL SDL_RenderIsClipEnabled(SDL_Renderer * renderer);
  $ffi->attach( SDL_RenderIsClipEnabled => [ 'SDL_Renderer_ptr' ] => 'SDL_bool' );

  # extern DECLSPEC int SDLCALL SDL_RenderSetScale(SDL_Renderer * renderer,
  #                                                float scaleX, float scaleY);
  $ffi->attach( SDL_RenderSetScale => [ 'SDL_Renderer_ptr', 'float', 'float' ] => 'int' );

  # extern DECLSPEC void SDLCALL SDL_RenderGetScale(SDL_Renderer * renderer,
  #                                                float *scaleX, float *scaleY);
  $ffi->attach( SDL_RenderGetScale => [ 'SDL_Renderer_ptr', 'float', 'float' ] => 'void' );

  # extern DECLSPEC int SDLCALL SDL_SetRenderDrawColor(SDL_Renderer * renderer,
  #                                            Uint8 r, Uint8 g, Uint8 b,
  #                                            Uint8 a);
  $ffi->attach( SDL_SetRenderDrawColor => [ 'SDL_Renderer_ptr', 'uint8', 'uint8', 'uint8', 'uint8' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_GetRenderDrawColor(SDL_Renderer * renderer,
  #                                            Uint8 * r, Uint8 * g, Uint8 * b,
  #                                            Uint8 * a);
  $ffi->attach( SDL_GetRenderDrawColor => [ 'SDL_Renderer_ptr', 'uint8*', 'uint8*', 'uint8*', 'uint8*' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_SetRenderDrawBlendMode(SDL_Renderer * renderer,
  #                                                        SDL_BlendMode blendMode);
  $ffi->attach( SDL_SetRenderDrawBlendMode => [ 'SDL_Renderer_ptr', 'SDL_BlendMode' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_GetRenderDrawBlendMode(SDL_Renderer * renderer,
  #                                                        SDL_BlendMode *blendMode);
  $ffi->attach( SDL_GetRenderDrawBlendMode => [ 'SDL_Renderer_ptr', 'SDL_BlendMode' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderClear(SDL_Renderer * renderer);
  $ffi->attach( SDL_RenderClear => [ 'SDL_Renderer_ptr' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawPoint(SDL_Renderer * renderer,
  #                                                 int x, int y);
  $ffi->attach( SDL_RenderDrawPoint => [ 'SDL_Renderer_ptr', 'int', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawPoints(SDL_Renderer * renderer,
  #                                                  const SDL_Point * points,
  #                                                  int count);
  $ffi->attach( SDL_RenderDrawPoints => [ 'SDL_Renderer_ptr', 'SDL_Point_ptr', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawLine(SDL_Renderer * renderer,
  #                                                int x1, int y1, int x2, int y2);
  $ffi->attach( SDL_RenderDrawLine => [ 'SDL_Renderer_ptr', 'int', 'int', 'int', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawLines(SDL_Renderer * renderer,
  #                                                 const SDL_Point * points,
  #                                                 int count);
  $ffi->attach( SDL_RenderDrawLines => [ 'SDL_Renderer_ptr', 'SDL_Point_ptr', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawRect(SDL_Renderer * renderer,
  #                                                const SDL_Rect * rect);
  $ffi->attach( SDL_RenderDrawRect => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawRects(SDL_Renderer * renderer,
  #                                                 const SDL_Rect * rects,
  #                                                 int count);
  $ffi->attach( SDL_RenderDrawRects => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderFillRect(SDL_Renderer * renderer,
  #                                                const SDL_Rect * rect);
  $ffi->attach( SDL_RenderFillRect => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderFillRects(SDL_Renderer * renderer,
  #                                                 const SDL_Rect * rects,
  #                                                 int count);
  $ffi->attach( SDL_RenderFillRects => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderCopy(SDL_Renderer * renderer,
  #                                            SDL_Texture * texture,
  #                                            const SDL_Rect * srcrect,
  #                                            const SDL_Rect * dstrect);
  $ffi->attach( SDL_RenderCopy => [ 'SDL_Renderer_ptr', 'SDL_Texture_ptr', 'SDL_Rect_ptr', 'SDL_Rect_ptr' ] => 'int' );

# ?????????????????const double angle
  # extern DECLSPEC int SDLCALL SDL_RenderCopyEx(SDL_Renderer * renderer,
  #                                            SDL_Texture * texture,
  #                                            const SDL_Rect * srcrect,
  #                                            const SDL_Rect * dstrect,
  #                                            const double angle,
  #                                            const SDL_Point *center,
  #                                            const SDL_RendererFlip flip);
  $ffi->attach( SDL_RenderCopyEx => [ 'SDL_Renderer_ptr', 'SDL_Texture_ptr', 'SDL_Rect_ptr', 'SDL_Rect_ptr', 'double', 'SDL_Point_ptr', 'SDL_RendererFlip' ] => 'int' );


  # extern DECLSPEC int SDLCALL SDL_RenderDrawPointF(SDL_Renderer * renderer,
  #                                                  float x, float y);
  $ffi->attach( SDL_RenderDrawPointF => [ 'SDL_Renderer_ptr', 'float', 'float' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawPointsF(SDL_Renderer * renderer,
  #                                                   const SDL_FPoint * points,
  #                                                   int count);
  $ffi->attach( SDL_RenderDrawPointsF => [ 'SDL_Renderer_ptr', 'SDL_FPoint_ptr', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawLineF(SDL_Renderer * renderer,
  #                                                 float x1, float y1, float x2, float y2);
  $ffi->attach( SDL_RenderDrawLineF => [ 'SDL_Renderer_ptr', 'float', 'float', 'float', 'float' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawLinesF(SDL_Renderer * renderer,
  #                                                 const SDL_FPoint * points,
  #                                                 int count);
  $ffi->attach( SDL_RenderDrawLinesF => [ 'SDL_Renderer_ptr', 'SDL_FPoint_ptr', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawRectF(SDL_Renderer * renderer,
  #                                                const SDL_FRect * rect);
  $ffi->attach( SDL_RenderDrawRectF => [ 'SDL_Renderer_ptr', 'SDL_FRect_ptr' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderDrawRectsF(SDL_Renderer * renderer,
  #                                                  const SDL_FRect * rects,
  #                                                  int count);
  $ffi->attach( SDL_RenderDrawRectsF => [ 'SDL_Renderer_ptr', 'SDL_FRect_ptr', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderFillRectF(SDL_Renderer * renderer,
  #                                                 const SDL_FRect * rect);
  $ffi->attach( SDL_RenderFillRectF => [ 'SDL_Renderer_ptr', 'SDL_FRect_ptr' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderFillRectsF(SDL_Renderer * renderer,
  #                                                  const SDL_FRect * rects,
  #                                                  int count);
  $ffi->attach( SDL_RenderFillRectsF => [ 'SDL_Renderer_ptr', 'SDL_FRect_ptr', 'int' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderCopyF(SDL_Renderer * renderer,
  #                                             SDL_Texture * texture,
  #                                             const SDL_Rect * srcrect,
  #                                             const SDL_FRect * dstrect);
  $ffi->attach( SDL_RenderCopyF => [ 'SDL_Renderer_ptr', 'SDL_Texture_ptr', 'SDL_Rect_ptr', 'SDL_FRect_ptr' ] => 'int' );

# ???????????????????????const double angle
  # extern DECLSPEC int SDLCALL SDL_RenderCopyExF(SDL_Renderer * renderer,
  #                                             SDL_Texture * texture,
  #                                             const SDL_Rect * srcrect,
  #                                             const SDL_FRect * dstrect,
  #                                             const double angle,
  #                                             const SDL_FPoint *center,
  #                                             const SDL_RendererFlip flip);
  $ffi->attach( SDL_RenderCopyExF => [ 'SDL_Renderer_ptr', 'SDL_Texture_ptr', 'SDL_Rect_ptr', 'SDL_FRect_ptr', 'double', 'SDL_FPoint_ptr', 'SDL_RendererFlip' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_RenderReadPixels(SDL_Renderer * renderer,
  #                                                  const SDL_Rect * rect,
  #                                                  Uint32 format,
  #                                                  void *pixels, int pitch);
  $ffi->attach( SDL_RenderReadPixels => [ 'SDL_Renderer_ptr', 'SDL_Rect_ptr', 'uint32', 'opaque', 'int' ] => 'int' );

  # extern DECLSPEC void SDLCALL SDL_RenderPresent(SDL_Renderer * renderer);
  $ffi->attach( SDL_RenderPresent => [ 'SDL_Renderer_ptr' ] => 'void' );

  # extern DECLSPEC void SDLCALL SDL_DestroyTexture(SDL_Texture * texture);
  $ffi->attach( SDL_DestroyTexture => [ 'SDL_Texture_ptr' ] => 'void' );

  # extern DECLSPEC void SDLCALL SDL_DestroyRenderer(SDL_Renderer * renderer);
  $ffi->attach( SDL_DestroyRenderer => [ 'SDL_Renderer_ptr' ] => 'void' );

  # extern DECLSPEC int SDLCALL SDL_RenderFlush(SDL_Renderer * renderer);
  $ffi->attach( SDL_RenderFlush => [ 'SDL_Renderer_ptr' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_GL_BindTexture(SDL_Texture *texture, float *texw, float *texh);
  $ffi->attach( SDL_GL_BindTexture => [ 'SDL_Texture_ptr', 'float*', 'float*' ] => 'int' );

  # extern DECLSPEC int SDLCALL SDL_GL_UnbindTexture(SDL_Texture *texture);
  $ffi->attach( SDL_GL_UnbindTexture => [ 'SDL_Texture_ptr' ] => 'int' );

  # extern DECLSPEC void *SDLCALL SDL_RenderGetMetalLayer(SDL_Renderer * renderer);
  $ffi->attach( SDL_RenderGetMetalLayer => [ 'SDL_Renderer_ptr' ] => 'opaque' );

  # extern DECLSPEC void *SDLCALL SDL_RenderGetMetalCommandEncoder(SDL_Renderer * renderer);
  $ffi->attach( SDL_RenderGetMetalCommandEncoder => [ 'SDL_Renderer_ptr' ] => 'opaque' );

}

1;
