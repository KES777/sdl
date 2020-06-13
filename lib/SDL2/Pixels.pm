package SDL2::Pixels;

use strict;
use warnings;

use SDL2::Stdinc;
use SDL2::Endian;

sub SDL_PIXELFORMAT_YUY2();
sub SDL_PIXELFORMAT_UYVY();
sub SDL_PIXELFORMAT_YVYU();
sub SDL_PIXELTYPE_UNKNOWN();
sub SDL_PIXELTYPE_INDEX1();
sub SDL_PIXELTYPE_INDEX4();
sub SDL_PIXELTYPE_INDEX8();
sub SDL_PIXELTYPE_PACKED8();
sub SDL_PIXELTYPE_PACKED16();
sub SDL_PIXELTYPE_PACKED32();
sub SDL_PIXELTYPE_ARRAYU8();
sub SDL_PIXELTYPE_ARRAYU16();
sub SDL_PIXELTYPE_ARRAYU32();
sub SDL_PIXELTYPE_ARRAYF16();
sub SDL_PIXELTYPE_ARRAYF32();

sub SDL_BITMAPORDER_NONE();
sub SDL_BITMAPORDER_4321();
sub SDL_BITMAPORDER_1234();

sub SDL_PACKEDORDER_NONE();
sub SDL_PACKEDORDER_XRGB();
sub SDL_PACKEDORDER_RGBX();
sub SDL_PACKEDORDER_ARGB();
sub SDL_PACKEDORDER_RGBA();
sub SDL_PACKEDORDER_XBGR();
sub SDL_PACKEDORDER_BGRX();
sub SDL_PACKEDORDER_ABGR();
sub SDL_PACKEDORDER_BGRA();

sub SDL_ARRAYORDER_NONE();
sub SDL_ARRAYORDER_RGB();
sub SDL_ARRAYORDER_RGBA();
sub SDL_ARRAYORDER_ARGB();
sub SDL_ARRAYORDER_BGR();
sub SDL_ARRAYORDER_BGRA();
sub SDL_ARRAYORDER_ABGR();

sub SDL_PACKEDLAYOUT_NONE();
sub SDL_PACKEDLAYOUT_332();
sub SDL_PACKEDLAYOUT_4444();
sub SDL_PACKEDLAYOUT_1555();
sub SDL_PACKEDLAYOUT_5551();
sub SDL_PACKEDLAYOUT_565();
sub SDL_PACKEDLAYOUT_8888();
sub SDL_PACKEDLAYOUT_2101010();
sub SDL_PACKEDLAYOUT_1010102();


sub SDL_PIXELFORMAT_RGBA8888();
sub SDL_PIXELFORMAT_ARGB8888();
sub SDL_PIXELFORMAT_BGRA8888();
sub SDL_PIXELFORMAT_ABGR8888();


#define SDL_ALPHA_OPAQUE 255
sub SDL_ALPHA_OPAQUE { 255 }

#define SDL_ALPHA_TRANSPARENT 0
sub SDL_ALPHA_TRANSPARENT { 0 }

#define SDL_DEFINE_PIXELFOURCC(A, B, C, D) SDL_FOURCC(A, B, C, D)
sub SDL_DEFINE_PIXELFOURCC {
	my( $A, $B, $C, $D ) =  @_;
	return SDL2::Stdinc::SDL_FOURCC( $A, $B, $C, $D );
}

# #define SDL_DEFINE_PIXELFORMAT(type, order, layout, bits, bytes) \
#     ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | \
#      ((bits) << 8) | ((bytes) << 0))
sub SDL_DEFINE_PIXELFORMAT {
	my( $type, $order, $layout, $bits, $bytes ) =  @_;

	return
    ((1 << 28) | (($type) << 24) | (($order) << 20) | (($layout) << 16) |
     (($bits) << 8) | (($bytes) << 0));
}

#define SDL_PIXELFLAG(X)    (((X) >> 28) & 0x0F)
sub SDL_PIXELFLAG {
	my( $X ) =  @_;
	return ((($X) >> 28) & 0x0F);
}

#define SDL_PIXELTYPE(X)    (((X) >> 24) & 0x0F)
sub SDL_PIXELTYPE {
	my( $X ) =  @_;
	return ((($X) >> 24) & 0x0F);
}

#define SDL_PIXELORDER(X)   (((X) >> 20) & 0x0F)
sub SDL_PIXELORDER {
	my( $X ) =  @_;
	return ((($X) >> 20) & 0x0F);
}

