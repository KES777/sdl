package SDL2::Haptic;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_error.h"
#include "SDL_joystick.h"
use SDL2::Stdinc;
use SDL2::Error;
use SDL2::Joystick;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	$ffi->type( 'opaque' => 'SDL_Haptic_ptr' );                #struct

# ??????????????????????   1u
	# define SDL_HAPTIC_CONSTANT   (1u<<0)
	use constant SDL_HAPTIC_CONSTANT   => '(1u<<0)';

	# define SDL_HAPTIC_SINE       (1u<<1)
	use constant SDL_HAPTIC_SINE   => '(1u<<1)';

	# define SDL_HAPTIC_LEFTRIGHT     (1u<<2)
	use constant SDL_HAPTIC_LEFTRIGHT   => '(1u<<2)';

	# define SDL_HAPTIC_TRIANGLE   (1u<<3)
	use constant SDL_HAPTIC_TRIANGLE   => '(1u<<3)';

	# define SDL_HAPTIC_SAWTOOTHUP (1u<<4)
	use constant SDL_HAPTIC_SAWTOOTHUP   => '(1u<<4)';

	# define SDL_HAPTIC_SAWTOOTHDOWN (1u<<5)
	use constant SDL_HAPTIC_SAWTOOTHDOWN   => '(1u<<5)';

	# define SDL_HAPTIC_RAMP       (1u<<6)
	use constant SDL_HAPTIC_RAMP   => '(1u<<6)';

	# define SDL_HAPTIC_SPRING     (1u<<7)
	use constant SDL_HAPTIC_SPRING   => '(1u<<7)';

	# define SDL_HAPTIC_DAMPER     (1u<<8)
	use constant SDL_HAPTIC_DAMPER   => '(1u<<8)';

	# define SDL_HAPTIC_INERTIA    (1u<<9)
	use constant SDL_HAPTIC_INERTIA   => '(1u<<9)';

	# define SDL_HAPTIC_FRICTION   (1u<<10)
	use constant SDL_HAPTIC_FRICTION   => '(1u<<10)';

	# define SDL_HAPTIC_CUSTOM     (1u<<11)
	use constant SDL_HAPTIC_CUSTOM   => '(1u<<11)';

	# define SDL_HAPTIC_GAIN       (1u<<12)
	use constant SDL_HAPTIC_GAIN   => '(1u<<12)';

	# define SDL_HAPTIC_AUTOCENTER (1u<<13)
	use constant SDL_HAPTIC_AUTOCENTER   => '(1u<<13)';

	# define SDL_HAPTIC_STATUS     (1u<<14)
	use constant SDL_HAPTIC_STATUS   => '(1u<<14)';

	# define SDL_HAPTIC_PAUSE      (1u<<15)
	use constant SDL_HAPTIC_PAUSE   => '(1u<<15)';

	# define SDL_HAPTIC_POLAR      0
	use constant SDL_HAPTIC_POLAR   => 0;

	# define SDL_HAPTIC_CARTESIAN  1
	use constant SDL_HAPTIC_CARTESIAN   => 1;

	# define SDL_HAPTIC_SPHERICAL  2
	use constant SDL_HAPTIC_SPHERICAL   => 2;

# ???????????????????/4294967295U
	# define SDL_HAPTIC_INFINITY   4294967295U
	use constant SDL_HAPTIC_INFINITY   => '4294967295U';

	$ffi->type( 'opaque' => 'SDL_HapticDirection_ptr' );           #struct
	$ffi->type( 'opaque' => 'SDL_HapticConstant_ptr' );            #struct
	$ffi->type( 'opaque' => 'SDL_HapticPeriodic_ptr' );            #struct
	$ffi->type( 'opaque' => 'SDL_HapticCondition_ptr' );           #struct
	$ffi->type( 'opaque' => 'SDL_HapticRamp_ptr' );                #struct
	$ffi->type( 'opaque' => 'SDL_HapticLeftRight_ptr' );           #struct
	$ffi->type( 'opaque' => 'SDL_HapticCustom_ptr' );              #struct

