package SDL2::Audio;

use strict;
use warnings;

#include "SDL_stdinc.h"
#include "SDL_error.h"
#include "SDL_endian.h"
#include "SDL_mutex.h"
#include "SDL_thread.h"
#include "SDL_rwops.h"
use SDL2::Stdinc;
use SDL2::Error;
use SDL2::Endian;
use SDL2::Mutex;
use SDL2::Thread;
use SDL2::Rwops;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# typedef Uint16 SDL_AudioFormat;
	$ffi->type( 'uint16' => 'SDL_AudioFormat' );


	#define SDL_AUDIO_MASK_BITSIZE       (0xFF)
	# sub SDL_AUDIO_MASK_BITSIZE{ return (0xFF) };
#define SDL_AUDIO_MASK_DATATYPE      (1<<8)
#define SDL_AUDIO_MASK_ENDIAN        (1<<12)
#define SDL_AUDIO_MASK_SIGNED        (1<<15)
	#define SDL_AUDIO_BITSIZE(x)         (x & SDL_AUDIO_MASK_BITSIZE)
	# sub SDL_AUDIO_BITSIZE{
	# 	my( $x ) =  @_;

	# 	return ($x & SDL_AUDIO_MASK_BITSIZE);
	# }
#define SDL_AUDIO_ISFLOAT(x)         (x & SDL_AUDIO_MASK_DATATYPE)
#define SDL_AUDIO_ISBIGENDIAN(x)     (x & SDL_AUDIO_MASK_ENDIAN)
#define SDL_AUDIO_ISSIGNED(x)        (x & SDL_AUDIO_MASK_SIGNED)
#define SDL_AUDIO_ISINT(x)           (!SDL_AUDIO_ISFLOAT(x))
#define SDL_AUDIO_ISLITTLEENDIAN(x)  (!SDL_AUDIO_ISBIGENDIAN(x))
	#define SDL_AUDIO_ISUNSIGNED(x)      (!SDL_AUDIO_ISSIGNED(x))
	# sub SDL_AUDIO_ISUNSIGNED {
	# 	my( $x ) =  @_;

	# 	return (!SDL_AUDIO_ISSIGNED( $x ));
	# }


#define AUDIO_U8        0x0008  /**< Unsigned 8-bit samples */
#define AUDIO_S8        0x8008  /**< Signed 8-bit samples */
#define AUDIO_U16LSB    0x0010  /**< Unsigned 16-bit samples */
#define AUDIO_S16LSB    0x8010  /**< Signed 16-bit samples */
#define AUDIO_U16MSB    0x1010  /**< As above, but big-endian byte order */
#define AUDIO_S16MSB    0x9010  /**< As above, but big-endian byte order */
#define AUDIO_U16       AUDIO_U16LSB
#define AUDIO_S16       AUDIO_S16LSB

#define AUDIO_S32LSB    0x8020  /**< 32-bit integer samples */
#define AUDIO_S32MSB    0x9020  /**< As above, but big-endian byte order */
#define AUDIO_S32       AUDIO_S32LSB

#define AUDIO_F32LSB    0x8120  /**< 32-bit floating point samples */
#define AUDIO_F32MSB    0x9120  /**< As above, but big-endian byte order */
#define AUDIO_F32       AUDIO_F32LSB

#if SDL_BYTEORDER == SDL_LIL_ENDIAN
#define AUDIO_U16SYS    AUDIO_U16LSB
#define AUDIO_S16SYS    AUDIO_S16LSB
#define AUDIO_S32SYS    AUDIO_S32LSB
#define AUDIO_F32SYS    AUDIO_F32LSB
#else
#define AUDIO_U16SYS    AUDIO_U16MSB
#define AUDIO_S16SYS    AUDIO_S16MSB
#define AUDIO_S32SYS    AUDIO_S32MSB
#define AUDIO_F32SYS    AUDIO_F32MSB
#endif
	# if( SDL_BYTEORDER == SDL_LIL_ENDIAN ) {

	# }
	# else {
	# }

