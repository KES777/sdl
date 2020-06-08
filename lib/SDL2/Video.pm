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
	$ffi->type( 'opaque' => 'SDL_Window_ptr' );             #struct

	# typedef enum
	# {
	#     /* !!! FIXME: change this to name = (1<<x). */
	#     SDL_WINDOW_FULLSCREEN = 0x00000001,         /**< fullscreen window */
	#     SDL_WINDOW_OPENGL = 0x00000002,             /**< window usable with OpenGL context */
	#     SDL_WINDOW_SHOWN = 0x00000004,              /**< window is visible */
	#     SDL_WINDOW_HIDDEN = 0x00000008,             /**< window is not visible */
	#     SDL_WINDOW_BORDERLESS = 0x00000010,         /**< no window decoration */
	#     SDL_WINDOW_RESIZABLE = 0x00000020,          /**< window can be resized */
	#     SDL_WINDOW_MINIMIZED = 0x00000040,          /**< window is minimized */
	#     SDL_WINDOW_MAXIMIZED = 0x00000080,          /**< window is maximized */
	#     SDL_WINDOW_INPUT_GRABBED = 0x00000100,      /**< window has grabbed input focus */
	#     SDL_WINDOW_INPUT_FOCUS = 0x00000200,        /**< window has input focus */
	#     SDL_WINDOW_MOUSE_FOCUS = 0x00000400,        /**< window has mouse focus */
	#     SDL_WINDOW_FULLSCREEN_DESKTOP = ( SDL_WINDOW_FULLSCREEN | 0x00001000 ),
	#     SDL_WINDOW_FOREIGN = 0x00000800,            /**< window not created by SDL */
	#     SDL_WINDOW_ALLOW_HIGHDPI = 0x00002000,      /**< window should be created in high-DPI mode if supported.
	#                                                      On macOS NSHighResolutionCapable must be set true in the
	#                                                      application's Info.plist for this to have any effect. */
	#     SDL_WINDOW_MOUSE_CAPTURE = 0x00004000,      /**< window has mouse captured (unrelated to INPUT_GRABBED) */
	#     SDL_WINDOW_ALWAYS_ON_TOP = 0x00008000,      /**< window should always be above others */
	#     SDL_WINDOW_SKIP_TASKBAR  = 0x00010000,      /**< window should not be added to the taskbar */
	#     SDL_WINDOW_UTILITY       = 0x00020000,      /**< window should be treated as a utility window */
	#     SDL_WINDOW_TOOLTIP       = 0x00040000,      /**< window should be treated as a tooltip */
	#     SDL_WINDOW_POPUP_MENU    = 0x00080000,      /**< window should be treated as a popup menu */
	#     SDL_WINDOW_VULKAN        = 0x10000000       /**< window usable for Vulkan surface */
	# } SDL_WindowFlags;
	$ffi->load_custom_type('::Enum', 'SDL_WindowFlags',
	    ['SDL_WINDOW_FULLSCREEN'         => 0x00000001], # /**< fullscreen window */
	    ['SDL_WINDOW_OPENGL'             => 0x00000002], # /**< window usable with OpenGL context */
	    ['SDL_WINDOW_SHOWN'              => 0x00000004], # /**< window is visible */
	    ['SDL_WINDOW_HIDDEN'             => 0x00000008], # /**< window is not visible */
	    ['SDL_WINDOW_BORDERLESS'         => 0x00000010], # /**< no window decoration */
	    ['SDL_WINDOW_RESIZABLE'          => 0x00000020], # /**< window can be resized */
	    ['SDL_WINDOW_MINIMIZED'          => 0x00000040], # /**< window is minimized */
	    ['SDL_WINDOW_MAXIMIZED'          => 0x00000080], # /**< window is maximized */
	    ['SDL_WINDOW_INPUT_GRABBED'      => 0x00000100], # /**< window has grabbed input focus */
	    ['SDL_WINDOW_INPUT_FOCUS'        => 0x00000200], # /**< window has input focus */
	    ['SDL_WINDOW_MOUSE_FOCUS'        => 0x00000400], # /**< window has mouse focus */
	    #FIX: ['SDL_WINDOW_FULLSCREEN_DESKTOP' => ( 'SDL_WINDOW_FULLSCREEN' | 0x00001000 )],
	    ['SDL_WINDOW_FULLSCREEN_DESKTOP' => ( 0x00000001 | 0x00001000 )],
	    ['SDL_WINDOW_FOREIGN'            => 0x00000800], # /**< window not created by SDL */
	    ['SDL_WINDOW_ALLOW_HIGHDPI'      => 0x00002000], # /**< window should be created in high-DPI mode if supported.
	                                                     #    On macOS NSHighResolutionCapable must be set true in the
	                                                     #    application's Info.plist for this to have any effect. */
	    ['SDL_WINDOW_MOUSE_CAPTURE'      => 0x00004000], # /**< window has mouse captured (unrelated to INPUT_GRABBED) */
	    ['SDL_WINDOW_ALWAYS_ON_TOP'      => 0x00008000], # /**< window should always be above others */
	    ['SDL_WINDOW_SKIP_TASKBAR'       => 0x00010000], # /**< window should not be added to the taskbar */
	    ['SDL_WINDOW_UTILITY'            => 0x00020000], # /**< window should be treated as a utility window */
	    ['SDL_WINDOW_TOOLTIP'            => 0x00040000], # /**< window should be treated as a tooltip */
	    ['SDL_WINDOW_POPUP_MENU'         => 0x00080000], # /**< window should be treated as a popup menu */
	    ['SDL_WINDOW_VULKAN'             => 0x10000000], # /**< window usable for Vulkan surface */
	);


	# typedef enum
	# {
	#     SDL_WINDOWEVENT_NONE,           /**< Never used */
	#     SDL_WINDOWEVENT_SHOWN,          /**< Window has been shown */
	#     SDL_WINDOWEVENT_HIDDEN,         /**< Window has been hidden */
	#     SDL_WINDOWEVENT_EXPOSED,        /**< Window has been exposed and should be
	#                                          redrawn */
	#     SDL_WINDOWEVENT_MOVED,          /**< Window has been moved to data1, data2
	#                                      */
	#     SDL_WINDOWEVENT_RESIZED,        /**< Window has been resized to data1xdata2 */
	#     SDL_WINDOWEVENT_SIZE_CHANGED,   /**< The window size has changed, either as
	#                                          a result of an API call or through the
	#                                          system or user changing the window size. */
	#     SDL_WINDOWEVENT_MINIMIZED,      /**< Window has been minimized */
	#     SDL_WINDOWEVENT_MAXIMIZED,      /**< Window has been maximized */
	#     SDL_WINDOWEVENT_RESTORED,       /**< Window has been restored to normal size
	#                                          and position */
	#     SDL_WINDOWEVENT_ENTER,          /**< Window has gained mouse focus */
	#     SDL_WINDOWEVENT_LEAVE,          /**< Window has lost mouse focus */
	#     SDL_WINDOWEVENT_FOCUS_GAINED,   /**< Window has gained keyboard focus */
	#     SDL_WINDOWEVENT_FOCUS_LOST,     /**< Window has lost keyboard focus */
	#     SDL_WINDOWEVENT_CLOSE,          /**< The window manager requests that the window be closed */
	#     SDL_WINDOWEVENT_TAKE_FOCUS,     /**< Window is being offered a focus (should SetWindowInputFocus() on itself or a subwindow, or ignore) */
	#     SDL_WINDOWEVENT_HIT_TEST        /**< Window had a hit test that wasn't SDL_HITTEST_NORMAL. */
	# } SDL_WindowEventID;
	$ffi->load_custom_type('::Enum', 'SDL_WindowEventID',
		'SDL_WINDOWEVENT_NONE',         # /**< Never used */
		'SDL_WINDOWEVENT_SHOWN',        # /**< Window has been shown */
		'SDL_WINDOWEVENT_HIDDEN',       # /**< Window has been hidden */
		'SDL_WINDOWEVENT_EXPOSED',      # /**< Window has been exposed and should be
										#    redrawn */
		'SDL_WINDOWEVENT_MOVED',        # /**< Window has been moved to data1, data2
										# */
		'SDL_WINDOWEVENT_RESIZED',      # /**< Window has been resized to data1xdata2 */
		'SDL_WINDOWEVENT_SIZE_CHANGED', # /**< The window size has changed, either as
										#    a result of an API call or through the
										#    system or user changing the window size. */
		'SDL_WINDOWEVENT_MINIMIZED',    # /**< Window has been minimized */
		'SDL_WINDOWEVENT_MAXIMIZED',    # /**< Window has been maximized */
		'SDL_WINDOWEVENT_RESTORED',     # /**< Window has been restored to normal size
										#     and position */
		'SDL_WINDOWEVENT_ENTER',        # /**< Window has gained mouse focus */
		'SDL_WINDOWEVENT_LEAVE',        # /**< Window has lost mouse focus */
		'SDL_WINDOWEVENT_FOCUS_GAINED', # /**< Window has gained keyboard focus */
		'SDL_WINDOWEVENT_FOCUS_LOST',   # /**< Window has lost keyboard focus */
		'SDL_WINDOWEVENT_CLOSE',        # /**< The window manager requests that the window be closed */
		'SDL_WINDOWEVENT_TAKE_FOCUS',   # /**< Window is being offered a focus (should SetWindowInputFocus() on itself or a subwindow, or ignore) */
		'SDL_WINDOWEVENT_HIT_TEST',     # /**< Window had a hit test that wasn't SDL_HITTEST_NORMAL. */
	);


	# typedef enum
	# {
	#     SDL_DISPLAYEVENT_NONE,          /**< Never used */
	#     SDL_DISPLAYEVENT_ORIENTATION    /**< Display orientation has changed to data1 */
	# } SDL_DisplayEventID;
	$ffi->load_custom_type('::Enum', 'SDL_DisplayEventID',
	    'SDL_DISPLAYEVENT_NONE',          # /**< Never used */
	    'SDL_DISPLAYEVENT_ORIENTATION',   # /**< Display orientation has changed to data1 */
	);


	# 	typedef enum
	# {
	#     SDL_ORIENTATION_UNKNOWN,            /**< The display orientation can't be determined */
	#     SDL_ORIENTATION_LANDSCAPE,          /**< The display is in landscape mode, with the right side up, relative to portrait mode */
	#     SDL_ORIENTATION_LANDSCAPE_FLIPPED,  /**< The display is in landscape mode, with the left side up, relative to portrait mode */
	#     SDL_ORIENTATION_PORTRAIT,           /**< The display is in portrait mode */
	#     SDL_ORIENTATION_PORTRAIT_FLIPPED    /**< The display is in portrait mode, upside down */
	# } SDL_DisplayOrientation;
	$ffi->load_custom_type('::Enum', 'SDL_DisplayOrientation',
		'SDL_ORIENTATION_UNKNOWN',            # /**< The display orientation can't be determined */
		'SDL_ORIENTATION_LANDSCAPE',          # /**< The display is in landscape mode, with the right side up, relative to portrait mode */
		'SDL_ORIENTATION_LANDSCAPE_FLIPPED',  # /**< The display is in landscape mode, with the left side up, relative to portrait mode */
		'SDL_ORIENTATION_PORTRAIT',           # /**< The display is in portrait mode */
		'SDL_ORIENTATION_PORTRAIT_FLIPPED',   # /**< The display is in portrait mode, upside down */
	);


