package SDL2::Blendmode;

use strict;
use warnings;

my $processed;
sub attach {
	!$processed   or return;
	$processed++;

	my( $ffi ) =  @_;

	# typedef enum
	# {
	#     SDL_BLENDMODE_NONE = 0x00000000,     /**< no blending
	#                                               dstRGBA = srcRGBA */
	#     SDL_BLENDMODE_BLEND = 0x00000001,    /**< alpha blending
	#                                               dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
	#                                               dstA = srcA + (dstA * (1-srcA)) */
	#     SDL_BLENDMODE_ADD = 0x00000002,      /**< additive blending
	#                                               dstRGB = (srcRGB * srcA) + dstRGB
	#                                               dstA = dstA */
	#     SDL_BLENDMODE_MOD = 0x00000004,      /**< color modulate
	#                                               dstRGB = srcRGB * dstRGB
	#                                               dstA = dstA */
	#     SDL_BLENDMODE_INVALID = 0x7FFFFFFF

	#     /* Additional custom blend modes can be returned by SDL_ComposeCustomBlendMode() */

	# } SDL_BlendMode;
	$ffi->load_custom_type('::Enum', 'SDL_BlendMode',
		{ ret => 'int', package => 'SDL2::Blendmode' },
		['SDL_BLENDMODE_NONE'    => 0x00000000],
		['SDL_BLENDMODE_BLEND'   => 0x00000001],
		['SDL_BLENDMODE_ADD'     => 0x00000002],
		['SDL_BLENDMODE_MOD'     => 0x00000004],
		['SDL_BLENDMODE_INVALID' => 0x7FFFFFFF],
	);

	# typedef enum
	# {
	#     SDL_BLENDOPERATION_ADD              = 0x1,  /**< dst + src: supported by all renderers */
	#     SDL_BLENDOPERATION_SUBTRACT         = 0x2,  /**< dst - src : supported by D3D9, D3D11, OpenGL, OpenGLES */
	#     SDL_BLENDOPERATION_REV_SUBTRACT     = 0x3,  /**< src - dst : supported by D3D9, D3D11, OpenGL, OpenGLES */
	#     SDL_BLENDOPERATION_MINIMUM          = 0x4,  /**< min(dst, src) : supported by D3D11 */
	#     SDL_BLENDOPERATION_MAXIMUM          = 0x5   /**< max(dst, src) : supported by D3D11 */
	# } SDL_BlendOperation;
	$ffi->load_custom_type('::Enum', 'SDL_BlendOperation',
		{ ret => 'int', package => 'SDL2::Blendmode' },
		['SDL_BLENDOPERATION_ADD'              => 0x1],
		['SDL_BLENDOPERATION_SUBTRACT'         => 0x2],
		['SDL_BLENDOPERATION_REV_SUBTRACT'     => 0x3],
		['SDL_BLENDOPERATION_MINIMUM'          => 0x4],
		['SDL_BLENDOPERATION_MAXIMUM'          => 0x5],
	);

	# typedef enum
	# {
	#     SDL_BLENDFACTOR_ZERO                = 0x1,  /**< 0, 0, 0, 0 */
	#     SDL_BLENDFACTOR_ONE                 = 0x2,  /**< 1, 1, 1, 1 */
	#     SDL_BLENDFACTOR_SRC_COLOR           = 0x3,  /**< srcR, srcG, srcB, srcA */
	#     SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR = 0x4,  /**< 1-srcR, 1-srcG, 1-srcB, 1-srcA */
	#     SDL_BLENDFACTOR_SRC_ALPHA           = 0x5,  /**< srcA, srcA, srcA, srcA */
	#     SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA = 0x6,  /**< 1-srcA, 1-srcA, 1-srcA, 1-srcA */
	#     SDL_BLENDFACTOR_DST_COLOR           = 0x7,  /**< dstR, dstG, dstB, dstA */
	#     SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR = 0x8,  /**< 1-dstR, 1-dstG, 1-dstB, 1-dstA */
	#     SDL_BLENDFACTOR_DST_ALPHA           = 0x9,  /**< dstA, dstA, dstA, dstA */
	#     SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA = 0xA   /**< 1-dstA, 1-dstA, 1-dstA, 1-dstA */
	# } SDL_BlendFactor;
	$ffi->load_custom_type('::Enum', 'SDL_BlendFactor',
		{ ret => 'int', package => 'SDL2::Blendmode' },
		['SDL_BLENDFACTOR_ZERO'                => 0x1],
		['SDL_BLENDFACTOR_ONE'                 => 0x2],
		['SDL_BLENDFACTOR_SRC_COLOR'           => 0x3],
		['SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR' => 0x4],
		['SDL_BLENDFACTOR_SRC_ALPHA'           => 0x5],
		['SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA' => 0x6],
		['SDL_BLENDFACTOR_DST_COLOR'           => 0x7],
		['SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR' => 0x8],
		['SDL_BLENDFACTOR_DST_ALPHA'           => 0x9],
		['SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA' => 0xA],
	);


	# extern DECLSPEC SDL_BlendMode SDLCALL SDL_ComposeCustomBlendMode(SDL_BlendFactor srcColorFactor,
	#                                                                  SDL_BlendFactor dstColorFactor,
	#                                                                  SDL_BlendOperation colorOperation,
	#                                                                  SDL_BlendFactor srcAlphaFactor,
	#                                                                  SDL_BlendFactor dstAlphaFactor,
	#                                                                  SDL_BlendOperation alphaOperation);
	$ffi->attach( SDL_ComposeCustomBlendMode => [ 	'SDL_BlendFactor',
													'SDL_BlendFactor',
													'SDL_BlendOperation',
													'SDL_BlendFactor',
													'SDL_BlendFactor',
													'SDL_BlendOperation',
	] => 'SDL_BlendMode' );



}

1;