#define SDL_PIXELLAYOUT(X)  (((X) >> 16) & 0x0F)
sub SDL_PIXELLAYOUT {
	my( $X ) =  @_;
	return ((($X) >> 16) & 0x0F);
}

#define SDL_BITSPERPIXEL(X) (((X) >> 8) & 0xFF)
sub SDL_BITSPERPIXEL {
	my( $X ) =  @_;
	return ((($X) >> 8) & 0xFF);
}

# #define SDL_BYTESPERPIXEL(X) \
# (SDL_ISPIXELFORMAT_FOURCC(X) ? \
#     ((((X) == SDL_PIXELFORMAT_YUY2) || \
#       ((X) == SDL_PIXELFORMAT_UYVY) || \
#       ((X) == SDL_PIXELFORMAT_YVYU)) ? 2 : 1) : (((X) >> 0) & 0xFF))
sub SDL_BYTESPERPIXEL {
	my( $X ) =  @_;
	return (SDL_ISPIXELFORMAT_FOURCC($X) ?
		(((($X) == SDL_PIXELFORMAT_YUY2) ||
		(($X) == SDL_PIXELFORMAT_UYVY) ||
		(($X) == SDL_PIXELFORMAT_YVYU)) ? 2 : 1) : ((($X) >> 0) & 0xFF));
}

# #define SDL_ISPIXELFORMAT_INDEXED(format)   \
#     (!SDL_ISPIXELFORMAT_FOURCC(format) && \
#      ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX1) || \
#       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX4) || \
#       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX8)))
sub SDL_ISPIXELFORMAT_INDEXED {
	my( $format ) =  @_;
	return
		(!SDL_ISPIXELFORMAT_FOURCC($format) &&
		((SDL_PIXELTYPE($format) == SDL_PIXELTYPE_INDEX1) ||
		(SDL_PIXELTYPE($format) == SDL_PIXELTYPE_INDEX4) ||
		(SDL_PIXELTYPE($format) == SDL_PIXELTYPE_INDEX8)));
}

# #define SDL_ISPIXELFORMAT_PACKED(format) \
#     (!SDL_ISPIXELFORMAT_FOURCC(format) && \
#      ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED8) || \
#       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED16) || \
#       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED32)))
sub SDL_ISPIXELFORMAT_PACKED {
	my( $format ) =  @_;
	return
		(!SDL_ISPIXELFORMAT_FOURCC($format) &&
		((SDL_PIXELTYPE($format) == SDL_PIXELTYPE_PACKED8) ||
		(SDL_PIXELTYPE($format) == SDL_PIXELTYPE_PACKED16) ||
		(SDL_PIXELTYPE($format) == SDL_PIXELTYPE_PACKED32)));
}

# #define SDL_ISPIXELFORMAT_ARRAY(format) \
#     (!SDL_ISPIXELFORMAT_FOURCC(format) && \
#      ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU8) || \
#       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU16) || \
#       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU32) || \
#       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF16) || \
#       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF32)))
sub SDL_ISPIXELFORMAT_ARRAY {
	my( $format ) =  @_;
	return
		(!SDL_ISPIXELFORMAT_FOURCC($format) &&
		((SDL_PIXELTYPE($format) == SDL_PIXELTYPE_ARRAYU8) ||
		(SDL_PIXELTYPE($format) == SDL_PIXELTYPE_ARRAYU16) ||
		(SDL_PIXELTYPE($format) == SDL_PIXELTYPE_ARRAYU32) ||
		(SDL_PIXELTYPE($format) == SDL_PIXELTYPE_ARRAYF16) ||
		(SDL_PIXELTYPE($format) == SDL_PIXELTYPE_ARRAYF32)));
}