# ???????typedef void *SDL_GLContext;
	$ffi->type( 'opaque' => 'SDL_GLContext_ptr' );


	# typedef enum
	# {
	#     SDL_GL_RED_SIZE,
	#     SDL_GL_GREEN_SIZE,
	#     SDL_GL_BLUE_SIZE,
	#     SDL_GL_ALPHA_SIZE,
	#     SDL_GL_BUFFER_SIZE,
	#     SDL_GL_DOUBLEBUFFER,
	#     SDL_GL_DEPTH_SIZE,
	#     SDL_GL_STENCIL_SIZE,
	#     SDL_GL_ACCUM_RED_SIZE,
	#     SDL_GL_ACCUM_GREEN_SIZE,
	#     SDL_GL_ACCUM_BLUE_SIZE,
	#     SDL_GL_ACCUM_ALPHA_SIZE,
	#     SDL_GL_STEREO,
	#     SDL_GL_MULTISAMPLEBUFFERS,
	#     SDL_GL_MULTISAMPLESAMPLES,
	#     SDL_GL_ACCELERATED_VISUAL,
	#     SDL_GL_RETAINED_BACKING,
	#     SDL_GL_CONTEXT_MAJOR_VERSION,
	#     SDL_GL_CONTEXT_MINOR_VERSION,
	#     SDL_GL_CONTEXT_EGL,
	#     SDL_GL_CONTEXT_FLAGS,
	#     SDL_GL_CONTEXT_PROFILE_MASK,
	#     SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
	#     SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
	#     SDL_GL_CONTEXT_RELEASE_BEHAVIOR,
	#     SDL_GL_CONTEXT_RESET_NOTIFICATION,
	#     SDL_GL_CONTEXT_NO_ERROR
	# } SDL_GLattr;
	$ffi->load_custom_type('::Enum', 'SDL_GLattr',
		'SDL_GL_RED_SIZE',
		'SDL_GL_GREEN_SIZE',
		'SDL_GL_BLUE_SIZE',
		'SDL_GL_ALPHA_SIZE',
		'SDL_GL_BUFFER_SIZE',
		'SDL_GL_DOUBLEBUFFER',
		'SDL_GL_DEPTH_SIZE',
		'SDL_GL_STENCIL_SIZE',
		'SDL_GL_ACCUM_RED_SIZE',
		'SDL_GL_ACCUM_GREEN_SIZE',
		'SDL_GL_ACCUM_BLUE_SIZE',
		'SDL_GL_ACCUM_ALPHA_SIZE',
		'SDL_GL_STEREO',
		'SDL_GL_MULTISAMPLEBUFFERS',
		'SDL_GL_MULTISAMPLESAMPLES',
		'SDL_GL_ACCELERATED_VISUAL',
		'SDL_GL_RETAINED_BACKING',
		'SDL_GL_CONTEXT_MAJOR_VERSION',
		'SDL_GL_CONTEXT_MINOR_VERSION',
		'DL_GL_CONTEXT_EGL',
		'SDL_GL_CONTEXT_FLAGS',
		'SDL_GL_CONTEXT_PROFILE_MASK',
		'SDL_GL_SHARE_WITH_CURRENT_CONTEXT',
		'SDL_GL_FRAMEBUFFER_SRGB_CAPABLE',
		'SDL_GL_CONTEXT_RELEASE_BEHAVIOR',
		'SDL_GL_CONTEXT_RESET_NOTIFICATION',
		'SDL_GL_CONTEXT_NO_ERROR',
	);


	# typedef enum
	# {
	#     SDL_GL_CONTEXT_PROFILE_CORE           = 0x0001,
	#     SDL_GL_CONTEXT_PROFILE_COMPATIBILITY  = 0x0002,
	#     SDL_GL_CONTEXT_PROFILE_ES             = 0x0004 /**< GLX_CONTEXT_ES2_PROFILE_BIT_EXT */
	# } SDL_GLprofile;
	$ffi->load_custom_type('::Enum', 'SDL_GLprofile',
		['SDL_GL_CONTEXT_PROFILE_CORE'           => 0x0001],
		['SDL_GL_CONTEXT_PROFILE_COMPATIBILITY'  => 0x0002],
		['SDL_GL_CONTEXT_PROFILE_ES'             => 0x0004], #  /**< GLX_CONTEXT_ES2_PROFILE_BIT_EXT */
	);


	# typedef enum
	# {
	#     SDL_GL_CONTEXT_DEBUG_FLAG              = 0x0001,
	#     SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x0002,
	#     SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG      = 0x0004,
	#     SDL_GL_CONTEXT_RESET_ISOLATION_FLAG    = 0x0008
	# } SDL_GLcontextFlag;
	$ffi->load_custom_type('::Enum', 'SDL_GLcontextFlag',
		['SDL_GL_CONTEXT_DEBUG_FLAG'              => 0x0001],
		['SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG' => 0x0002],
		['SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG'      => 0x0004],
		['SDL_GL_CONTEXT_RESET_ISOLATION_FLAG'    => 0x0008],
	);


	# typedef enum
	# {
	#     SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE   = 0x0000,
	#     SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH  = 0x0001
	# } SDL_GLcontextReleaseFlag;
	$ffi->load_custom_type('::Enum', 'SDL_GLcontextReleaseFlag',
		['SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE'   => 0x0000],
		['SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH'  => 0x0001],
	);


	# typedef enum
	# {
	#     SDL_GL_CONTEXT_RESET_NO_NOTIFICATION = 0x0000,
	#     SDL_GL_CONTEXT_RESET_LOSE_CONTEXT    = 0x0001
	# } SDL_GLContextResetNotification;
	$ffi->load_custom_type('::Enum', 'SDL_GLContextResetNotification',
		['SDL_GL_CONTEXT_RESET_NO_NOTIFICATION'   => 0x0000],
		['SDL_GL_CONTEXT_RESET_LOSE_CONTEXT'      => 0x0001],
	);


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


	# typedef enum
	# {
	#     SDL_HITTEST_NORMAL,  /**< Region is normal. No special properties. */
	#     SDL_HITTEST_DRAGGABLE,  /**< Region can drag entire window. */
	#     SDL_HITTEST_RESIZE_TOPLEFT,
	#     SDL_HITTEST_RESIZE_TOP,
	#     SDL_HITTEST_RESIZE_TOPRIGHT,
	#     SDL_HITTEST_RESIZE_RIGHT,
	#     SDL_HITTEST_RESIZE_BOTTOMRIGHT,
	#     SDL_HITTEST_RESIZE_BOTTOM,
	#     SDL_HITTEST_RESIZE_BOTTOMLEFT,
	#     SDL_HITTEST_RESIZE_LEFT
	# } SDL_HitTestResult;
	$ffi->load_custom_type('::Enum', 'SDL_HitTestResult',
		'SDL_HITTEST_NORMAL',            # /**< Region is normal. No special properties. */
		'SDL_HITTEST_DRAGGABLE',         # /**< Region can drag entire window. */
		'SDL_HITTEST_RESIZE_TOPLEFT',
		'SDL_HITTEST_RESIZE_TOP',
		'SDL_HITTEST_RESIZE_TOPRIGHT',
		'SDL_HITTEST_RESIZE_RIGHT',
		'SDL_HITTEST_RESIZE_BOTTOMRIGHT',
		'SDL_HITTEST_RESIZE_BOTTOM',
		'SDL_HITTEST_RESIZE_BOTTOMLEFT',
		'SDL_HITTEST_RESIZE_LEFT',
	);


# ???????????????????
	# typedef SDL_HitTestResult (SDLCALL *SDL_HitTest)(SDL_Window *win,
	#                                                 const SDL_Point *area,
	#                                                 void *data);


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
	$ffi->attach( SDL_GL_SetAttribute => [ 'SDL_GLattr', 'int' ] =>  'int' );


	# extern DECLSPEC int SDLCALL SDL_GL_GetAttribute(SDL_GLattr attr, int *value);
	$ffi->attach( SDL_GL_GetAttribute => [ 'SDL_GLattr', 'int' ] =>  'int' );


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
