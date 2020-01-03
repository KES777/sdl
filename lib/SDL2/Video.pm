use strict;
use warnings;

package SDL2::Video;

# include "SDL_stdinc.h"
#include "SDL_pixels.h"
#include "SDL_rect.h"
#include "SDL_surface.h"

#include "begin_code.h"

use SDL2::Stdinc;
use SDL2::Pixels;
use SDL2::Rect;
use SDL2::Surface;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;
	$ffi->type( 'opaque' => 'SDL_DisplayMode_ptr' );        #struct
# ??????????
	$ffi->type( 'opaque' => 'SDL_Window_ptr' );
	$ffi->type( 'int'    => 'SDL_DisplayOrientation' );     #enum
	# typedef void *SDL_GLContext;
	$ffi->type( 'opaque' => 'SDL_GLContext_ptr' );
	$ffi->type( 'int' => 'SDL_GLattr_ptr' );                #enum
# ??????????
	$ffi->type( 'opaque' => 'SDL_HitTest_ptr' );

	SDL2::Stdinc::attach( $ffi );
	SDL2::Pixels::attach( $ffi );
	SDL2::Rect::attach( $ffi );
	SDL2::Surface::attach( $ffi );

	# extern DECLSPEC int SDLCALL SDL_GetNumVideoDrivers(void);
	$ffi->attach( SDL_GetNumVideoDrivers => [ 'void'  ] => 'int' );


	# extern DECLSPEC const char *SDLCALL SDL_GetVideoDriver(int index);
	$ffi->attach( SDL_GetVideoDriver => [ 'int'  ] => 'string'  );


	# extern DECLSPEC int SDLCALL SDL_VideoInit(const char *driver_name);
	$ffi->attach( SDL_VideoInit      => [ 'string' ] => 'int'  );


	# extern DECLSPEC void SDLCALL SDL_VideoQuit(void);
	$ffi->attach( SDL_VideoQuit      =>  [ 'void' ] => 'void' );

	# extern DECLSPEC const char *SDLCALL SDL_GetCurrentVideoDriver(void);
	$ffi->attach( SDL_GetCurrentVideoDriver => [ 'void'  ] => 'string' );


	# extern DECLSPEC int SDLCALL SDL_GetNumVideoDisplays(void);
	$ffi->attach( SDL_GetNumVideoDisplays => [ 'void'  ] => 'int' );


	# extern DECLSPEC const char * SDLCALL SDL_GetDisplayName(int displayIndex);
	$ffi->attach( SDL_GetDisplayName => [ 'int'  ] => 'string' );


	# extern DECLSPEC int SDLCALL SDL_GetDisplayBounds(int displayIndex, SDL_Rect * rect);
	$ffi->attach( SDL_GetDisplayBounds   => [ 'int', 'SDL_Rect_ptr' ] => 'int' );


	# extern DECLSPEC int SDLCALL SDL_GetDisplayUsableBounds(int displayIndex, SDL_Rect * rect);
	$ffi->attach( SDL_GetDisplayUsableBounds => [ 'int', 'SDL_Rect_ptr' ] => 'int' );


	# extern DECLSPEC int SDLCALL SDL_GetDisplayDPI(int displayIndex, float * ddpi, float * hdpi, float * vdpi);
	$ffi->attach( SDL_GetDisplayDPI   => [ 'int', 'float', 'float', 'float' ] => 'int' );


	# extern DECLSPEC SDL_DisplayOrientation SDLCALL SDL_GetDisplayOrientation(int displayIndex);
	$ffi->attach( SDL_GetDisplayOrientation => [ 'int' ] => 'SDL_DisplayOrientation' );


	# extern DECLSPEC int SDLCALL SDL_GetNumDisplayModes(int displayIndex);
	$ffi->attach( SDL_GetNumDisplayModes    => [ 'int' ] => 'int' );


	# extern DECLSPEC int SDLCALL SDL_GetDisplayMode(int displayIndex, int modeIndex,
	#                                                SDL_DisplayMode * mode);
	$ffi->attach( SDL_GetDisplayMode    => [ 'int', 'int', 'SDL_DisplayMode_ptr' ] => 'int' );


	# extern DECLSPEC int SDLCALL SDL_GetDesktopDisplayMode(int displayIndex, SDL_DisplayMode * mode);
	$ffi->attach( SDL_GetDesktopDisplayMode    => [ 'int', 'SDL_DisplayMode_ptr' ] => 'int' );


	# extern DECLSPEC int SDLCALL SDL_GetCurrentDisplayMode(int displayIndex, SDL_DisplayMode * mode);
	$ffi->attach( SDL_GetCurrentDisplayMode    => [ 'int', 'SDL_DisplayMode_ptr' ] => 'int' );

