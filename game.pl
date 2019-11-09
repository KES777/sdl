# perl -Ilocal/lib/perl5 game.pl
use strict;
use warnings;

use Schema;
use Selection;
use Rect;
use Util;

use DDP;
use SDL;
use SDLx::App;
use SDL::Event;
use SDLx::Text;
   

my $app_w = 700; #размер экрана;
my $app_h = 700; #размер экрана;
my $app = SDLx::App->new( width => $app_w, height => $app_h, resizeable => 1);


{
	my $btn  =  Rect->new( 0, 0, 50, 30 );
	my $sel;	
	my @rect =  ();

	$app->add_show_handler ( sub{ #show
		show( @_, $btn, $sel, @rect ) 
	} );

	read_from_db( \@rect );

	$app->add_event_handler( sub{ new_rect( @_, $btn, \@rect ) } );

	## Rect moving
	$app->add_event_handler( sub{ move_start ( @_, \@rect ) } );
	$app->add_event_handler( sub{ move_rect  ( @_, \@rect ) } );
	$app->add_event_handler( sub{ move_finish( @_, \@rect ) } );


	## Rect grouping
	$app->add_event_handler( sub{ 
		if( my $res =  sel_start ( @_, $sel, \@rect ) ) {
			$sel =  $res;
		}
	} );
	$app->add_event_handler( sub{ sel_resize( @_, $sel, \@rect ) } );
	$app->add_event_handler( sub{ 
		if( my $res =  sel_finish( @_, $sel, \@rect ) ) {
			$sel =  undef;
		}
	} );


}
$app->add_event_handler( \&Util::pause_handler );


$app->run();
exit();



sub read_from_db {	
	my( $rect ) =  @_;

	my @rect =  Util::db()->resultset( 'Rect' )->search({
		parent_id => undef
	})->all;

	for my $r ( @rect ) {
		# push @$rect, Rect->new( 
		# 	$r->x, $r->y, $r->w, $r->h, 
		# 	Color->new( $r->r, $r->g, $r->b, $r->a )
		# );
		push @$rect, Rect->new( $r );
	}
}




sub show {
    my( $delta, $app, @objects ) = @_;

    for my $object ( @objects ){
    	$object   or next;   	
    	# DB::x   if $DB::moving;
		$object->draw( $app );
	}

    $app->update;
}



sub new_rect {
	my( $event, $app, $button, $squares ) = @_;

	$event->type == SDL_MOUSEBUTTONDOWN  &&  $button->is_over( $event )
		or return;

	my $rect =  Rect->new->store;
	push @$squares, $rect;
}



## Rect dragging
sub move_start {
	my( $event, $app, $squares ) =  @_;

	$event->type == SDL_MOUSEBUTTONDOWN 
		or return;

	for my $square ( @$squares ){
		$square->is_over( $event )   or next;
		# $square->is_over( $event->motion_x, $event->motion_y )   or next;

		$square->moving_on( $event->motion_x, $event->motion_y );
	}
}



sub move_rect {
	my( $event, $app, $squares ) =  @_;

	$event->type == SDL_MOUSEMOTION
		or return;

	for my $square ( @$squares ){
		$square->{ moving }   or next;		

		# DB::x   if !$DB::moving2;
		$square->draw_black( $app );
		$square->move_to( $event->motion_x,  $event->motion_y );
	}
}



sub move_finish {
	my ($event, $app, $squares ) = @_;

	$event->type == SDL_MOUSEBUTTONUP
		or return;

	for my $square ( @$squares ){
		$square->{ moving }   or next;

		$square->moving_off;
		$square->store;
	}
}





sub sel_start {
	my( $event, $app, $sel, $squares ) = @_;

	!$sel  &&  $event->type == SDL_MOUSEBUTTONDOWN
		or return;

	for my $square ( @$squares ){
		$square->is_over( $event )   or next;

		return;
	}


	my $r =  Selection->new( 
		$event->motion_x, $event->motion_y, 0, 0,
		Color->new( 234, 23, 78 )
	);


	return $r;
}



sub sel_resize {
	my( $event, $app, $sel ) =  @_;

	$sel  &&  $event->type == SDL_MOUSEMOTION
		or return;


	$sel->draw_black( $app );
	$sel->resize( $event->motion_x, $event->motion_y );
	$sel->draw( $app );
}	



sub sel_finish {
	my( $event, $app, $sel, $squares ) =  @_;

	$sel  &&  $event->type == SDL_MOUSEBUTTONUP
		or return;


	$sel->draw_black( $app );


	my @alone;
	my @grouped;
	for my $square ( @$squares ) {
		$square->is_inside( $sel->@{qw/ x y w h /} )?
			push @grouped, $square :
			push @alone, $square
		;
	}

	@grouped   or return 1;

	$squares->@* =  @alone;

	my $rect =  Rect->new( $sel->{ x }, $sel->{ y } )->store;
	my $w =   0;	
	my $h =  10;
	for my $s ( @grouped ) {
		$h +=  $s->{ h } +10;
		$w  =  $s->{ w } > $w ? $s->{ w } : $w;

		$s->parent( $rect->{ id } );
	}

	$rect->{ w } =  $w + 20;
	$rect->{ h } =  $h;	
	$rect->store;

	$rect->{ children } =  \@grouped;

	push @$squares, $rect;

	return 1;
}	