#define SDL_AUDIO_ALLOW_FREQUENCY_CHANGE    0x00000001
#define SDL_AUDIO_ALLOW_FORMAT_CHANGE       0x00000002
#define SDL_AUDIO_ALLOW_CHANNELS_CHANGE     0x00000004
#define SDL_AUDIO_ALLOW_SAMPLES_CHANGE      0x00000008
#define SDL_AUDIO_ALLOW_ANY_CHANGE          (SDL_AUDIO_ALLOW_FREQUENCY_CHANGE|SDL_AUDIO_ALLOW_FORMAT_CHANGE|SDL_AUDIO_ALLOW_CHANNELS_CHANGE|SDL_AUDIO_ALLOW_SAMPLES_CHANGE)

# ??????????????////
	# typedef void (SDLCALL * SDL_AudioCallback) (void *userdata, Uint8 * stream,
	                                            # int len);


	$ffi->type( 'opaque' => 'SDL_AudioSpec_ptr' );        #struct


# ??????????????////
	# struct SDL_AudioCVT;
	# typedef void (SDLCALL * SDL_AudioFilter) (struct SDL_AudioCVT * cvt,
	#                                           SDL_AudioFormat format);


	#define SDL_AUDIOCVT_MAX_FILTERS 9
	use constant SDL_AUDIOCVT_MAX_FILTERS  =>  9;

#ifdef __GNUC__

