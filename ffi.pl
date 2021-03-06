use strict;
use warnings;


use FFI::Platypus;
use FFI::CheckLib qw/ find_lib_or_exit /;
use SDL2::SDL;



my $ffi = FFI::Platypus->new( api => 1 );
$ffi->find_lib( lib => 'SDL2' );

sub str { $ffi->cast( 'opaque', 'string', shift ) }


SDL2::SDL::attach( $ffi );
if( SDL2::SDL::SDL_Init( 0x00000020 ) < 0 ) {
    die "Unable to initialize SDL";
}

print SDL2::Render::SDL_GetNumRenderDrivers(), "\n";
my $info =  SDL2::RendererInfo->new;
SDL2::Render::SDL_GetRenderDriverInfo( 0, $info );

print str( $info->name ), "\n";
print $info->flags, "\n";
print $info->num_texture_formats, "\n";
print join ' ', $info->texture_formats->@*, "\n";
print $info->max_texture_width, "\n";
print $info->max_texture_height, "\n";


my $window  =  SDL2::Video::SDL_CreateWindow( 'Hello', 100, 100, 800, 600, 0x00000004 ); #создаёт окно
my $surface =  SDL2::Video::SDL_GetWindowSurface( $window );

# my $render =  SDL2::Render::SDL_CreateRenderer( $window, -1, 0 );
# die SDL2::Error::SDL_GetError();
my $render =  SDL2::Render::SDL_GetRenderer( $window );
SDL2::Render::SDL_SetRenderDrawColor( $render, 0, 0, 255, 0 );
# SDL2::Render::SDL_RenderClear( $render );
# SDL2::Render::SDL_RenderPresent( $render );
# SDL2::Timer::SDL_Delay( 2000 );

use Benchmark ':all';

my $rect1 =  SDL2::Rect->new({ x => 10,  y => 10,  h => 50,  w => 50 });
my $rect2 =  SDL2::Rect->new({ x => 10,  y => 10,  h => 50,  w => 50 });
	timethese( 100000, {
		'Soft' => sub {
			SDL2::Surface::SDL_FillRect( $surface, $rect1, 0x00FF0000 );
		},
		'Hard' => sub {
			SDL2::Render::SDL_RenderFillRect( $render, $rect1 );
		},
	});



SDL2::Render::SDL_RenderPresent( $render );
# SDL2::Video::SDL_UpdateWindowSurface( $window );

SDL2::Timer::SDL_Delay( 2000 );

__END__



# use FFI::Platypus;
# use FFI::CheckLib qw/ find_lib_or_exit /;



# my $ffi = FFI::Platypus->new( api => 1 );
# # OLD -> new
# # /usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0.8.0
# # /usr/local/lib/libSDL2-2.0.so.0.10.0
# $ffi->find_lib( lib => 'SDL2' );


# use SDL2::SDL;
# SDL2::SDL::attach( $ffi );

# # $ffi->attach( SDL_Init          => [ 'uint32' ] => 'int'    );
# # $ffi->attach( SDL_InitSubSystem => [ 'uint32' ] => 'int'    );
# # $ffi->attach( SDL_QuitSubSystem => [ 'uint32' ] => 'void'   );
# # $ffi->attach( SDL_WasInit       => [ 'uint32' ] => 'uint32' );
# # $ffi->attach( SDL_Quit          => [ 'void'   ] => 'void'   );


# # SDL_INIT_VIDEO    0x00000020;   #Инициализирует видеоподсистему.
# if( SDL2::SDL::SDL_Init( 0x00000020 ) < 0 ) {
#     die "nable to initialize SDL";
# }
# # my $res =  SDL_Init( 0x00000020 );
# # print 'SDL_INIT_VIDEO  -->> ', $res,"\n";


#     # //The surface contained by the window
#     # SDL_Surface* screenSurface = NULL;
#     # window = SDL_CreateWindow( "SDL Tutorial",
#     #   SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH,
#     #   SCREEN_HEIGHT, SDL_WINDOW_SHOWN
#     # );

# # extern DECLSPEC SDL_Window * SDLCALL SDL_CreateWindow(const char *title,
#                                                      # int x, int y, int w,
#                                                      # int h, Uint32 flags);

# use SDL2::Video;
# # DB::x;
# SDL2::Video::attach( $ffi );
# # opaque - непрозрачный
# # $ffi->type( 'opaque' => 'SDL_Window_ptr' );
# # $ffi->attach( SDL_CreateWindow => [ 'string', 'int','int','int','int','uint32' ] => 'SDL_Window_ptr' );

# # //The window we'll be rendering to
# # SDL_Window* window = NULL;
# my $window =  SDL2::Video::SDL_CreateWindow( 'Hello', 100, 100, 300, 200, 0x00000004 ); #создаёт окно
# #extern DECLSPEC SDL_Surface * SDLCALL SDL_GetWindowSurface(SDL_Window * window);
# # SDL_Surface - Графическая структура поверхности
# # $ffi->type( 'opaque' => 'SDL_Surface_ptr' );
# # $ffi->attach( SDL_GetWindowSurface => [ 'SDL_Window_ptr' ] => 'SDL_Surface_ptr' );

# #screenSurface = SDL_GetWindowSurface( window );
# my $screenSurface =  SDL2::Video::SDL_GetWindowSurface( $window );


# use SDL2::Surface;
# SDL2::Surface::attach( $ffi );

# # extern DECLSPEC int SDLCALL SDL_FillRect
# #    (SDL_Surface * dst, const SDL_Rect * rect, Uint32 color);
# # SDL_Rect     - Определяет прямоугольную область
# # SDL_FillRect - Заливает поверхность окна
# # $ffi->type( 'opaque' => 'SDL_Rect_ptr' );
# # $ffi->attach( SDL_FillRect => [ 'SDL_Surface_ptr', 'SDL_Rect_ptr', 'uint32' ] => 'int' );

# # extern DECLSPEC Uint32 SDLCALL SDL_MapRGB(const SDL_PixelFormat * format,
# #                                          Uint8 r, Uint8 g, Uint8 b);

# use SDL2::Pixels;
# SDL2::Pixels::attach( $ffi );

# # SDL_MapRGB - Сопоставляет значение цвета RGB с форматом пикселей
# # $ffi->type( 'opaque' => 'SDL_PixelFormat_ptr' );
# # $ffi->attach( SDL_MapRGB => [ 'SDL_PixelFormat_ptr', 'uint8', 'uint8', 'uint8' ] => 'uint32' );
# # SDL_MapRGB( screenSurface->format, 0xFF, 0xFF, 0xFF )
# # my $color =  SDL_MapRGB( $screenSurface->format, 0xFF, 0xFF, 0xFF );
# # XXXXXX


# #SDL_FillRect( screenSurface, NULL, $color );
# SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x00FF0000 ); #заливает поверхность окна


# # extern DECLSPEC int SDLCALL SDL_UpdateWindowSurface(SDL_Window * window);
# # $ffi->attach( SDL_UpdateWindowSurface => [ 'SDL_Window_ptr' ] => 'int' );

# # SDL_UpdateWindowSurface - обновляет окно
# # SDL_UpdateWindowSurface( window );
# SDL2::Video::SDL_UpdateWindowSurface( $window );

# #extern DECLSPEC void SDLCALL SDL_Delay(Uint32 ms);
# $ffi->attach( SDL_Delay => [ 'uint32' ] => 'void' );

# # SDL_Delay( 2000 );
# SDL_Delay( 2000 ); #ждёт заданное количество миллисекунд

# # sleep 5;

# __END__