# ??????????????????union
	# typedef union SDL_HapticEffect
	# {
	#     /* Common for all force feedback effects */
	#     Uint16 type;                    /**< Effect type. */
	#     SDL_HapticConstant constant;    /**< Constant effect. */
	#     SDL_HapticPeriodic periodic;    /**< Periodic effect. */
	#     SDL_HapticCondition condition;  /**< Condition effect. */
	#     SDL_HapticRamp ramp;            /**< Ramp effect. */
	#     SDL_HapticLeftRight leftright;  /**< Left/Right effect. */
	#     SDL_HapticCustom custom;        /**< Custom effect. */
	# } SDL_HapticEffect;
	$ffi->type( 'opaque' => 'SDL_HapticEffect_ptr' );

	SDL2::Stdinc::attach( $ffi );
	SDL2::Error::attach( $ffi );
	SDL2::Joystick::attach( $ffi );


	# extern DECLSPEC int SDLCALL SDL_NumHaptics(void);
	$ffi->attach( SDL_NumHaptics => [ 'void'  ] => 'int' );

	# extern DECLSPEC const char *SDLCALL SDL_HapticName(int device_index);
	$ffi->attach( SDL_HapticName => [ 'int'  ] => 'opaque' );

	# extern DECLSPEC SDL_Haptic *SDLCALL SDL_HapticOpen(int device_index);
	$ffi->attach( SDL_HapticOpen => [ 'int'  ] => 'SDL_Haptic_ptr' );

	# extern DECLSPEC int SDLCALL SDL_HapticOpened(int device_index);
	$ffi->attach( SDL_HapticOpened => [ 'int'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticIndex(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticIndex => [ 'SDL_Haptic_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_MouseIsHaptic(void);
	$ffi->attach( SDL_MouseIsHaptic => [ 'void'  ] => 'int' );

	# extern DECLSPEC SDL_Haptic *SDLCALL SDL_HapticOpenFromMouse(void);
	$ffi->attach( SDL_HapticOpenFromMouse => [ 'void'  ] => 'SDL_Haptic_ptr' );

	# extern DECLSPEC int SDLCALL SDL_JoystickIsHaptic(SDL_Joystick * joystick);
	$ffi->attach( SDL_JoystickIsHaptic => [ 'SDL_Joystick_ptr'  ] => 'int' );

	# extern DECLSPEC SDL_Haptic *SDLCALL SDL_HapticOpenFromJoystick(SDL_Joystick *
	#                                                                joystick);
	$ffi->attach( SDL_HapticOpenFromJoystick => [ 'SDL_Joystick_ptr'  ] => 'SDL_Haptic_ptr' );

	# extern DECLSPEC void SDLCALL SDL_HapticClose(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticClose => [ 'SDL_Haptic_ptr'  ] => 'void' );

	# extern DECLSPEC int SDLCALL SDL_HapticNumEffects(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticNumEffects => [ 'SDL_Haptic_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticNumEffectsPlaying(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticNumEffectsPlaying => [ 'SDL_Haptic_ptr'  ] => 'int' );

	# extern DECLSPEC unsigned int SDLCALL SDL_HapticQuery(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticQuery => [ 'SDL_Haptic_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticNumAxes(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticNumAxes => [ 'SDL_Haptic_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticEffectSupported(SDL_Haptic * haptic,
	#                                                       SDL_HapticEffect *
	#                                                       effect);
	$ffi->attach( SDL_HapticEffectSupported => [ 'SDL_Haptic_ptr', 'SDL_HapticEffect_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticNewEffect(SDL_Haptic * haptic,
	#                                                 SDL_HapticEffect * effect);
	$ffi->attach( SDL_HapticNewEffect => [ 'SDL_Haptic_ptr', 'SDL_HapticEffect_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticUpdateEffect(SDL_Haptic * haptic,
	#                                                    int effect,
	#                                                    SDL_HapticEffect * data);
	$ffi->attach( SDL_HapticUpdateEffect => [ 'SDL_Haptic_ptr', 'int', 'SDL_HapticEffect_ptr'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticRunEffect(SDL_Haptic * haptic,
	#                                                 int effect,
	#                                                 Uint32 iterations);
	$ffi->attach( SDL_HapticRunEffect => [ 'SDL_Haptic_ptr', 'int', 'uint32'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticStopEffect(SDL_Haptic * haptic,
	#                                                  int effect);
	$ffi->attach( SDL_HapticStopEffect => [ 'SDL_Haptic_ptr', 'int' ] => 'int' );

	# extern DECLSPEC void SDLCALL SDL_HapticDestroyEffect(SDL_Haptic * haptic,
	#                                                      int effect);
	$ffi->attach( SDL_HapticDestroyEffect => [ 'SDL_Haptic_ptr', 'int' ] => 'void' );

	# extern DECLSPEC int SDLCALL SDL_HapticGetEffectStatus(SDL_Haptic * haptic,
	#                                                       int effect);
	$ffi->attach( SDL_HapticGetEffectStatus => [ 'SDL_Haptic_ptr', 'int' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticSetGain(SDL_Haptic * haptic, int gain);
	$ffi->attach( SDL_HapticSetGain => [ 'SDL_Haptic_ptr', 'int' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticSetAutocenter(SDL_Haptic * haptic,
	#                                                     int autocenter);
	$ffi->attach( SDL_HapticSetAutocenter => [ 'SDL_Haptic_ptr', 'int' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticPause(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticPause => [ 'SDL_Haptic_ptr' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticUnpause(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticUnpause => [ 'SDL_Haptic_ptr' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticStopAll(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticStopAll => [ 'SDL_Haptic_ptr' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticRumbleSupported(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticRumbleSupported => [ 'SDL_Haptic_ptr' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticRumbleInit(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticRumbleInit => [ 'SDL_Haptic_ptr' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticRumblePlay(SDL_Haptic * haptic, float strength, Uint32 length );
	$ffi->attach( SDL_HapticRumblePlay => [ 'SDL_Haptic_ptr', 'float', 'uint32' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_HapticRumbleStop(SDL_Haptic * haptic);
	$ffi->attach( SDL_HapticRumbleStop => [ 'SDL_Haptic_ptr' ] => 'int' );

}

1;
