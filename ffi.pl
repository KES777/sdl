use strict;
use warnings;

use FFI::Platypus;
use FFI::CheckLib qw/ find_lib_or_exit /;



my $ffi = FFI::Platypus->new( api => 1 );
# OLD -> new
# /usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0.8.0
# /usr/local/lib/libSDL2-2.0.so.0.10.0
$ffi->find_lib( lib => 'SDL2' );


use SDL2::SDL;
SDL2::SDL::attach( $ffi );



# SDL_INIT_VIDEO    0x00000020;   #Инициализирует видеоподсистему.
if( SDL_Init( 0x00000020 ) < 0 ) {
    die "nable to initialize SDL";
}
my $res =  SDL_Init( 0x00000020 );
print 'SDL_INIT_VIDEO  -->> ', $res,"\n";



    # //The surface contained by the window
    # SDL_Surface* screenSurface = NULL;
    # window = SDL_CreateWindow( "SDL Tutorial",
    #   SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH,
    #   SCREEN_HEIGHT, SDL_WINDOW_SHOWN
    # );

# extern DECLSPEC SDL_Window * SDLCALL SDL_CreateWindow(const char *title,
                                                     # int x, int y, int w,
                                                     # int h, Uint32 flags);

$ffi->type( 'opaque' => 'SDL_Window_ptr' );
$ffi->attach( SDL_CreateWindow => [ 'string', 'int','int','int','int','uint32' ] => 'SDL_Window_ptr' );

# //The window we'll be rendering to
# SDL_Window* window = NULL;
my $window =  SDL_CreateWindow( 'Hello', 100, 100, 300, 200, 0x00000004 );

#extern DECLSPEC SDL_Surface * SDLCALL SDL_GetWindowSurface(SDL_Window * window);
$ffi->type( 'opaque' => 'SDL_Surface_ptr' );
$ffi->attach( SDL_GetWindowSurface => [ 'SDL_Window_ptr' ] => 'SDL_Surface_ptr' );

#screenSurface = SDL_GetWindowSurface( window );
my $screenSurface =  SDL_GetWindowSurface( $window );

# extern DECLSPEC int SDLCALL SDL_FillRect
#    (SDL_Surface * dst, const SDL_Rect * rect, Uint32 color);
$ffi->type( 'opaque' => 'SDL_Rect_ptr' );
$ffi->attach( SDL_FillRect => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'uint32' ] => 'int' );

# extern DECLSPEC Uint32 SDLCALL SDL_MapRGB(const SDL_PixelFormat * format,
#                                          Uint8 r, Uint8 g, Uint8 b);
$ffi->type( 'opaque' => 'SDL_PixelFormat_ptr' );
$ffi->attach( SDL_MapRGB => [ 'SDL_PixelFormat_ptr', 'uint8', 'uint8', 'uint8' ] => 'uint32' );

# SDL_MapRGB( screenSurface->format, 0xFF, 0xFF, 0xFF )
# my $color =  SDL_MapRGB( $screenSurface->format, 0xFF, 0xFF, 0xFF );
# XXXXXX

#SDL_FillRect( screenSurface, NULL, $color );
SDL_FillRect( $screenSurface, undef, 0x00FF0000 );

# extern DECLSPEC int SDLCALL SDL_UpdateWindowSurface(SDL_Window * window);
$ffi->attach( SDL_UpdateWindowSurface => [ 'SDL_Window_ptr' ] => 'int' );

# SDL_UpdateWindowSurface( window );
SDL_UpdateWindowSurface( $window );

#extern DECLSPEC void SDLCALL SDL_Delay(Uint32 ms);
$ffi->attach( SDL_Delay => [ 'uint32' ] => 'void' );

# SDL_Delay( 2000 );
SDL_Delay( 2000 );

# sleep 5;

__END__

