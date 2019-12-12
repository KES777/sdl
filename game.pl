# perl -Ilocal/lib/perl5 game.pl
use strict;
use warnings;

use Schema;
use Selection;
use AppRect;
use Rect;
use Util;
use Btn_del;

use DDP;
use SDL;
use SDLx::App;
use SDL::Event;
use SDLx::Text;


my $app_w = 1200; #размер экрана;
my $app_h = 700; #размер экрана;


my $app_rect =  AppRect->new( $app_w, $app_h );

$app_rect->{ app }->add_event_handler( \&Util::pause_handler );

$app_rect->{ app }->run();



exit();
