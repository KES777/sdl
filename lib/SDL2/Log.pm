package SDL2::Log;

use strict;
use warnings;


use SDL2::Stdinc;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;



	#define SDL_MAX_LOG_MESSAGE 4096
	use constant SDL_MAX_LOG_MESSAGE  => 4096;

	SDL2::Stdinc::attach( $ffi );

# ??????????????????????????enum
	# enum
	# {
	    # SDL_LOG_CATEGORY_APPLICATION,
	    # SDL_LOG_CATEGORY_ERROR,
	    # SDL_LOG_CATEGORY_ASSERT,
	    # SDL_LOG_CATEGORY_SYSTEM,
	    # SDL_LOG_CATEGORY_AUDIO,
	    # SDL_LOG_CATEGORY_VIDEO,
	    # SDL_LOG_CATEGORY_RENDER,
	    # SDL_LOG_CATEGORY_INPUT,
	    # SDL_LOG_CATEGORY_TEST,

	    # /* Reserved for future SDL library use */
	    # SDL_LOG_CATEGORY_RESERVED1,
	    # SDL_LOG_CATEGORY_RESERVED2,
	    # SDL_LOG_CATEGORY_RESERVED3,
	    # SDL_LOG_CATEGORY_RESERVED4,
	    # SDL_LOG_CATEGORY_RESERVED5,
	    # SDL_LOG_CATEGORY_RESERVED6,
	    # SDL_LOG_CATEGORY_RESERVED7,
	    # SDL_LOG_CATEGORY_RESERVED8,
	    # SDL_LOG_CATEGORY_RESERVED9,
	    # SDL_LOG_CATEGORY_RESERVED10,

	    # /* Beyond this point is reserved for application use, e.g.
	       # enum {
	           # MYAPP_CATEGORY_AWESOME1 = SDL_LOG_CATEGORY_CUSTOM,
	           # MYAPP_CATEGORY_AWESOME2,
	           # MYAPP_CATEGORY_AWESOME3,
	           # ...
	       # };
	     # */
	    # SDL_LOG_CATEGORY_CUSTOM
# ??????????????????????/
	# } LogEnum_wihtoutname;
	$ffi->load_custom_type('::Enum',
		'SDL_LOG_CATEGORY_APPLICATION',
		'SDL_LOG_CATEGORY_ERROR',
		'SDL_LOG_CATEGORY_ASSERT',
		'SDL_LOG_CATEGORY_SYSTEM',
		'SDL_LOG_CATEGORY_AUDIO',
		'SDL_LOG_CATEGORY_VIDEO',
		'SDL_LOG_CATEGORY_RENDER',
		'SDL_LOG_CATEGORY_INPUT',
		'SDL_LOG_CATEGORY_TEST',

		# /* Reserved for future SDL library use */
		'SDL_LOG_CATEGORY_RESERVED1',
		'SDL_LOG_CATEGORY_RESERVED2',
		'SDL_LOG_CATEGORY_RESERVED3',
		'SDL_LOG_CATEGORY_RESERVED4',
		'SDL_LOG_CATEGORY_RESERVED5',
		'SDL_LOG_CATEGORY_RESERVED6',
		'SDL_LOG_CATEGORY_RESERVED7',
		'SDL_LOG_CATEGORY_RESERVED8',
		'SDL_LOG_CATEGORY_RESERVED9',
		'SDL_LOG_CATEGORY_RESERVED10',

		'SDL_LOG_CATEGORY_CUSTOM',
	);


	# typedef enum
	# {
	#     SDL_LOG_PRIORITY_VERBOSE = 1,
	#     SDL_LOG_PRIORITY_DEBUG,
	#     SDL_LOG_PRIORITY_INFO,
	#     SDL_LOG_PRIORITY_WARN,
	#     SDL_LOG_PRIORITY_ERROR,
	#     SDL_LOG_PRIORITY_CRITICAL,
	#     SDL_NUM_LOG_PRIORITIES
	# } SDL_LogPriority;
	$ffi->load_custom_type('::Enum', 'SDL_LogPriority',
		['SDL_LOG_PRIORITY_VERBOSE' => 1],
		'SDL_LOG_PRIORITY_DEBUG',
		'SDL_LOG_PRIORITY_INFO',
		'SDL_LOG_PRIORITY_WARN',
		'SDL_LOG_PRIORITY_ERROR',
		'SDL_LOG_PRIORITY_CRITICAL',
		'SDL_NUM_LOG_PRIORITIES',
	);


	# extern DECLSPEC void SDLCALL SDL_LogSetAllPriority(SDL_LogPriority priority);
	$ffi->attach( SDL_LogSetAllPriority => [ 'SDL_LogPriority'  ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_LogSetPriority(int category,
	#                                                 SDL_LogPriority priority);
	$ffi->attach( SDL_LogSetPriority => [ 'int', 'SDL_LogPriority'  ] => 'void' );

	# extern DECLSPEC SDL_LogPriority SDLCALL SDL_LogGetPriority(int category);
	$ffi->attach( SDL_LogGetPriority => [ 'int' ] => 'SDL_LogPriority' );

	# extern DECLSPEC void SDLCALL SDL_LogResetPriorities(void);
	$ffi->attach( SDL_LogResetPriorities => [ 'void'  ] => 'void' );

# ???????????????????? в конце строк
	# extern DECLSPEC void SDLCALL SDL_Log(SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(1);


	# extern DECLSPEC void SDLCALL SDL_LogVerbose(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);


	# extern DECLSPEC void SDLCALL SDL_LogDebug(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);


	# extern DECLSPEC void SDLCALL SDL_LogInfo(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);


	# extern DECLSPEC void SDLCALL SDL_LogWarn(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);


	# extern DECLSPEC void SDLCALL SDL_LogError(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);


	# extern DECLSPEC void SDLCALL SDL_LogCritical(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);


	# extern DECLSPEC void SDLCALL SDL_LogMessage(int category,
	#                                             SDL_LogPriority priority,
	#                                             SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(3);

# ??????????????? va_list
	# extern DECLSPEC void SDLCALL SDL_LogMessageV(int category,
	#                                              SDL_LogPriority priority,
	#                                              const char *fmt, va_list ap);
	# $ffi->attach( SDL_LogMessageV => [ 'SDL_LogPriority', 'opaque', 'va_list'  ] => 'void' );

# ????????????????????
	# typedef void (SDLCALL *SDL_LogOutputFunction)(void *userdata, int category, SDL_LogPriority priority, const char *message);
	$ffi->type( 'int'    => 'SDL_LogOutputFunction' );

# ???????????????????? void**
	# extern DECLSPEC void SDLCALL SDL_LogGetOutputFunction(SDL_LogOutputFunction *callback, void **userdata);
	$ffi->attach( SDL_LogGetOutputFunction => [ 'SDL_LogOutputFunction', 'opaque'  ] => 'void' );


	# extern DECLSPEC void SDLCALL SDL_LogSetOutputFunction(SDL_LogOutputFunction callback, void *userdata);
	$ffi->attach( SDL_LogSetOutputFunction => [ 'SDL_LogOutputFunction', 'opaque'  ] => 'void' );


}

1;
