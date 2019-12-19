use strict;
use warnings;


use FFI::Platypus;
use FFI::CheckLib qw/ find_lib_or_exit /;
use SDL2::SDL;



my $ffi = FFI::Platypus->new( api => 1 );
$ffi->find_lib( lib => 'SDL2' );


SDL2::SDL::attach( $ffi );
# if( SDL2::SDL::SDL_Init::SDL_INIT_VIDEO  < 0 ) {
if( SDL2::SDL::SDL_Init (0x00000020)  < 0 ) {
    die "nable to initialize SDL_VIDEO";
}


my $window =  SDL2::Video::SDL_CreateWindow( 'Окно', 100, 100, 800, 600, 0x00000004 ); #создаёт окно
my $screenSurface =  SDL2::Video::SDL_GetWindowSurface( $window );  #создаём поверхность
SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x00A9BA09 );   #заливает поверхность окна

my $r1 = SDL2::Render::SDL_CreateRenderer($window, -1, 0x00000002); #Создать рендерер

SDL2::Render::SDL_SetRenderDrawColor($r1, 0x00, 0x00, 0x00, 0x00);  #устанавливает цвет
SDL2::Render::SDL_RenderClear($r1); #очистить текущий рендеринг цветом рисования
SDL2::Render::SDL_SetRenderDrawColor($r1, 0xFF, 0xFF, 0xFF, 0xFF);  #устанавливает цвет

# SDL2::Rect rect1 = {10, 10, 50, 50};

# my @rect1 = (10, 10, 50, 50);
# SDL_Rect rect1 = {10, 10, 50, 50};
# my $r6 = SDL2::Render::SDL_RenderFillRect($r1, @rect1);
# SDL_Rect rect2 = {70, 10, 50, 50};
# my $r8 = SDL2::Render::SDL_RenderDrawRect($r1, &rect2);

# my $r9 = SDL2::Render::SDL_RenderDrawLine($r1, 10, 70, 70, 70);
# my $i = 10;
# while ( $i <= 70 ) {
#     SDL2::Render::SDL_RenderDrawPoint($r1, $i, 90);
#     $i = $i +4
# }
# SDL2::Render::SDL_RenderPresent($r1);
SDL2::Video::SDL_UpdateWindowSurface( $window );
SDL2::Timer::SDL_Delay( 5000 );

# DB::x;






# my $window =  SDL2::Video::SDL_CreateWindow( 'Окно', 100, 100, 800, 600, 0x00000004 ); #создаёт окно
# my $screenSurface =  SDL2::Video::SDL_GetWindowSurface( $window );  #создаём поверхность
# my $rect =  SDL2::Video::SDL_CreateWindow( 'Квадрат', 200, 200, 220, 30, 0x00000004 );
# my $screenrect =  SDL2::Video::SDL_GetWindowSurface( $rect );

# SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x00A9BA09 ); #заливает поверхность окна
# SDL2::Surface::SDL_FillRect( $screenrect, undef, 0x00FF0000 );
# SDL2::Video::SDL_UpdateWindowSurface( $window );
# SDL2::Video::SDL_UpdateWindowSurface( $rect );
# SDL2::Timer::SDL_Delay( 2000 ); #ждёт заданное количество миллисекунд
# # SDL2::Rect::SDL_UnionRect( 2, 2, 2);

# # $ffi->attach( SDL_Delay => [ 'uint32' ] => 'void' );
# SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x0000FFFF );
# SDL2::Surface::SDL_FillRect( $screenrect, undef, 0x00A9BA09 );
# SDL2::Video::SDL_UpdateWindowSurface( $window );
# SDL2::Video::SDL_UpdateWindowSurface( $rect );
# SDL2::Timer::SDL_Delay( 1500 );

# SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x0000FF00 );
# SDL2::Surface::SDL_FillRect( $screenrect, undef, 0x00FF0000 );
# SDL2::Video::SDL_UpdateWindowSurface( $window );
# SDL2::Video::SDL_UpdateWindowSurface( $rect );
# SDL2::Timer::SDL_Delay( 1500 );

# SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x000FF000 );
# SDL2::Surface::SDL_FillRect( $screenrect, undef, 0x00A9BA09 );
# SDL2::Video::SDL_UpdateWindowSurface( $window );
# SDL2::Video::SDL_UpdateWindowSurface( $rect );
# SDL2::Timer::SDL_Delay( 1500 );

# SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x000000AA );
# SDL2::Surface::SDL_FillRect( $screenrect, undef, 0x00FF0000 );
# SDL2::Video::SDL_UpdateWindowSurface( $window );
# SDL2::Timer::SDL_Delay( 1500 );

# SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x0FF00000 );
# SDL2::Surface::SDL_FillRect( $screenrect, undef, 0x00A9BA09 );
# SDL2::Video::SDL_UpdateWindowSurface( $window );
# SDL2::Video::SDL_UpdateWindowSurface( $rect );
# SDL2::Timer::SDL_Delay( 1500 );

# SDL2::Surface::SDL_FillRect( $screenSurface, undef, 0x00000000 );
# SDL2::Surface::SDL_FillRect( $screenrect, undef, 0x00FF0000 );
# SDL2::Video::SDL_UpdateWindowSurface( $window );
# SDL2::Video::SDL_UpdateWindowSurface( $rect );
# SDL2::Timer::SDL_Delay( 1500 );

print "BYE";
exit;

__END__
using namespace std;

int SCREEN_WIDTH = 640;
int SCREEN_HEIGHT = 480;

SDL_Window *win = NULL;
SDL_Renderer *ren = NULL;

bool init() {
    bool ok = true;

    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        cout « "Can't init SDL: " « SDL_GetError() « endl;
    }

    win = SDL_CreateWindow("Примитивы", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
    if (win == NULL) {
        cout « "Can't create window: " « SDL_GetError() « endl;
        ok = false;
    }

    ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED);
    if (ren == NULL) {
        cout « "Can't create renderer: " « SDL_GetError() « endl;
        ok = false;
    }
    return ok;
}

void quit() {
    SDL_DestroyWindow(win);
    win = NULL;

    SDL_DestroyRenderer(ren);
    ren = NULL;

    SDL_Quit;
}

int main (int arhc, char ** argv) {
    if (!init()) {
        quit();
        system("pause");
        return 1;
    }

    SDL_SetRenderDrawColor(ren, 0x00, 0x00, 0x00, 0x00);
    SDL_RenderClear(ren);
    SDL_SetRenderDrawColor(ren, 0xFF, 0xFF, 0xFF, 0xFF);

    SDL_Rect rect1 = {10, 10, 50, 50};
    SDL_RenderFillRect(ren, &rect1);

    SDL_Rect rect2 = {70, 10, 50, 50};
    SDL_RenderDrawRect(ren, &rect2);

    SDL_RenderDrawLine(ren, 10, 70, 640 - 10, 70);

    for (int i = 10; i <= 640-10; i +=4 ) {
        SDL_RenderDrawPoint(ren, i, 90);
    }

    SDL_RenderPresent(ren);

    SDL_Delay(5000);

    quit();
    return 0;
}
