package SDL2::Events;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_error.h"
#include "SDL_video.h"
#include "SDL_keyboard.h"
#include "SDL_mouse.h"
#include "SDL_joystick.h"
#include "SDL_gamecontroller.h"
#include "SDL_quit.h"
#include "SDL_gesture.h"
#include "SDL_touch.h"

use SDL2::Stdinc;
use SDL2::Error;
use SDL2::Video;
use SDL2::Keyboard;
use SDL2::Mouse;
use SDL2::Joystick;
use SDL2::Gamecontroller;
use SDL2::Quit;
use SDL2::Gesture;
use SDL2::Touch;



my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	#define SDL_RELEASED    0
	#define SDL_PRESSED 1
	use constant SDL_RELEASED  => 0;
	use constant SDL_PRESSED   => 1;

	# typedef enum
	# {
	#     SDL_FIRSTEVENT     = 0,     /**< Unused (do not remove) */

	#     /* Application events */
	#     SDL_QUIT           = 0x100, /**< User-requested quit */

	#     /* These application events have special meaning on iOS, see README-ios.md for details */
	#     SDL_APP_TERMINATING,        /**< The application is being terminated by the OS
	#                                      Called on iOS in applicationWillTerminate()
	#                                      Called on Android in onDestroy()
	#                                 */
	#     SDL_APP_LOWMEMORY,          /**< The application is low on memory, free memory if possible.
	#                                      Called on iOS in applicationDidReceiveMemoryWarning()
	#                                      Called on Android in onLowMemory()
	#                                 */
	#     SDL_APP_WILLENTERBACKGROUND, /**< The application is about to enter the background
	#                                      Called on iOS in applicationWillResignActive()
	#                                      Called on Android in onPause()
	#                                 */
	#     SDL_APP_DIDENTERBACKGROUND, /**< The application did enter the background and may not get CPU for some time
	#                                      Called on iOS in applicationDidEnterBackground()
	#                                      Called on Android in onPause()
	#                                 */
	#     SDL_APP_WILLENTERFOREGROUND, /**< The application is about to enter the foreground
	#                                      Called on iOS in applicationWillEnterForeground()
	#                                      Called on Android in onResume()
	#                                 */
	#     SDL_APP_DIDENTERFOREGROUND, /**< The application is now interactive
	#                                      Called on iOS in applicationDidBecomeActive()
	#                                      Called on Android in onResume()
	#                                 */

	#     /* Display events */
	#     SDL_DISPLAYEVENT   = 0x150,  /**< Display state change */

	#     /* Window events */
	#     SDL_WINDOWEVENT    = 0x200, /**< Window state change */
	#     SDL_SYSWMEVENT,             /**< System specific event */

	#     /* Keyboard events */
	#     SDL_KEYDOWN        = 0x300, /**< Key pressed */
	#     SDL_KEYUP,                  /**< Key released */
	#     SDL_TEXTEDITING,            /**< Keyboard text editing (composition) */
	#     SDL_TEXTINPUT,              /**< Keyboard text input */
	#     SDL_KEYMAPCHANGED,          /**< Keymap changed due to a system event such as an
	#                                      input language or keyboard layout change.
	#                                 */

	#     /* Mouse events */
	#     SDL_MOUSEMOTION    = 0x400, /**< Mouse moved */
	#     SDL_MOUSEBUTTONDOWN,        /**< Mouse button pressed */
	#     SDL_MOUSEBUTTONUP,          /**< Mouse button released */
	#     SDL_MOUSEWHEEL,             /**< Mouse wheel motion */

	#     /* Joystick events */
	#     SDL_JOYAXISMOTION  = 0x600, /**< Joystick axis motion */
	#     SDL_JOYBALLMOTION,          /**< Joystick trackball motion */
	#     SDL_JOYHATMOTION,           /**< Joystick hat position change */
	#     SDL_JOYBUTTONDOWN,          /**< Joystick button pressed */
	#     SDL_JOYBUTTONUP,            /**< Joystick button released */
	#     SDL_JOYDEVICEADDED,         /**< A new joystick has been inserted into the system */
	#     SDL_JOYDEVICEREMOVED,       /**< An opened joystick has been removed */

	#     /* Game controller events */
	#     SDL_CONTROLLERAXISMOTION  = 0x650, /**< Game controller axis motion */
	#     SDL_CONTROLLERBUTTONDOWN,          /**< Game controller button pressed */
	#     SDL_CONTROLLERBUTTONUP,            /**< Game controller button released */
	#     SDL_CONTROLLERDEVICEADDED,         /**< A new Game controller has been inserted into the system */
	#     SDL_CONTROLLERDEVICEREMOVED,       /**< An opened Game controller has been removed */
	#     SDL_CONTROLLERDEVICEREMAPPED,      /**< The controller mapping was updated */

	#     /* Touch events */
	#     SDL_FINGERDOWN      = 0x700,
	#     SDL_FINGERUP,
	#     SDL_FINGERMOTION,

	#     /* Gesture events */
	#     SDL_DOLLARGESTURE   = 0x800,
	#     SDL_DOLLARRECORD,
	#     SDL_MULTIGESTURE,

	#     /* Clipboard events */
	#     SDL_CLIPBOARDUPDATE = 0x900, /**< The clipboard changed */

	#     /* Drag and drop events */
	#     SDL_DROPFILE        = 0x1000, /**< The system requests a file open */
	#     SDL_DROPTEXT,                 /**< text/plain drag-and-drop event */
	#     SDL_DROPBEGIN,                /**< A new set of drops is beginning (NULL filename) */
	#     SDL_DROPCOMPLETE,             /**< Current set of drops is now complete (NULL filename) */

	#     /* Audio hotplug events */
	#     SDL_AUDIODEVICEADDED = 0x1100, /**< A new audio device is available */
	#     SDL_AUDIODEVICEREMOVED,        /**< An audio device has been removed. */

	#     /* Sensor events */
	#     SDL_SENSORUPDATE = 0x1200,     /**< A sensor was updated */

	#     /* Render events */
	#     SDL_RENDER_TARGETS_RESET = 0x2000, /**< The render targets have been reset and their contents need to be updated */
	#     SDL_RENDER_DEVICE_RESET, /**< The device has been reset and all textures need to be recreated */

	#     /** Events ::SDL_USEREVENT through ::SDL_LASTEVENT are for your use,
	#      *  and should be allocated with SDL_RegisterEvents()
	#      */
	#     SDL_USEREVENT    = 0x8000,

	#     /**
	#      *  This last event is only for bounding internal arrays
	#      */
	#     SDL_LASTEVENT    = 0xFFFF
	# } SDL_EventType;
	$ffi->load_custom_type('::Enum', 'SDL_EventType',
		{ ret => 'int', package => 'SDL2::Events' },
	    ['SDL_FIRSTEVENT'     => 0],

		# /* Application events */
	    ['SDL_QUIT'           => 0x100],
	    'SDL_APP_TERMINATING',
	    'SDL_APP_LOWMEMORY',
	    'SDL_APP_WILLENTERBACKGROUND',
	    'SDL_APP_DIDENTERBACKGROUND',
	    'SDL_APP_WILLENTERFOREGROUND',
	    'SDL_APP_DIDENTERFOREGROUND',
	    # /* Display events */

	    ['SDL_DISPLAYEVENT'   => 0x150],
	    # /* Window events */

	    ['SDL_WINDOWEVENT'    => 0x200],
	    'SDL_SYSWMEVENT',
	    # /* Keyboard events */

	    ['SDL_KEYDOWN'        => 0x300],
	    'SDL_KEYUP',
	    'SDL_TEXTEDITING',
	    'SDL_TEXTINPUT',
	    'SDL_KEYMAPCHANGED',

	    # /* Mouse events */
	    ['SDL_MOUSEMOTION'    => 0x400],
	    'SDL_MOUSEBUTTONDOWN',
	    'SDL_MOUSEBUTTONUP',
	    'SDL_MOUSEWHEEL',

	    # /* Joystick events */
	    ['SDL_JOYAXISMOTION'  => 0x600],
	    'SDL_JOYBALLMOTION',
	    'SDL_JOYHATMOTION',
	    'SDL_JOYBUTTONDOWN',
	    'SDL_JOYBUTTONUP',
	    'SDL_JOYDEVICEADDED',
	    'SDL_JOYDEVICEREMOVED',

	    # /* Game controller events */
	    ['SDL_CONTROLLERAXISMOTION'  => 0x650],
	    'SDL_CONTROLLERBUTTONDOWN',
	    'SDL_CONTROLLERBUTTONUP',
	    'SDL_CONTROLLERDEVICEADDED',
	    'SDL_CONTROLLERDEVICEREMOVED',
	    'SDL_CONTROLLERDEVICEREMAPPED',

	    # /* Touch events */
	    ['SDL_FINGERDOWN'      => 0x700],
	    'SDL_FINGERUP',
	    'SDL_FINGERMOTION',

	    # /* Gesture events */
	    ['SDL_DOLLARGESTURE'   => 0x800],
	    'SDL_DOLLARRECORD',
	    'SDL_MULTIGESTURE',

	    # /* Clipboard events */
	    ['SDL_CLIPBOARDUPDATE' => 0x900],

	    # /* Drag and drop events */
	    ['SDL_DROPFILE'        => 0x1000],
	    'SDL_DROPTEXT',
	    'SDL_DROPBEGIN',
	    'SDL_DROPCOMPLETE',

	    # /* Audio hotplug events */
	    ['SDL_AUDIODEVICEADDED' => 0x1100],
	    'SDL_AUDIODEVICEREMOVED',

	    # /* Sensor events */
	    ['SDL_SENSORUPDATE' => 0x1200],

	    # /* Render events */
	    ['SDL_RENDER_TARGETS_RESET' => 0x2000],
	    'SDL_RENDER_DEVICE_RESET',

	    ['SDL_USEREVENT'    => 0x8000],

	    ['SDL_LASTEVENT'    => 0xFFFF],
	);


	$ffi->type( 'opaque' => 'SDL_CommonEvent_ptr' );               #struct
	$ffi->type( 'opaque' => 'SDL_DisplayEvent_ptr' );              #struct
	$ffi->type( 'opaque' => 'SDL_WindowEvent_ptr' );               #struct
	$ffi->type( 'opaque' => 'SDL_KeyboardEvent_ptr' );             #struct

	#define SDL_TEXTEDITINGEVENT_TEXT_SIZE (32)
	use constant SDL_TEXTEDITINGEVENT_TEXT_SIZE   => (32);

	$ffi->type( 'opaque' => 'SDL_TextEditingEvent_ptr' );          #struct

	#define SDL_TEXTINPUTEVENT_TEXT_SIZE (32)
	use constant SDL_TEXTINPUTEVENT_TEXT_SIZE   => (32);

	$ffi->type( 'opaque' => 'SDL_TextInputEvent_ptr' );            #struct
	$ffi->type( 'opaque' => 'SDL_MouseMotionEvent_ptr' );          #struct
	$ffi->type( 'opaque' => 'SDL_MouseButtonEvent_ptr' );          #struct
	$ffi->type( 'opaque' => 'SDL_MouseWheelEvent_ptr' );           #struct
	$ffi->type( 'opaque' => 'SDL_JoyAxisEvent_ptr' );              #struct
	$ffi->type( 'opaque' => 'SDL_JoyBallEvent_ptr' );              #struct
	$ffi->type( 'opaque' => 'SDL_JoyHatEvent_ptr' );               #struct
	$ffi->type( 'opaque' => 'SDL_JoyButtonEvent_ptr' );            #struct
	$ffi->type( 'opaque' => 'SDL_JoyDeviceEvent_ptr' );            #struct
	$ffi->type( 'opaque' => 'SDL_ControllerAxisEvent_ptr' );       #struct
	$ffi->type( 'opaque' => 'SDL_ControllerButtonEvent_ptr' );     #struct
	$ffi->type( 'opaque' => 'SDL_ControllerDeviceEvent_ptr' );     #struct
	$ffi->type( 'opaque' => 'SDL_AudioDeviceEvent_ptr' );          #struct
	$ffi->type( 'opaque' => 'SDL_TouchFingerEvent_ptr' );          #struct
	$ffi->type( 'opaque' => 'SDL_MultiGestureEvent_ptr' );         #struct
	$ffi->type( 'opaque' => 'SDL_DollarGestureEvent_ptr' );        #struct
	$ffi->type( 'opaque' => 'SDL_DropEvent_ptr' );                 #struct
	$ffi->type( 'opaque' => 'SDL_SensorEvent_ptr' );               #struct
	$ffi->type( 'opaque' => 'SDL_OSEvent_ptr' );                   #struct
	$ffi->type( 'opaque' => 'SDL_UserEvent_ptr' );                 #struct


	# struct SDL_SysWMmsg;
	# typedef struct SDL_SysWMmsg SDL_SysWMmsg;

	$ffi->type( 'opaque' => 'SDL_SysWMEvent_ptr' );                #struct

	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );
	SDL2::Video::attach( $ffi );
	SDL2::Keyboard::attach( $ffi );
	SDL2::Mouse::attach( $ffi );
	SDL2::Joystick::attach( $ffi );
	SDL2::Gamecontroller::attach( $ffi );
	SDL2::Quit::attach( $ffi );
	SDL2::Gesture::attach( $ffi );
	SDL2::Touch::attach( $ffi );