#define SDL_AUDIOCVT_PACKED __attribute__((packed))
#else
#define SDL_AUDIOCVT_PACKED
#endif
	$ffi->type( 'opaque' => 'SDL_AudioCVT_ptr' );        #struct

	SDL2::Endian::attach( $ffi );
	SDL2::Mutex::attach( $ffi );
	SDL2::Thread::attach( $ffi );
	SDL2::Rwops::attach( $ffi );

	# extern DECLSPEC int SDLCALL SDL_GetNumAudioDrivers(void);
	$ffi->attach( SDL_GetNumAudioDrivers => [ 'void'  ] => 'int' );

	# extern DECLSPEC const char *SDLCALL SDL_GetAudioDriver(int index);
	$ffi->attach( SDL_GetAudioDriver => [ 'int'  ] => 'string' );

	# extern DECLSPEC int SDLCALL SDL_AudioInit(const char *driver_name);
	$ffi->attach( SDL_AudioInit => [ 'string'  ] => 'int' );

	# extern DECLSPEC void SDLCALL SDL_AudioQuit(void);
	$ffi->attach( SDL_AudioQuit => [ 'void'  ] => 'void' );

	# extern DECLSPEC const char *SDLCALL SDL_GetCurrentAudioDriver(void);
	$ffi->attach( SDL_GetCurrentAudioDriver => [ 'void'  ] => 'string' );

	# extern DECLSPEC int SDLCALL SDL_OpenAudio(SDL_AudioSpec * desired,
	#                                           SDL_AudioSpec * obtained);
	$ffi->attach( SDL_OpenAudio => [ 'SDL_AudioSpec_ptr', 'SDL_AudioSpec_ptr'  ] => 'int' );

	# typedef Uint32 SDL_AudioDeviceID;
	$ffi->type( 'uint32' => 'SDL_AudioDeviceID' );

	# extern DECLSPEC int SDLCALL SDL_GetNumAudioDevices(int iscapture);
	$ffi->attach( SDL_GetNumAudioDevices => [ 'int'  ] => 'int' );

	# extern DECLSPEC const char *SDLCALL SDL_GetAudioDeviceName(int index,
	#                                                            int iscapture);
	$ffi->attach( SDL_GetAudioDeviceName => [ 'int', 'int'  ] => 'string' );

	# extern DECLSPEC SDL_AudioDeviceID SDLCALL SDL_OpenAudioDevice(const char
	#                                                               *device,
	#                                                               int iscapture,
	#                                                               const
	#                                                               SDL_AudioSpec *
	#                                                               desired,
	#                                                               SDL_AudioSpec *
	#                                                               obtained,
	#                                                               int
	#                                                               allowed_changes);
	$ffi->attach( SDL_OpenAudioDevice => [ 'string', 'int', 'SDL_AudioSpec_ptr', 'SDL_AudioSpec_ptr', 'int' ] => 'SDL_AudioDeviceID' );


	# typedef enum
	# {
	#     SDL_AUDIO_STOPPED = 0,
	#     SDL_AUDIO_PLAYING,
	#     SDL_AUDIO_PAUSED
	# } SDL_AudioStatus;
	$ffi->load_custom_type('::Enum', 'SDL_AudioStatus',
		{ ret => 'int', package => 'SDL2::Audio' },
		['SDL_AUDIO_STOPPED' => 0],
		'SDL_AUDIO_PLAYING',
		'SDL_AUDIO_PAUSED',
	);


	# extern DECLSPEC SDL_AudioStatus SDLCALL SDL_GetAudioStatus(void);
	$ffi->attach( SDL_GetAudioStatus => [ 'void' ] => 'SDL_AudioStatus' );

	# extern DECLSPEC SDL_AudioStatus SDLCALL
	# SDL_GetAudioDeviceStatus(SDL_AudioDeviceID dev);
	$ffi->attach( SDL_GetAudioDeviceStatus => [ 'SDL_AudioDeviceID' ] => 'SDL_AudioStatus' );

	# extern DECLSPEC void SDLCALL SDL_PauseAudio(int pause_on);
	$ffi->attach( SDL_PauseAudio => [ 'int'  ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_PauseAudioDevice(SDL_AudioDeviceID dev,
	#                                                   int pause_on);
	$ffi->attach( SDL_PauseAudioDevice => [ 'SDL_AudioDeviceID', 'int' ] => 'void' );

	# extern DECLSPEC SDL_AudioSpec *SDLCALL SDL_LoadWAV_RW(SDL_RWops * src,
	#                                                       int freesrc,
	#                                                       SDL_AudioSpec * spec,
	#                                                       Uint8 ** audio_buf,
	#                                                       Uint32 * audio_len);
	$ffi->attach( SDL_LoadWAV_RW => [ 'SDL_RWops_ptr', 'int', 'SDL_AudioSpec_ptr', 'uint8', 'uint32' ] => 'SDL_AudioSpec_ptr' );

# ?????????????????????
#define SDL_LoadWAV(file, spec, audio_buf, audio_len) \
    # SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"),1, spec,audio_buf,audio_len)


	# extern DECLSPEC void SDLCALL SDL_FreeWAV(Uint8 * audio_buf);
	$ffi->attach( SDL_FreeWAV => [ 'uint8'  ] => 'void' );

	# extern DECLSPEC int SDLCALL SDL_BuildAudioCVT(SDL_AudioCVT * cvt,
	#                                               SDL_AudioFormat src_format,
	#                                               Uint8 src_channels,
	#                                               int src_rate,
	#                                               SDL_AudioFormat dst_format,
	#                                               Uint8 dst_channels,
	#                                               int dst_rate);
	$ffi->attach( SDL_BuildAudioCVT => [ 'SDL_AudioCVT_ptr', 'SDL_AudioFormat', 'uint8', 'int', 'SDL_AudioFormat', 'uint8', 'int' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_ConvertAudio(SDL_AudioCVT * cvt);
	$ffi->attach( SDL_ConvertAudio => [ 'SDL_AudioCVT_ptr'  ] => 'int' );

	# struct _SDL_AudioStream;
	# typedef struct _SDL_AudioStream SDL_AudioStream;
	$ffi->type( 'opaque' => 'SDL_AudioStream_ptr' );        #struct

	# extern DECLSPEC SDL_AudioStream * SDLCALL SDL_NewAudioStream(const SDL_AudioFormat src_format,
	#                                            const Uint8 src_channels,
	#                                            const int src_rate,
	#                                            const SDL_AudioFormat dst_format,
	#                                            const Uint8 dst_channels,
	#                                            const int dst_rate);
	$ffi->attach( SDL_NewAudioStream => [ 'SDL_AudioFormat', 'uint8', 'int', 'SDL_AudioFormat', 'uint8', 'int' ] => 'SDL_AudioStream_ptr' );

	# extern DECLSPEC int SDLCALL SDL_AudioStreamPut(SDL_AudioStream *stream, const void *buf, int len);
	$ffi->attach( SDL_AudioStreamPut => [ 'SDL_AudioStream_ptr', 'string', 'int'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_AudioStreamGet(SDL_AudioStream *stream, void *buf, int len);
	$ffi->attach( SDL_AudioStreamGet => [ 'SDL_AudioStream_ptr', 'string', 'int'  ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_AudioStreamAvailable(SDL_AudioStream *stream);
	$ffi->attach( SDL_AudioStreamAvailable => [ 'SDL_AudioStream_ptr' ] => 'int' );

	# extern DECLSPEC int SDLCALL SDL_AudioStreamFlush(SDL_AudioStream *stream);
	$ffi->attach( SDL_AudioStreamFlush => [ 'SDL_AudioStream_ptr' ] => 'int' );

	# extern DECLSPEC void SDLCALL SDL_AudioStreamClear(SDL_AudioStream *stream);
	$ffi->attach( SDL_AudioStreamClear => [ 'SDL_AudioStream_ptr' ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_FreeAudioStream(SDL_AudioStream *stream);
	$ffi->attach( SDL_FreeAudioStream => [ 'SDL_AudioStream_ptr' ] => 'void' );

	#define SDL_MIX_MAXVOLUME 128
	use constant SDL_MIX_MAXVOLUME  =>  128;

	# extern DECLSPEC void SDLCALL SDL_MixAudio(Uint8 * dst, const Uint8 * src,
	#                                           Uint32 len, int volume);
	$ffi->attach( SDL_MixAudio => [ 'uint8', 'uint8', 'uint32', 'int' ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_MixAudioFormat(Uint8 * dst,
	#                                                 const Uint8 * src,
	#                                                 SDL_AudioFormat format,
	#                                                 Uint32 len, int volume);
	$ffi->attach( SDL_MixAudioFormat => [ 'uint8', 'uint8', 'SDL_AudioFormat', 'uint32', 'int' ] => 'void' );

	# extern DECLSPEC int SDLCALL SDL_QueueAudio(SDL_AudioDeviceID dev, const void *data, Uint32 len);
	$ffi->attach( SDL_QueueAudio => [ 'SDL_AudioDeviceID', 'string', 'uint32' ] => 'int' );

	# extern DECLSPEC Uint32 SDLCALL SDL_DequeueAudio(SDL_AudioDeviceID dev, void *data, Uint32 len);
	$ffi->attach( SDL_DequeueAudio => [ 'SDL_AudioDeviceID', 'string', 'uint32' ] => 'uint32' );

	# extern DECLSPEC Uint32 SDLCALL SDL_GetQueuedAudioSize(SDL_AudioDeviceID dev);
	$ffi->attach( SDL_GetQueuedAudioSize => [ 'SDL_AudioDeviceID' ] => 'uint32' );

	# extern DECLSPEC void SDLCALL SDL_ClearQueuedAudio(SDL_AudioDeviceID dev);
	$ffi->attach( SDL_ClearQueuedAudio => [ 'SDL_AudioDeviceID' ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_LockAudio(void);
	$ffi->attach( SDL_LockAudio => [ 'void' ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_LockAudioDevice(SDL_AudioDeviceID dev);
	$ffi->attach( SDL_LockAudioDevice => [ 'SDL_AudioDeviceID' ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_UnlockAudio(void);
	$ffi->attach( SDL_UnlockAudio => [ 'void' ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_UnlockAudioDevice(SDL_AudioDeviceID dev);
	$ffi->attach( SDL_UnlockAudioDevice => [ 'SDL_AudioDeviceID' ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_CloseAudio(void);
	$ffi->attach( SDL_CloseAudio => [ 'void' ] => 'void' );

	# extern DECLSPEC void SDLCALL SDL_CloseAudioDevice(SDL_AudioDeviceID dev);
	$ffi->attach( SDL_CloseAudioDevice => [ 'SDL_AudioDeviceID' ] => 'void' );

}

1;