# ????????????????SDL_DisplayMode
	# extern DECLSPEC SDL_DisplayMode * SDLCALL SDL_GetClosestDisplayMode(int displayIndex, const SDL_DisplayMode * mode, SDL_DisplayMode * closest);
	$ffi->attach( SDL_GetClosestDisplayMode    => [ 'int', 'SDL_DisplayMode_ptr', 'SDL_DisplayMode_ptr' ] => 'SDL_DisplayMode_ptr' );


	# extern DECLSPEC int SDLCALL SDL_GetWindowDisplayIndex(SDL_Window * window);
	$ffi->attach( SDL_GetWindowDisplayIndex    => [ 'SDL_Window_ptr' ] => 'int' );


	# extern DECLSPEC int SDLCALL SDL_SetWindowDisplayMode(SDL_Window * window,
	#                                                      const SDL_DisplayMode
	#                                                          * mode);
	$ffi->attach( SDL_SetWindowDisplayMode    => [ 'SDL_Window_ptr', 'SDL_DisplayMode_ptr' ] => 'int' );


	# extern DECLSPEC int SDLCALL SDL_GetWindowDisplayMode(SDL_Window * window,
	#                                                      SDL_DisplayMode * mode);
	$ffi->attach( SDL_GetWindowDisplayMode    => [ 'SDL_Window_ptr', 'SDL_DisplayMode_ptr' ] => 'int' );


	# extern DECLSPEC Uint32 SDLCALL SDL_GetWindowPixelFormat(SDL_Window * window);
	$ffi->attach( SDL_GetWindowPixelFormat    => [ 'SDL_Window_ptr' ] => 'uint32' );


	# extern DECLSPEC SDL_Window * SDLCALL SDL_CreateWindow(const char *title,
	#                                                       # int x, int y, int w,
	#                                                       int h, Uint32 flags);
	$ffi->attach( SDL_CreateWindow => [ 'string', 'int', 'int', 'int', 'int', 'uint32' ] => 'SDL_Window_ptr' );