# ???????????????????
	# typedef union SDL_Event
	# {
	#     Uint32 type;                    /**< Event type, shared with all events */
	#     SDL_CommonEvent common;         /**< Common event data */
	#     SDL_DisplayEvent display;       /**< Window event data */
	#     SDL_WindowEvent window;         /**< Window event data */
	#     SDL_KeyboardEvent key;          /**< Keyboard event data */
	#     SDL_TextEditingEvent edit;      /**< Text editing event data */
	#     SDL_TextInputEvent text;        /**< Text input event data */
	#     SDL_MouseMotionEvent motion;    /**< Mouse motion event data */
	#     SDL_MouseButtonEvent button;    /**< Mouse button event data */
	#     SDL_MouseWheelEvent wheel;      /**< Mouse wheel event data */
	#     SDL_JoyAxisEvent jaxis;         /**< Joystick axis event data */
	#     SDL_JoyBallEvent jball;         /**< Joystick ball event data */
	#     SDL_JoyHatEvent jhat;           /**< Joystick hat event data */
	#     SDL_JoyButtonEvent jbutton;     /**< Joystick button event data */
	#     SDL_JoyDeviceEvent jdevice;     /**< Joystick device change event data */
	#     SDL_ControllerAxisEvent caxis;      /**< Game Controller axis event data */
	#     SDL_ControllerButtonEvent cbutton;  /**< Game Controller button event data */
	#     SDL_ControllerDeviceEvent cdevice;  /**< Game Controller device event data */
	#     SDL_AudioDeviceEvent adevice;   /**< Audio device event data */
	#     SDL_SensorEvent sensor;         /**< Sensor event data */
	#     SDL_QuitEvent quit;             /**< Quit request event data */
	#     SDL_UserEvent user;             /**< Custom event data */
	#     SDL_SysWMEvent syswm;           /**< System dependent window event data */
	#     SDL_TouchFingerEvent tfinger;   /**< Touch finger event data */
	#     SDL_MultiGestureEvent mgesture; /**< Gesture event data */
	#     SDL_DollarGestureEvent dgesture; /**< Gesture event data */
	#     SDL_DropEvent drop;             /**< Drag and drop event data */

	#     /* This is necessary for ABI compatibility between Visual C++ and GCC
	#        Visual C++ will respect the push pack pragma and use 52 bytes for
	#        this structure, and GCC will use the alignment of the largest datatype
	#        within the union, which is 8 bytes.

	#        So... we'll add padding to force the size to be 56 bytes for both.
	#     */
	#     Uint8 padding[56];
	# } SDL_Event;