# #define SDL_ISPIXELFORMAT_ALPHA(format)   \
#     ((SDL_ISPIXELFORMAT_PACKED(format) && \
#      ((SDL_PIXELORDER(format) == SDL_PACKEDORDER_ARGB) || \
#       (SDL_PIXELORDER(format) == SDL_PACKEDORDER_RGBA) || \
#       (SDL_PIXELORDER(format) == SDL_PACKEDORDER_ABGR) || \
#       (SDL_PIXELORDER(format) == SDL_PACKEDORDER_BGRA))) || \
#     (SDL_ISPIXELFORMAT_ARRAY(format) && \
#      ((SDL_PIXELORDER(format) == SDL_ARRAYORDER_ARGB) || \
#       (SDL_PIXELORDER(format) == SDL_ARRAYORDER_RGBA) || \
#       (SDL_PIXELORDER(format) == SDL_ARRAYORDER_ABGR) || \
#       (SDL_PIXELORDER(format) == SDL_ARRAYORDER_BGRA))))
sub SDL_ISPIXELFORMAT_ALPHA {
	my( $format ) =  @_;
	return
		((SDL_ISPIXELFORMAT_PACKED($format) &&
		((SDL_PIXELORDER($format) == SDL_PACKEDORDER_ARGB) ||
		(SDL_PIXELORDER($format) == SDL_PACKEDORDER_RGBA) ||
		(SDL_PIXELORDER($format) == SDL_PACKEDORDER_ABGR) ||
		(SDL_PIXELORDER($format) == SDL_PACKEDORDER_BGRA))) ||
		(SDL_ISPIXELFORMAT_ARRAY($format) &&
		((SDL_PIXELORDER($format) == SDL_ARRAYORDER_ARGB) ||
		(SDL_PIXELORDER($format) == SDL_ARRAYORDER_RGBA) ||
		(SDL_PIXELORDER($format) == SDL_ARRAYORDER_ABGR) ||
		(SDL_PIXELORDER($format) == SDL_ARRAYORDER_BGRA))));
}

# #define SDL_ISPIXELFORMAT_FOURCC(format)    \
#     ((format) && (SDL_PIXELFLAG(format) != 1))
sub SDL_ISPIXELFORMAT_FOURCC {
	my( $format ) =  @_;
	return (($format) && (SDL_PIXELFLAG($format) != 1));
}