# typedef enum {
use constant {
    # SDL_GL_RED_SIZE,
    SDL_GL_RED_SIZE => 0,
    # SDL_GL_GREEN_SIZE,
    SDL_GL_GREEN_SIZE => 1,
    # SDL_GL_BLUE_SIZE,
    # SDL_GL_ALPHA_SIZE,
    # SDL_GL_BUFFER_SIZE,
    # SDL_GL_DOUBLEBUFFER,
    # SDL_GL_DEPTH_SIZE,
    # SDL_GL_STENCIL_SIZE,
    # SDL_GL_ACCUM_RED_SIZE,
    # SDL_GL_ACCUM_GREEN_SIZE,
    # SDL_GL_ACCUM_BLUE_SIZE,
    # SDL_GL_ACCUM_ALPHA_SIZE,
    # SDL_GL_STEREO,
    # SDL_GL_MULTISAMPLEBUFFERS,
    # SDL_GL_MULTISAMPLESAMPLES,
    # SDL_GL_ACCELERATED_VISUAL,
    # SDL_GL_SWAP_CONTROL
# } SDL_GLattr;
};
$ffi->type( 'enum' => 'SDL_GLattr' );



{
    package SDL_Rect;

    use FFI::Platypus::Record;
    record_layout_1( qw (
        int    Sint16 x, y;
        int    Uint16 w, h;
    ));

    # my $ffi = FFI::Platypus->new( api => 1 );
    # $ffi->lib( 'SDL2' );
    $ffi->type("record(SDL_Rect)*" => 'my_sdl_rect');

}



{
    package SDL_Color;

    use FFI::Platypus::Record;
    record_layout_1( qw (
        Uint8 r
        Uint8 g
        Uint8 b
        Uint8 unused
    ));


    # my $ffi = FFI::Platypus->new( api => 1 );
    # $ffi->lib( 'SDL2' );
    # define a record class My::UnixTime and alias it to "tm"
    $ffi->type("record(SDL_Color)*" => 'SDL_Color_ptr');

    # $ffi->type("record(SDL_Color)" => 'SDL_Color_t');
    # $ffi->type("SDL_Color_t*");

    # attach the C localtime function as a constructor
    # $ffi->attach( localtime => ['time_t*'] => 'my_sdl_color', sub {
    #   my($inner, $class, $time) = @_;
    #   $time = time unless defined $time;
    #   $inner->(\$time);
    # });
}




{
    package SDL_Palette;

    use FFI::Platypus::Record;
    record_layout_1( qw (
        int       ncolors;
        SDL_Color *colors;
    ));

    # my $ffi = FFI::Platypus->new( api => 1 );
    # $ffi->lib( 'SDL2' );
    $ffi->type("record(SDL_Palette)*" => 'my_sdl_palette');

}



{
    package SDL_PixelFormat;

    use FFI::Platypus::Record;
    record_layout_1( qw (
        SDL_Palette *palette;
        Uint8  BitsPerPixel;
        Uint8  BytesPerPixel;
        Uint8  Rloss;
        Uint8  Gloss;
        Uint8  Bloss;
        Uint8  Aloss;
        Uint8  Rshift;
        Uint8  Gshift;
        Uint8  Bshift;
        Uint8  Ashift;
        Uint32 Rmask;
        Uint32 Gmask;
        Uint32 Bmask;
        Uint32 Amask;
        Uint32 colorkey;
        Uint8  alpha;
    ));

    # my $ffi = FFI::Platypus->new( api => 1 );
    # $ffi->lib( 'SDL2' );
    $ffi->type("record(SDL_PixelFormat)*" => 'my_sdl_pixelformat');
}


{
    package SDL_Surface;

    use FFI::Platypus::Record;
    record_layout_1( qw (
        Uint32 flags;
        SDL_PixelFormat *format;
        int w, h;
        Uint16 pitch;
        void *pixels;
        int offset;
        struct private_hwdata *hwdata;
        SDL_Rect clip_rect;
        Uint32 unused1;
        Uint32 locked;
        struct SDL_BlitMap *map;
        unsigned int format_version;
        int refcount;
    ));


    # my $ffi = FFI::Platypus->new( api => 1 );
    # $ffi->lib( 'SDL2' );
    DB::x;
    $ffi->type("record(SDL_Surface)*" => 'my_sdl_surface');
}



# SDL_SetVideoMode       -  Устанавливает режим видео с указанными шириной, высотой и битами на пиксель.
# SDL_GetVideoSurface    -  возвращает указатель на текущую поверхность дисплея
# SDL_Surface            -  Графическая структура поверхности