# ?????????????????????const void *data -> opaque
	# extern DECLSPEC SDL_Window * SDLCALL SDL_CreateWindowFrom(const void *data);
	$ffi->attach( SDL_CreateWindowFrom    => [ 'opaque' ] => 'SDL_Window_ptr' );


	# extern DECLSPEC Uint32 SDLCALL SDL_GetWindowID(SDL_Window * window);
	$ffi->attach( SDL_GetWindowID    => [ 'SDL_Window_ptr' ] => 'uint32' );


	# extern DECLSPEC SDL_Window * SDLCALL SDL_GetWindowFromID(Uint32 id);
	$ffi->attach( SDL_GetWindowFromID    => [ 'uint32' ] => 'SDL_Window_ptr' );


	# extern DECLSPEC Uint32 SDLCALL SDL_GetWindowFlags(SDL_Window * window);
	$ffi->attach( SDL_GetWindowFlags    => [ 'SDL_Window_ptr' ] => 'uint32' );


	# extern DECLSPEC void SDLCALL SDL_SetWindowTitle(SDL_Window * window,
	#                                                 const char *title);
	$ffi->attach( SDL_SetWindowTitle => [ 'SDL_Window_ptr', 'string' ] =>  'void' );


	# extern DECLSPEC const char *SDLCALL SDL_GetWindowTitle(SDL_Window * window);
	$ffi->attach( SDL_GetWindowTitle    => [ 'SDL_Window_ptr' ] => 'string' );


	# extern DECLSPEC void SDLCALL SDL_SetWindowIcon(SDL_Window * window,
	#                                                SDL_Surface * icon);
	$ffi->attach( SDL_SetWindowIcon => [ 'SDL_Window_ptr', 'SDL_Surface_ptr' ] =>  'void' );


	# extern DECLSPEC void* SDLCALL SDL_SetWindowData(SDL_Window * window,
	#                                                 const char *name,
	#                                                 void *userdata);
	$ffi->attach( SDL_SetWindowData => [ 'SDL_Window_ptr', 'string', 'opaque' ] =>  'opaque' );


	# extern DECLSPEC void *SDLCALL SDL_GetWindowData(SDL_Window * window,
	#                                                 const char *name);
	$ffi->attach( SDL_GetWindowData => [ 'SDL_Window_ptr', 'string' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_SetWindowPosition(SDL_Window * window,
	#                                                    int x, int y);
	$ffi->attach( SDL_SetWindowPosition => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_GetWindowPosition(SDL_Window * window,
	#                                                    int *x, int *y);
	$ffi->attach( SDL_GetWindowPosition => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_SetWindowSize(SDL_Window * window, int w,
	#                                                int h);
	$ffi->attach( SDL_SetWindowSize => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_GetWindowSize(SDL_Window * window, int *w,
	#                                                int *h);
	$ffi->attach( SDL_GetWindowSize => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );


	# extern DECLSPEC int SDLCALL SDL_GetWindowBordersSize(SDL_Window * window,
	#                                                      int *top, int *left,
	#                                                      int *bottom, int *right);
	$ffi->attach( SDL_GetWindowBordersSize => [ 'SDL_Window_ptr', 'int', 'int', 'int', 'int' ] =>  'int' );


	# extern DECLSPEC void SDLCALL SDL_SetWindowMinimumSize(SDL_Window * window,
	#                                                       int min_w, int min_h);
	$ffi->attach( SDL_SetWindowMinimumSize => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_GetWindowMinimumSize(SDL_Window * window,
	#                                                       int *w, int *h);
	$ffi->attach( SDL_GetWindowMinimumSize => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_SetWindowMaximumSize(SDL_Window * window,
	#                                                       int max_w, int max_h);
	$ffi->attach( SDL_SetWindowMaximumSize => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_GetWindowMaximumSize(SDL_Window * window,
	#                                                       int *w, int *h);
	$ffi->attach( SDL_GetWindowMaximumSize => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );

# ????????????????????????SDL_bool bordered
	# extern DECLSPEC void SDLCALL SDL_SetWindowBordered(SDL_Window * window,
	#                                                    SDL_bool bordered);
	$ffi->attach( SDL_SetWindowBordered => [ 'SDL_Window_ptr', 'SDL_bool' ] =>  'void' );

# ????????????????????????SDL_bool resizable
	# extern DECLSPEC void SDLCALL SDL_SetWindowResizable(SDL_Window * window,
	#                                                     SDL_bool resizable);
	$ffi->attach( SDL_SetWindowResizable => [ 'SDL_Window_ptr', 'SDL_bool' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_ShowWindow(SDL_Window * window);
	$ffi->attach( SDL_ShowWindow => [ 'SDL_Window_ptr' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_HideWindow(SDL_Window * window);
	$ffi->attach( SDL_HideWindow => [ 'SDL_Window_ptr' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_RaiseWindow(SDL_Window * window);
	$ffi->attach( SDL_RaiseWindow => [ 'SDL_Window_ptr' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_MaximizeWindow(SDL_Window * window);
	$ffi->attach( SDL_MaximizeWindow => [ 'SDL_Window_ptr' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_MinimizeWindow(SDL_Window * window);
	$ffi->attach( SDL_MinimizeWindow => [ 'SDL_Window_ptr' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_RestoreWindow(SDL_Window * window);
	$ffi->attach( SDL_RestoreWindow => [ 'SDL_Window_ptr' ] =>  'void' );


	# extern DECLSPEC int SDLCALL SDL_SetWindowFullscreen(SDL_Window * window,
	#                                                     Uint32 flags);
	$ffi->attach( SDL_SetWindowFullscreen => [ 'SDL_Window_ptr', 'uint32' ] =>  'int' );


	# extern DECLSPEC SDL_Surface * SDLCALL SDL_GetWindowSurface(SDL_Window * window);
	$ffi->attach( SDL_GetWindowSurface => [ 'SDL_Window_ptr' ] =>  'SDL_Surface_ptr' );


	# extern DECLSPEC int SDLCALL SDL_UpdateWindowSurface(SDL_Window * window);
	$ffi->attach( SDL_UpdateWindowSurface => [ 'SDL_Window_ptr' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_UpdateWindowSurfaceRects(SDL_Window * window,
	#                                                          const SDL_Rect * rects,
	#                                                          int numrects);
	$ffi->attach( SDL_UpdateWindowSurfaceRects => [ 'SDL_Window_ptr', 'SDL_Rect_ptr', 'int' ] =>  'int' );


# ????????????????????????SDL_bool grabbed
	# extern DECLSPEC void SDLCALL SDL_SetWindowGrab(SDL_Window * window,
	#                                                SDL_bool grabbed);
	$ffi->attach( SDL_SetWindowGrab => [ 'SDL_Window_ptr', 'SDL_bool' ] =>  'void' );


	# extern DECLSPEC SDL_bool SDLCALL SDL_GetWindowGrab(SDL_Window * window);
	$ffi->attach( SDL_GetWindowGrab => [ 'SDL_Window_ptr' ] =>  'SDL_bool' );


	# extern DECLSPEC SDL_Window * SDLCALL SDL_GetGrabbedWindow(void);
	$ffi->attach( SDL_GetGrabbedWindow => [ 'void' ] =>  'SDL_Window_ptr' );


	# extern DECLSPEC int SDLCALL SDL_SetWindowBrightness(SDL_Window * window, float brightness);
	$ffi->attach( SDL_SetWindowBrightness => [ 'SDL_Window_ptr', 'float' ] =>  'int' );


	# extern DECLSPEC float SDLCALL SDL_GetWindowBrightness(SDL_Window * window);
	$ffi->attach( SDL_GetWindowBrightness => [ 'SDL_Window_ptr' ] =>  'float' );


	# extern DECLSPEC int SDLCALL SDL_SetWindowOpacity(SDL_Window * window, float opacity);
	$ffi->attach( SDL_SetWindowOpacity => [ 'SDL_Window_ptr', 'float' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_GetWindowOpacity(SDL_Window * window, float * out_opacity);
	$ffi->attach( SDL_GetWindowOpacity => [ 'SDL_Window_ptr', 'float' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_SetWindowModalFor(SDL_Window * modal_window, SDL_Window * parent_window);
	$ffi->attach( SDL_SetWindowModalFor => [ 'SDL_Window_ptr', 'SDL_Window_ptr' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_SetWindowInputFocus(SDL_Window * window);
	$ffi->attach( SDL_SetWindowInputFocus => [ 'SDL_Window_ptr' ] =>  'int' );


# ????????????????????const Uint16
	# extern DECLSPEC int SDLCALL SDL_SetWindowGammaRamp(SDL_Window * window,
	#                                                    const Uint16 * red,
	#                                                    const Uint16 * green,
	#                                                    const Uint16 * blue);
	$ffi->attach( SDL_SetWindowGammaRamp => [ 'SDL_Window_ptr', 'uint16*', 'uint16*', 'uint16*' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_GetWindowGammaRamp(SDL_Window * window,
	#                                                    Uint16 * red,
	#                                                    Uint16 * green,
	#                                                    Uint16 * blue);
	$ffi->attach( SDL_GetWindowGammaRamp => [ 'SDL_Window_ptr', 'uint16*', 'uint16*', 'uint16*' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_SetWindowHitTest(SDL_Window * window,
	#                                                  SDL_HitTest callback,
	#                                                  void *callback_data);
	$ffi->attach( SDL_SetWindowHitTest => [ 'SDL_Window_ptr', 'SDL_HitTest_ptr', 'opaque' ] =>  'int' );


	# extern DECLSPEC void SDLCALL SDL_DestroyWindow(SDL_Window * window);
	$ffi->attach( SDL_DestroyWindow => [ 'SDL_Window_ptr' ] =>  'void' );


	# extern DECLSPEC SDL_bool SDLCALL SDL_IsScreenSaverEnabled(void);
	$ffi->attach( SDL_IsScreenSaverEnabled => [ 'void' ] =>  'SDL_bool' );


	# extern DECLSPEC void SDLCALL SDL_EnableScreenSaver(void);
	$ffi->attach( SDL_EnableScreenSaver => [ 'void' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_DisableScreenSaver(void);
	$ffi->attach( SDL_DisableScreenSaver => [ 'void' ] =>  'void' );


	# extern DECLSPEC int SDLCALL SDL_GL_LoadLibrary(const char *path);
	$ffi->attach( SDL_GL_LoadLibrary => [ 'string' ] =>  'int' );


	# extern DECLSPEC void *SDLCALL SDL_GL_GetProcAddress(const char *proc);
	$ffi->attach( SDL_GL_GetProcAddress => [ 'string' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_GL_UnloadLibrary(void);
	$ffi->attach( SDL_GL_UnloadLibrary => [ 'void' ] =>  'void' );


	# extern DECLSPEC SDL_bool SDLCALL SDL_GL_ExtensionSupported(const char
	#                                                            *extension);
	$ffi->attach( SDL_GL_ExtensionSupported => [ 'string' ] =>  'SDL_bool' );


	# extern DECLSPEC void SDLCALL SDL_GL_ResetAttributes(void);
	$ffi->attach( SDL_GL_ResetAttributes => [ 'void' ] =>  'void' );


	# extern DECLSPEC int SDLCALL SDL_GL_SetAttribute(SDL_GLattr attr, int value);
	$ffi->attach( SDL_GL_SetAttribute => [ 'SDL_GLattr_ptr', 'int' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_GL_GetAttribute(SDL_GLattr attr, int *value);
	$ffi->attach( SDL_GL_GetAttribute => [ 'SDL_GLattr_ptr', 'int' ] =>  'int' );


	# extern DECLSPEC SDL_GLContext SDLCALL SDL_GL_CreateContext(SDL_Window *
	#                                                            window);
	$ffi->attach( SDL_GL_CreateContext => [ 'SDL_Window_ptr' ] =>  'SDL_GLContext_ptr' );


	# extern DECLSPEC int SDLCALL SDL_GL_MakeCurrent(SDL_Window * window,
	#                                                SDL_GLContext context);
	$ffi->attach( SDL_GL_MakeCurrent => [ 'SDL_Window_ptr', 'SDL_GLContext_ptr' ] =>  'int' );


	# extern DECLSPEC SDL_Window* SDLCALL SDL_GL_GetCurrentWindow(void);
	$ffi->attach( SDL_GL_GetCurrentWindow => [ 'void' ] =>  'SDL_Window_ptr' );


	# extern DECLSPEC SDL_GLContext SDLCALL SDL_GL_GetCurrentContext(void);
	$ffi->attach( SDL_GL_GetCurrentContext => [ 'void' ] =>  'SDL_GLContext_ptr' );


	# extern DECLSPEC void SDLCALL SDL_GL_GetDrawableSize(SDL_Window * window, int *w,
	#                                                     int *h);
	$ffi->attach( SDL_GL_GetDrawableSize => [ 'SDL_Window_ptr', 'int', 'int' ] =>  'void' );


	# extern DECLSPEC int SDLCALL SDL_GL_SetSwapInterval(int interval);
	$ffi->attach( SDL_GL_SetSwapInterval => [ 'int' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_GL_GetSwapInterval(void);
	$ffi->attach( SDL_GL_GetSwapInterval => [ 'void' ] =>  'int' );


	# extern DECLSPEC void SDLCALL SDL_GL_SwapWindow(SDL_Window * window);
	$ffi->attach( SDL_GL_SwapWindow => [ 'SDL_Window_ptr' ] =>  'void' );


	# extern DECLSPEC void SDLCALL SDL_GL_DeleteContext(SDL_GLContext context);
	$ffi->attach( SDL_GL_DeleteContext => [ 'SDL_GLContext_ptr' ] =>  'void' );

}

1;