my $processed;
sub attach {
	!$processed   or return;
	$processed++;


	my( $ffi ) =  @_;

	$ffi->type( 'opaque' => 'SDL_PixelFormat_ptr' );
	$ffi->type( 'opaque' => 'SDL_Palette_ptr' );
	$ffi->type( 'opaque' => 'SDL_Color_ptr' );

	SDL2::Stdinc::attach( $ffi );
	SDL2::Endian::attach( $ffi );

	# enum
	# {
	#     SDL_PIXELTYPE_UNKNOWN,
	#     SDL_PIXELTYPE_INDEX1,
	#     SDL_PIXELTYPE_INDEX4,
	#     SDL_PIXELTYPE_INDEX8,
	#     SDL_PIXELTYPE_PACKED8,
	#     SDL_PIXELTYPE_PACKED16,
	#     SDL_PIXELTYPE_PACKED32,
	#     SDL_PIXELTYPE_ARRAYU8,
	#     SDL_PIXELTYPE_ARRAYU16,
	#     SDL_PIXELTYPE_ARRAYU32,
	#     SDL_PIXELTYPE_ARRAYF16,
	#     SDL_PIXELTYPE_ARRAYF32
	# };
	$ffi->load_custom_type('::Enum', 'SDL_a',
		{ ret => 'int', package => 'SDL2::Pixels' },
		'SDL_PIXELTYPE_UNKNOWN',
		'SDL_PIXELTYPE_INDEX1',
		'SDL_PIXELTYPE_INDEX4',
		'SDL_PIXELTYPE_INDEX8',
		'SDL_PIXELTYPE_PACKED8',
		'SDL_PIXELTYPE_PACKED16',
		'SDL_PIXELTYPE_PACKED32',
		'SDL_PIXELTYPE_ARRAYU8',
		'SDL_PIXELTYPE_ARRAYU16',
		'SDL_PIXELTYPE_ARRAYU32',
		'SDL_PIXELTYPE_ARRAYF16',
		'SDL_PIXELTYPE_ARRAYF32',
	);

# SDL::Pixels::SDL_PIXELTYPE_INDEX8 # KES


	# enum
	# {
	#     SDL_BITMAPORDER_NONE,
	#     SDL_BITMAPORDER_4321,
	#     SDL_BITMAPORDER_1234
	# };
	$ffi->load_custom_type('::Enum', 'SDL_b',
		{ ret => 'int', package => 'SDL2::Pixels' },
		'SDL_BITMAPORDER_NONE',
		'SDL_BITMAPORDER_4321',
		'SDL_BITMAPORDER_1234',
	);

	# enum
	# {
	#     SDL_PACKEDORDER_NONE,
	#     SDL_PACKEDORDER_XRGB,
	#     SDL_PACKEDORDER_RGBX,
	#     SDL_PACKEDORDER_ARGB,
	#     SDL_PACKEDORDER_RGBA,
	#     SDL_PACKEDORDER_XBGR,
	#     SDL_PACKEDORDER_BGRX,
	#     SDL_PACKEDORDER_ABGR,
	#     SDL_PACKEDORDER_BGRA
	# };
	$ffi->load_custom_type('::Enum', 'SDL_c',
		{ ret => 'int', package => 'SDL2::Pixels' },
		'SDL_PACKEDORDER_NONE',
		'SDL_PACKEDORDER_XRGB',
		'SDL_PACKEDORDER_RGBX',
		'SDL_PACKEDORDER_ARGB',
		'SDL_PACKEDORDER_RGBA',
		'SDL_PACKEDORDER_XBGR',
		'SDL_PACKEDORDER_BGRX',
		'SDL_PACKEDORDER_ABGR',
		'SDL_PACKEDORDER_BGRA',
	);

	# enum
	# {
	#     SDL_ARRAYORDER_NONE,
	#     SDL_ARRAYORDER_RGB,
	#     SDL_ARRAYORDER_RGBA,
	#     SDL_ARRAYORDER_ARGB,
	#     SDL_ARRAYORDER_BGR,
	#     SDL_ARRAYORDER_BGRA,
	#     SDL_ARRAYORDER_ABGR
	# };
	$ffi->load_custom_type('::Enum', 'SDL_d',
		{ ret => 'int', package => 'SDL2::Pixels' },
		'SDL_ARRAYORDER_NONE',
		'SDL_ARRAYORDER_RGB',
		'SDL_ARRAYORDER_RGBA',
		'SDL_ARRAYORDER_ARGB',
		'SDL_ARRAYORDER_BGR',
		'SDL_ARRAYORDER_BGRA',
		'SDL_ARRAYORDER_ABGR',
	);

	# enum
	# {
	#     SDL_PACKEDLAYOUT_NONE,
	#     SDL_PACKEDLAYOUT_332,
	#     SDL_PACKEDLAYOUT_4444,
	#     SDL_PACKEDLAYOUT_1555,
	#     SDL_PACKEDLAYOUT_5551,
	#     SDL_PACKEDLAYOUT_565,
	#     SDL_PACKEDLAYOUT_8888,
	#     SDL_PACKEDLAYOUT_2101010,
	#     SDL_PACKEDLAYOUT_1010102
	# };
	$ffi->load_custom_type('::Enum', 'SDL_e',
		{ ret => 'int', package => 'SDL2::Pixels' },
		'SDL_PACKEDLAYOUT_NONE',
		'SDL_PACKEDLAYOUT_332',
		'SDL_PACKEDLAYOUT_4444',
		'SDL_PACKEDLAYOUT_1555',
		'SDL_PACKEDLAYOUT_5551',
		'SDL_PACKEDLAYOUT_565',
		'SDL_PACKEDLAYOUT_8888',
		'SDL_PACKEDLAYOUT_2101010',
		'SDL_PACKEDLAYOUT_1010102',
	);


$ffi->load_custom_type('::Enum', 'SDL_PixelFormatEnum',
	{ ret => 'int', package => 'SDL2::Pixels' },
	'SDL_PIXELFORMAT_UNKNOWN',

		[ SDL_PIXELFORMAT_INDEX1LSB => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_INDEX1, SDL2::Pixels::SDL_BITMAPORDER_4321, 0, 1, 0
		)],

		[ SDL_PIXELFORMAT_INDEX1MSB => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_INDEX1, SDL2::Pixels::SDL_BITMAPORDER_1234, 0, 1, 0
		)],

		[ SDL_PIXELFORMAT_INDEX4LSB => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_INDEX4, SDL2::Pixels::SDL_BITMAPORDER_4321, 0, 4, 0
		)],

	    [ SDL_PIXELFORMAT_INDEX4MSB => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_INDEX4, SDL2::Pixels::SDL_BITMAPORDER_1234, 0, 4, 0
		)],

	    [ SDL_PIXELFORMAT_INDEX8 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_INDEX8, 0, 0, 8, 1
		)],

	    [ SDL_PIXELFORMAT_RGB332 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED8, SDL2::Pixels::SDL_PACKEDORDER_XRGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_332, 8, 1
		)],

	    [ SDL_PIXELFORMAT_RGB444 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_XRGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_4444, 12, 2
		)],

	    [ SDL_PIXELFORMAT_RGB555 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_XRGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_1555, 15, 2
		)],

	    [ SDL_PIXELFORMAT_BGR555 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_XBGR,
			SDL2::Pixels::SDL_PACKEDLAYOUT_1555, 15, 2
		)],

	    [ SDL_PIXELFORMAT_ARGB4444 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_ARGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_4444, 16, 2
		)],

	    [ SDL_PIXELFORMAT_RGBA4444 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_RGBA,
			SDL2::Pixels::SDL_PACKEDLAYOUT_4444, 16, 2
		)],

	    [ SDL_PIXELFORMAT_ABGR4444 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_ABGR,
			SDL2::Pixels::SDL_PACKEDLAYOUT_4444, 16, 2
		)],

	    [ SDL_PIXELFORMAT_BGRA4444 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_BGRA,
			SDL2::Pixels::SDL_PACKEDLAYOUT_4444, 16, 2
		)],

	    [ SDL_PIXELFORMAT_ARGB1555 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_ARGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_1555, 16, 2
		)],

	    [ SDL_PIXELFORMAT_RGBA5551 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_RGBA,
			SDL2::Pixels::SDL_PACKEDLAYOUT_5551, 16, 2
		)],

	    [ SDL_PIXELFORMAT_ABGR1555 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_ABGR,
			SDL2::Pixels::SDL_PACKEDLAYOUT_1555, 16, 2
		)],

	    [ SDL_PIXELFORMAT_BGRA5551 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_BGRA,
			SDL2::Pixels::SDL_PACKEDLAYOUT_5551, 16, 2
		)],

	    [ SDL_PIXELFORMAT_RGB565 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_XRGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_565, 16, 2
		)],

	    [ SDL_PIXELFORMAT_BGR565 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED16, SDL2::Pixels::SDL_PACKEDORDER_XBGR,
			SDL2::Pixels::SDL_PACKEDLAYOUT_565, 16, 2
		)],

		[ SDL_PIXELFORMAT_RGB24 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_ARRAYU8, SDL2::Pixels::SDL_ARRAYORDER_RGB, 0, 24, 3
		)],

		[ SDL_PIXELFORMAT_BGR24 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_ARRAYU8, SDL2::Pixels::SDL_ARRAYORDER_BGR, 0, 24, 3
		)],

	    [ SDL_PIXELFORMAT_RGB888 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_XRGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_8888, 24, 4
		)],

	    [ SDL_PIXELFORMAT_RGBX8888 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_RGBX,
			SDL2::Pixels::SDL_PACKEDLAYOUT_8888, 24, 4
		)],

	    [ SDL_PIXELFORMAT_BGR888 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_XBGR,
			SDL2::Pixels::SDL_PACKEDLAYOUT_8888, 24, 4
		)],

	    [ SDL_PIXELFORMAT_BGRX8888 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_BGRX,
			SDL2::Pixels::SDL_PACKEDLAYOUT_8888, 24, 4
		)],

	    [ SDL_PIXELFORMAT_ARGB8888 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_ARGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_8888, 32, 4
		)],

    [ SDL_PIXELFORMAT_RGBA8888 => SDL_DEFINE_PIXELFORMAT(
		SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_RGBA,
		SDL2::Pixels::SDL_PACKEDLAYOUT_8888, 32, 4
	)],

	    [ SDL_PIXELFORMAT_ABGR8888 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_ABGR,
			SDL2::Pixels::SDL_PACKEDLAYOUT_8888, 32, 4
		)],

	    [ SDL_PIXELFORMAT_BGRA8888 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_BGRA,
			SDL2::Pixels::SDL_PACKEDLAYOUT_8888, 32, 4
		)],

	    [ SDL_PIXELFORMAT_ARGB2101010 => SDL_DEFINE_PIXELFORMAT(
			SDL2::Pixels::SDL_PIXELTYPE_PACKED32, SDL2::Pixels::SDL_PACKEDORDER_ARGB,
			SDL2::Pixels::SDL_PACKEDLAYOUT_2101010, 32, 4
		)],
		# #if SDL_BYTEORDER == SDL_BIG_ENDIAN
		#     SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_RGBA8888,
		#     SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_ARGB8888,
		#     SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_BGRA8888,
		#     SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_ABGR8888,
		# #else
		#     SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_ABGR8888,
		#     SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_BGRA8888,
		#     SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_ARGB8888,
		#     SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_RGBA8888,
		# #endif
		SDL2::Endian::SDL_BYTEORDER == SDL2::Endian::SDL_BIG_ENDIAN? (
		    sub{ [SDL_PIXELFORMAT_RGBA32 => SDL_PIXELFORMAT_RGBA8888] },
		    sub{ [SDL_PIXELFORMAT_ARGB32 => SDL_PIXELFORMAT_ARGB8888] },
		    sub{ [SDL_PIXELFORMAT_BGRA32 => SDL_PIXELFORMAT_BGRA8888] },
		    sub{ [SDL_PIXELFORMAT_ABGR32 => SDL_PIXELFORMAT_ABGR8888] },
		) : (
		    sub{ [SDL_PIXELFORMAT_RGBA32 => SDL_PIXELFORMAT_ABGR8888] },
		    sub{ [SDL_PIXELFORMAT_ARGB32 => SDL_PIXELFORMAT_BGRA8888] },
		    sub{ [SDL_PIXELFORMAT_BGRA32 => SDL_PIXELFORMAT_ARGB8888] },
		    sub{ [SDL_PIXELFORMAT_ABGR32 => SDL_PIXELFORMAT_RGBA8888] },
		),

	    [ SDL_PIXELFORMAT_YV12 =>
		    SDL_DEFINE_PIXELFOURCC('Y', 'V', '1', '2')],

		[ SDL_PIXELFORMAT_IYUV =>
		    SDL_DEFINE_PIXELFOURCC('I', 'Y', 'U', 'V')],

		[ SDL_PIXELFORMAT_YUY2 =>
		    SDL_DEFINE_PIXELFOURCC('Y', 'U', 'Y', '2')],

		[ SDL_PIXELFORMAT_UYVY =>
		    SDL_DEFINE_PIXELFOURCC('U', 'Y', 'V', 'Y')],

		[ SDL_PIXELFORMAT_YVYU =>
		    SDL_DEFINE_PIXELFOURCC('Y', 'V', 'Y', 'U')],

		[ SDL_PIXELFORMAT_NV12 =>
		    SDL_DEFINE_PIXELFOURCC('N', 'V', '1', '2')],

		[ SDL_PIXELFORMAT_NV21 =>
		    SDL_DEFINE_PIXELFOURCC('N', 'V', '2', '1')],

		[ SDL_PIXELFORMAT_EXTERNAL_OES =>
		    SDL_DEFINE_PIXELFOURCC('O', 'E', 'S', ' ')],
	);


	# extern DECLSPEC const char* SDLCALL SDL_GetPixelFormatName(Uint32 format);
	$ffi->attach( SDL_GetPixelFormatName  => [ 'uint32' ] => 'string'  );


	# extern DECLSPEC SDL_bool SDLCALL SDL_PixelFormatEnumToMasks(Uint32 format,
	#                                                             int *bpp,
	#                                                             Uint32 * Rmask,
	#                                                             Uint32 * Gmask,
	#                                                             Uint32 * Bmask,
	#                                                             Uint32 * Amask);
	$ffi->attach( SDL_PixelFormatEnumToMasks  => [ 'uint32', 'int', 'uint32*', 'uint32*', 'uint32*', 'uint32*' ] => 'SDL_bool'  );


	# extern DECLSPEC Uint32 SDLCALL SDL_MasksToPixelFormatEnum(int bpp,
	#                                                           Uint32 Rmask,
	#                                                           Uint32 Gmask,
	#                                                           Uint32 Bmask,
	#                                                           Uint32 Amask);
	$ffi->attach( SDL_MasksToPixelFormatEnum  => [ 'int', 'uint32*', 'uint32*', 'uint32*', 'uint32*' ] => 'uint32'  );


	# extern DECLSPEC void SDLCALL SDL_FreeFormat(SDL_PixelFormat *format);
	$ffi->attach( SDL_FreeFormat  => [ 'SDL_PixelFormat_ptr' ] => 'void'  );


	# extern DECLSPEC SDL_Palette *SDLCALL SDL_AllocPalette(int ncolors);
	$ffi->attach( SDL_AllocPalette  => [ 'int' ] => 'SDL_Palette_ptr'  );


	# extern DECLSPEC int SDLCALL SDL_SetPixelFormatPalette(SDL_PixelFormat * format,
	#                                                       SDL_Palette *palette);
	$ffi->attach( SDL_SetPixelFormatPalette  => [ 'SDL_PixelFormat_ptr', 'SDL_Palette_ptr' ] => 'int'  );


	# extern DECLSPEC int SDLCALL SDL_SetPaletteColors(SDL_Palette * palette,
	#                                                  const SDL_Color * colors,
	#                                                  int firstcolor, int ncolors);
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
	$ffi->attach( SDL_CalculateGammaRamp  => [ 'float', 'uint16*' ] => 'void'  );

}

1;