# ?????????????????
	$ffi->type( 'opaque' => 'SDL_Event_ptr' );

	# SDL_COMPILE_TIME_ASSERT(SDL_Event, sizeof(SDL_Event) == 56);


	# extern DECLSPEC void SDLCALL SDL_PumpEvents(void);
	$ffi->attach( SDL_PumpEvents => [ 'void'  ] => 'void' );

	# typedef enum
	# {
	#     SDL_ADDEVENT,
	#     SDL_PEEKEVENT,
	#     SDL_GETEVENT
	# } SDL_eventaction;
	$ffi->load_custom_type('::Enum', 'SDL_eventaction',
		{ ret => 'int', package => 'SDL2::Events' },
		'SDL_ADDEVENT',
		'SDL_PEEKEVENT',
		'SDL_GETEVENT',
	);


# ???????????SDL_Event
	# extern DECLSPEC int SDLCALL SDL_PeepEvents(SDL_Event * events, int numevents,
	#                                            SDL_eventaction action,
	#                                            Uint32 minType, Uint32 maxType);
	$ffi->attach( SDL_PeepEvents => [ 'SDL_Event_ptr', 'int','SDL_eventaction', 'uint32', 'uint32' ] => 'int' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasEvent(Uint32 type);
	$ffi->attach( SDL_HasEvent => [ 'uint32'  ] => 'SDL_bool' );

	# extern DECLSPEC SDL_bool SDLCALL SDL_HasEvents(Uint32 minType, Uint32 maxType);
	$ffi->attach( SDL_HasEvents => [ 'uint32', 'uint32'  ] => 'SDL_bool' );

	# extern DECLSPEC void SDLCALL SDL_FlushEvent(Uint32 type);
	$ffi->attach( SDL_FlushEvent => [ 'uint32'  ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_FlushEvents(Uint32 minType, Uint32 maxType);
	$ffi->attach( SDL_FlushEvents => [ 'uint32', 'uint32'  ] => 'void' );

# ???????????SDL_Event
	# extern DECLSPEC int SDLCALL SDL_PollEvent(SDL_Event * event);
	$ffi->attach( SDL_PollEvent => [ 'SDL_Event_ptr'  ] => 'int' );

# ???????????SDL_Event
	# extern DECLSPEC int SDLCALL SDL_WaitEvent(SDL_Event * event);
	$ffi->attach( SDL_WaitEvent => [ 'SDL_Event_ptr'  ] => 'int' );

# ???????????SDL_Event
	# extern DECLSPEC int SDLCALL SDL_WaitEventTimeout(SDL_Event * event,
	#                                                  int timeout);
	$ffi->attach( SDL_WaitEventTimeout => [ 'SDL_Event_ptr', 'int'  ] => 'int' );

# ???????????SDL_Event
	# extern DECLSPEC int SDLCALL SDL_PushEvent(SDL_Event * event);
	$ffi->attach( SDL_PushEvent => [ 'SDL_Event_ptr'  ] => 'int' );

# ????????????????????????????????????????????????????????????
	# typedef int (SDLCALL * SDL_EventFilter) (void *userdata, SDL_Event * event);

# ?????????????????
	$ffi->type( 'opaque' => 'SDL_EventFilter_ptr' );
# ???????????SDL_EventFilter
	# extern DECLSPEC void SDLCALL SDL_SetEventFilter(SDL_EventFilter filter,
	#                                                 void *userdata);
	$ffi->attach( SDL_SetEventFilter => [ 'SDL_EventFilter_ptr', 'opaque'  ] => 'void' );

# ???????????SDL_EventFilter, void**
	# extern DECLSPEC SDL_bool SDLCALL SDL_GetEventFilter(SDL_EventFilter * filter,
	#                                                     void **userdata);
	$ffi->attach( SDL_GetEventFilter => [ 'SDL_EventFilter_ptr', 'opaque'  ] => 'SDL_bool' );

# ???????????SDL_EventFilter
	# extern DECLSPEC void SDLCALL SDL_AddEventWatch(SDL_EventFilter filter,
	#                                                void *userdata);
	$ffi->attach( SDL_AddEventWatch => [ 'SDL_EventFilter_ptr', 'opaque'  ] => 'void' );


# ???????????SDL_EventFilter
	# extern DECLSPEC void SDLCALL SDL_DelEventWatch(SDL_EventFilter filter,
	#                                                void *userdata);
	$ffi->attach( SDL_DelEventWatch => [ 'SDL_EventFilter_ptr', 'opaque'  ] => 'void' );

# ???????????SDL_EventFilter
	# extern DECLSPEC void SDLCALL SDL_FilterEvents(SDL_EventFilter filter,
	#                                               void *userdata);
	$ffi->attach( SDL_FilterEvents => [ 'SDL_EventFilter_ptr', 'opaque'  ] => 'void' );


	#define SDL_QUERY   -1
	#define SDL_IGNORE   0
	#define SDL_DISABLE  0
	#define SDL_ENABLE   1
	use constant SDL_QUERY     => -1;
	use constant SDL_IGNORE    =>  0;
	use constant SDL_DISABLE   =>  0;
	use constant SDL_ENABLE    =>  1;

	# extern DECLSPEC Uint8 SDLCALL SDL_EventState(Uint32 type, int state);
	$ffi->attach( SDL_EventState => [ 'uint32', 'int'  ] => 'uint8' );



	# extern DECLSPEC Uint32 SDLCALL SDL_RegisterEvents(int numevents);
	$ffi->attach( SDL_RegisterEvents => [ 'int'  ] => 'uint32' );


}

#define SDL_GetEventState(type) SDL_EventState(type, SDL_QUERY)
sub SDL_GetEventState {
	my( $type ) =  @_;

	return SDL_EventState( $type, SDL_QUERY );
}

1;