# SDL_Surface представляет области «графической» памяти,
# в которую можно рисовать. Кадр буфера видео возвращается как SDL_Surface
# с помощью SDL_SetVideoMode и SDL_GetVideoSurface.
# Большинство полей должно быть довольно очевидным. w и h - ширина и высота
# поверхности в пикселях.
# Пиксели - это указатель на фактические данные о пикселях,
# поверхность должна быть заблокирована перед доступом к этому полю.
# Поле clip_rect является отсеченным прямоугольником,
# как установлено SDL_SetClipRect.

# SDL_CreateRGBSurface   -  Создаёт пустой SDL_Surface
# SDL_Color              -  Форматно-независимое описание цвета
# SDL_Palette            -  Цветовая палитра для 8-битных форматов пикселей


# $ffi->attach( SDL_VideoInit         => [ 'const char', 'Uint32' ]        => 'int' );
# $ffi->attach( SDL_VideoQuit         => [ 'void' ]                        => 'void' );
# $ffi->attach( SDL_VideoDriverName   => [ 'char', 'int' ]                 => 'char' );
# $ffi->attach( SDL_GetVideoSurface   => [ 'void' ]                        => 'SDL_Surface' );
# $ffi->attach( SDL_GetVideoInfo      => [ 'void' ]                        => 'const SDL_VideoInfo' );
# $ffi->attach( SDL_VideoModeOK       => [ 'int', 'int', 'int', 'Uint32' ] => 'int' );
# $ffi->attach( SDL_ListModes         => [ 'SDL_PixelFormat', 'Uint32' ]   => 'SDL_Rect' );

# extern DECLSPEC SDL_Surface * SDLCALL SDL_SetVideoMode
#             (int width, int height, int bpp, Uint32 flags);

$ffi->attach( SDL_SetVideoMode      => [ 'int', 'int', 'int', 'uint32' ] => 'SDL_Surface' );
# DB::x;
my $SDL_SWSURFACE = SDL_SetVideoMode( 0x00000000 );
print 'SDL_SWSURFACE  -->> ', $SDL_SWSURFACE,"\n";
__END__

# SDL_SWSURFACE   0x00000000;  #Создать видео поверхность в системной памяти
# SDL_HWSURFACE   0x00000001;  #Создайте видео поверхность в видео памяти
# SDL_ASYNCBLIT   0x00000004;  #Позволяет использовать асинхронные обновления поверхности дисплея
# SDL_ANYFORMAT   0x10000000;  #будет эмулировать поверхность с теневой поверхностью
# SDL_HWPALETTE   0x20000000;  #Без этого флага вы не всегда можете получить цвета, которые вы запрашиваете с помощью SDL_SetColors или SDL_SetPalette
# SDL_DOUBLEBUF   0x40000000;  #Включить аппаратную двойную буферизацию
# SDL_FULLSCREEN  0x80000000;  #попытается использовать полноэкранный режим
# SDL_OPENGL      0x00000002;  #Создайте контекст рендеринга OpenGL. Вы должны были предварительно установить атрибуты видео OpenGL с SDL_GL_SetAttribute
# SDL_OPENGLBLIT  0x0000000A;  #Поверхность поддерживает блинтинг OpenGL (Display Surface)
# SDL_RESIZABLE   0x00000010;  #Поверхность изменяемого размера

# SDL_HWACCEL     0x00000100;  #Поверхностный блиц использует аппаратное ускорение
# SDL_SRCCOLORKEY 0x00001000;  #Поверхностное использование красок
# SDL_RLEACCELOK  0x00002000;  #
# SDL_RLEACCEL    0x00004000;  #Разгорание цветных клавиш ускоряется с помощью RLE
# SDL_SRCALPHA    0x00010000;  #Поверхностный блиц использует альфа-смешение
# SDL_PREALLOC    0x01000000;  #Поверхность использует предварительно выделенную память
# SDL_NOFRAME     0x00000020;  #

# fn( char * zzzz );
# SDL_GL_SetAttribute




# print SDL_InitSubSystem ();






# use FFI::Platypus::Record;


# my $ffi = FFI::Platypus->new;
# $ffi->find_lib( lib => 'SDL2' );

# $ffi->type("record(SDL_Color)*" => '');

# my @color = $ffi->attach( SDL_Color => [ 'int', 'int', 'int', 'int' ] =>  'int', 'int', 'int', 'int' );


# use FFI::Platypus;
# use FFI::Platypus::Record;
# # record_layout ( qw (
# #  SDL_Color ( qw (
# #     int    Uint8 r
# #     int    Uint8 g
# #     int    Uint8 b
# #     int    Uint8 unused
# # ));
# my $ffi = FFI::Platypus->new;
# $ffi->find_lib( lib => 'SDL2' );
# DB::x;
# # $ffi->type("(SDL_Color)*" => '');
# my @fd = $ffi->attach(SDL_Color => ['int[4]'] => 'int');

# my($fd1,$fd2,$fd3,$fd4) = @fd;

# print "$fd[0] $fd[1] $fd[2] $fd[3]\n";



# my $ffi = FFI::Platypus->new;
# $ffi->lib(undef);
# $ffi->attach([pipe=>'mypipe'] => ['int[2]'] => 'int');

# my @fd = (0,0);
# mypipe(\@fd);
# my($fd1,$fd2) = @fd;

# print "$fd1 $fd2\n";


# extern DECLSPEC void SDLCALL SDL_UpdateRect
        (?# (SDL_Surface *screen, Sint32 x, Sint32 y, Uint32 w, Uint32 h);)

$ffi->attach( SDL_UpdateRects    => [ 'SDL_Surface', 'int', 'SDL_Rect' ]  => 'void' );
$ffi->attach( SDL_UpdateRect     => [ 'SDL_Surface', 'Sint32 x', 'Sint32 y', 'Uint32 w', 'Uint32 h' ]  => 'void' );
$ffi->attach( SDL_Flip           => [ 'SDL_Surface' ]  => 'int' );
$ffi->attach( SDL_SetGamma       => [ 'float red', 'float green', 'float blue' ]  => 'int' );

# extern DECLSPEC int SDLCALL SDL_SetGammaRamp(const Uint16 *red, const Uint16 *green, const Uint16 *blue);

$ffi->attach( SDL_SetGammaRamp   => [ 'const Uint16 *red', 'const Uint16 *green', 'const Uint16 *blue' ]  => 'int' );
$ffi->attach( SDL_GetGammaRamp   => [ 'Uint16 *red', 'Uint16 *green', 'Uint16 *blue' ]  => 'int' );
$ffi->attach( SDL_SetColors      => [ 'SDL_Surface', 'SDL_Color', 'int', 'int' ]  => 'int' );
$ffi->attach( SDL_SetPalette     => [ 'SDL_Surface', 'int', 'SDL_Color', 'int', 'int' ]  => 'int' );
$ffi->attach( SDL_MapRGB         => [ 'const SDL_PixelFormat', 'const Uint8 r', 'const Uint8 g', 'const Uint8 b' ]  => 'Uint32' );
$ffi->attach( SDL_MapRGBA        => [ 'const SDL_PixelFormat', 'const Uint8 r', 'const Uint8 g', 'const Uint8 b', 'const Uint8 a' ]  => 'Uint32' );
$ffi->attach( SDL_GetRGB         => [ 'Uint32', 'const SDL_PixelFormat', 'Uint8', 'Uint8', 'Uint8' ]  => 'void' );
$ffi->attach( SDL_GetRGBA        => [ 'Uint32', 'const SDL_PixelFormat', 'Uint8', 'Uint8', 'Uint8', 'Uint8' ]  => 'void' );

#define SDL_AllocSurface    SDL_CreateRGBSurface
SDL_AllocSurface ( SDL_CreateRGBSurface );

$ffi->attach( SDL_CreateRGBSurface     => [ 'Uint32', 'int', 'int', 'int', 'Uint32', 'Uint32', 'Uint32', 'Uint32', ]  => 'SDL_Surface' );
$ffi->attach( SDL_CreateRGBSurfaceFrom => [ 'void', 'int', 'int', 'int', 'int', 'Uint32', 'Uint32', 'Uint32', 'Uint32', ]  => 'SDL_Surface' );
$ffi->attach( SDL_FreeSurface          => [ 'SDL_Surface' ]  => 'void' );
$ffi->attach( SDL_LockSurface          => [ 'SDL_Surface' ]  => 'int' );
$ffi->attach( SDL_UnlockSurface        => [ 'SDL_Surface' ]  => 'void' );
$ffi->attach( SDL_LoadBMP_RW           => [ 'SDL_RWops', 'int' ]  => 'SDL_Surface' );

#define SDL_LoadBMP(file)   SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1)

$ffi->attach( SDL_SaveBMP_RW           => [ 'SDL_Surface', 'SDL_RWops', 'int' ]  => 'int' );

#define SDL_SaveBMP(surface, file) \
        # SDL_SaveBMP_RW(surface, SDL_RWFromFile(file, "wb"), 1)

$ffi->attach( SDL_SetColorKey          => [ 'SDL_Surface', 'Uint32', 'Uint32' ]  => 'int' );
$ffi->attach( SDL_SetAlpha             => [ 'SDL_Surface', 'Uint32', 'Uint8' ]  => 'int' );
$ffi->attach( SDL_SetClipRect          => [ 'SDL_Surface', 'const SDL_Rect', ]  => 'SDL_bool' );
$ffi->attach( SDL_GetClipRect          => [ 'SDL_Surface', 'SDL_Rect', ]  => 'void' );
$ffi->attach( SDL_ConvertSurface       => [ 'SDL_Surface', 'SDL_PixelFormat', 'Uint32' ]  => 'SDL_Surface' );



#define SDL_BlitSurface SDL_UpperBlit


extern DECLSPEC int SDLCALL SDL_UpperBlit
            (SDL_Surface *src, SDL_Rect *srcrect,
             SDL_Surface *dst, SDL_Rect *dstrect);

extern DECLSPEC int SDLCALL SDL_LowerBlit
            (SDL_Surface *src, SDL_Rect *srcrect,
             SDL_Surface *dst, SDL_Rect *dstrect);


extern DECLSPEC int SDLCALL SDL_FillRect
        (SDL_Surface *dst, SDL_Rect *dstrect, Uint32 color);

extern DECLSPEC SDL_Surface * SDLCALL SDL_DisplayFormat(SDL_Surface *surface);


extern DECLSPEC SDL_Surface * SDLCALL SDL_DisplayFormatAlpha(SDL_Surface *surface);


extern DECLSPEC SDL_Overlay * SDLCALL SDL_CreateYUVOverlay(int width, int height,
                Uint32 format, SDL_Surface *display);

extern DECLSPEC int SDLCALL SDL_LockYUVOverlay(SDL_Overlay *overlay);

extern DECLSPEC void SDLCALL SDL_UnlockYUVOverlay(SDL_Overlay *overlay);

extern DECLSPEC int SDLCALL SDL_DisplayYUVOverlay(SDL_Overlay *overlay, SDL_Rect *dstrect);

extern DECLSPEC void SDLCALL SDL_FreeYUVOverlay(SDL_Overlay *overlay);

extern DECLSPEC int SDLCALL SDL_GL_LoadLibrary(const char *path);

extern DECLSPEC void * SDLCALL SDL_GL_GetProcAddress(const char* proc);

extern DECLSPEC int SDLCALL SDL_GL_SetAttribute(SDL_GLattr attr, int value);

extern DECLSPEC int SDLCALL SDL_GL_GetAttribute(SDL_GLattr attr, int* value);

extern DECLSPEC void SDLCALL SDL_GL_SwapBuffers(void);

extern DECLSPEC void SDLCALL SDL_GL_UpdateRects(int numrects, SDL_Rect* rects)
;
extern DECLSPEC void SDLCALL SDL_GL_Lock(void);

extern DECLSPEC void SDLCALL SDL_GL_Unlock(void);

extern DECLSPEC void SDLCALL SDL_WM_SetCaption(const char *title, const char *icon);

extern DECLSPEC void SDLCALL SDL_WM_GetCaption(char **title, char **icon);

extern DECLSPEC void SDLCALL SDL_WM_SetIcon(SDL_Surface *icon, Uint8 *mask);

extern DECLSPEC int SDLCALL SDL_WM_IconifyWindow(void);

extern DECLSPEC int SDLCALL SDL_WM_ToggleFullScreen(SDL_Surface *surface);

extern DECLSPEC SDL_GrabMode SDLCALL SDL_WM_GrabInput(SDL_GrabMode mode);

extern DECLSPEC int SDLCALL SDL_SoftStretch(SDL_Surface *src, SDL_Rect *srcrect,
                                    SDL_Surface *dst, SDL_Rect *dstrect);



# typedef enum {
#     SDL_GRAB_QUERY = -1,
#     SDL_GRAB_OFF = 0,
#     SDL_GRAB_ON = 1,
#     SDL_GRAB_FULLSCREEN /**< Used internally */
# } SDL_GrabMode;








