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
	my $btn     = Rect->new( 0, 0, 50, 30 );
	my $btn_del = Rect->new( 250, 0, 50, 30 );
	$btn_del->{ c }->{ r } = 255;
	$btn_del->{ c }->{ g } = 0;
	$btn_del->{ c }->{ b } = 0;
	$btn_del->{ selection } = 1;
	my $sel;	
	my @rect =  ();

	$app->add_show_handler ( sub{ #show
		show( @_, $btn, $sel, @rect, $btn_del ) 
	} );

	read_from_db( \@rect );

	$app->add_event_handler( sub{ new_rect( @_, $btn, \@rect ) } );

	## Rect moving
	$app->add_event_handler( sub{ move_start ( @_, \@rect ) } );
	$app->add_event_handler( sub{ move_rect  ( @_, \@rect ) } );
	$app->add_event_handler( sub{ move_finish( @_, \@rect ) } );


	## Rect grouping
	$app->add_event_handler( sub{ #sel_start
		if( my $res =  sel_start ( @_, $sel, \@rect, $btn, $btn_del ) ) {
			$sel =  $res;
		}
	} );
	$app->add_event_handler( sub{ sel_resize( @_, $sel, \@rect ) } );
	$app->add_event_handler( sub{ #sel_finish
		if( my $res =  sel_finish( @_, $sel, \@rect ) ) {
			$sel =  undef;
		}
	} );


	$app->add_event_handler( sub{ resize_start ( @_, \@rect ) } );
	$app->add_event_handler( sub{ resize_rect  ( @_, \@rect ) } );
	$app->add_event_handler( sub{ resize_finish( @_, \@rect ) } );



	$app->add_event_handler( sub{ del_start ( @_, $btn_del ) } );
	$app->add_event_handler( sub{ del_rect  ( @_, $btn_del ) } );
	$app->add_event_handler( sub{ del_all( @_, $btn_del, $btn, \@rect ) } );
	$app->add_event_handler( sub{ del_first( @_, $btn_del, \@rect ) } );


}
$app->add_event_handler( \&Util::pause_handler );


$app->run();
exit();



sub read_from_db {	
	my( $rect ) =  @_;

	@$rect = ();
	my @rect_f =  Util::db()->resultset( 'Rect' )->search({
		parent_id => undef
	})->all;

	for my $r ( @rect_f ) {
		$r =  Rect->new( $r );
		$r->load_children;
		push @$rect, $r;
	}
}




sub show {
    my( $delta, $app, @objects ) = @_;

    for my $object ( @objects ){
    	$object   or next;   	

		$object->draw( $app );
	}

    $app->update;
}



sub new_rect {
	my( $event, $app, $button, $squares ) = @_;

	$event->type == SDL_MOUSEBUTTONDOWN 
	&&  $button->is_over( $event->motion_x, $event->motion_y )
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
		if( $square->Util::resize_field( $event->motion_x, $event->motion_y ) ) {
			return;
		}

		$square->is_over( $event->motion_x, $event->motion_y )  or next;
		$square->moving_on( $event->motion_x, $event->motion_y );
	}
}



sub move_rect {
	my( $event, $app, $squares ) =  @_;

	$event->type == SDL_MOUSEMOTION
		or return;

	for my $square ( @$squares ){
		$square->{ moving }   or next;		

		$square->draw_black( $app );

		$square->move_to( $event->motion_x,  $event->motion_y, $app_w, $app_h );
	}
}



sub move_finish {
	my( $event, $app, $squares ) = @_;

	$event->type == SDL_MOUSEBUTTONUP
		or return;

	for my $square ( @$squares ){
		$square->{ moving }   or next;

		$square->moving_off;
		$square->store;
	}
}



sub sel_start {
	my( $event, $app, $sel, $squares, $btn, $btn_del ) = @_;

	!$sel  &&  $event->type == SDL_MOUSEBUTTONDOWN
		or return;

	for my $square ( @$squares ){
		$square->is_over( $event->motion_x, $event->motion_y )   or next;

		return;
	}

	if( $btn->is_over( $event->motion_x, $event->motion_y ) ) { 
		return;
	}
	if( $btn_del->is_over( $event->motion_x, $event->motion_y ) ) { 
		return;
	}

	my $r =  Selection->new( 
		$event->motion_x, $event->motion_y, 0, 0,
		Color->new( 0, 0, 0 )
	);
	$r->{ selection } = 1;

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
			push @alone, $square;
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



sub resize_start {
	my( $event, $app, $squares ) =  @_;

	$event->type == SDL_MOUSEBUTTONDOWN 
		or return;

	for my $square ( @$squares ){
		$square->Util::resize_field( $event->motion_x, $event->motion_y )   or next;

		$square->resize_on();
	}
}



sub resize_rect {
	my( $event, $app, $squares ) =  @_;

	$event->type == SDL_MOUSEMOTION
	or return;

	for my $square ( @$squares ){
		$square->{ resize }   or next;		
		$square->draw_black( $app );
		$square->resize_to( $event->motion_x,  $event->motion_y );
	}
}



sub resize_finish {
	my( $event, $app, $squares ) =  @_;

	$event->type == SDL_MOUSEBUTTONUP
		or return;

	for my $square ( @$squares ){
		$square->{ resize }   or next;

		$square->resize_off;
		$square->store;
	}
}



sub del_start {
	my( $event, $app, $btn_d ) =  @_;
	

	$event->type == SDL_MOUSEBUTTONDOWN 
		or return;

		$btn_d->is_over( $event->motion_x, $event->motion_y )  or next;

		$btn_d->moving_on( $event->motion_x, $event->motion_y );
}



sub del_rect {
	my( $event, $app, $btn_d ) =  @_;

	$btn_d->{ moving }  &&  $event->type == SDL_MOUSEMOTION
		or return;

	$btn_d->draw_black( $app );
	$btn_d->move_to( $event->motion_x,  $event->motion_y, $app_w, $app_h );
}



sub del_all {
	my( $event, $app, $btn_d, $btn, $rect ) = @_;

	$btn_d->{ moving } && $event->type == SDL_MOUSEBUTTONUP
		or return;

	for my $square( @$rect ){
		if( $square->is_over( $btn_d->{ x }, $btn_d->{ y } )) {
				return;
		}
	}

	if( $btn->is_over( $btn_d->{ x }, $btn_d->{ y } ) ){
		for my $square( @$rect ) {
			$square->draw_black( $app );
		}

		@$rect = ();
		Util::db()->resultset( 'Rect' )->delete;
	}

	$btn_d->btn_d_come_back( $app );
}



sub del_first {
	my( $event, $app, $btn_d, $rect ) = @_;

	$btn_d->{ moving } && $event->type == SDL_MOUSEBUTTONUP
		or return;

	for my $square( @$rect ){
		$square->is_over( $btn_d->{ x }, $btn_d->{ y } )   or next;
	
		$square->child_delete( $app );
		$square->draw_black( $app );
	}

	read_from_db( $rect );

	$btn_d->btn_d_come_back( $app );
}


__END__

sub fusion {
	my( $rect ) = @_;

	my $move;
	my @still;

	for my $square ( @$squares ){
		$square->{ moving } ?
		push $move, $square:
		push @still, $square;
	}

	for my $square ( @still ){
		$square->is_over( $move->{ x }, $move->{ y } ) or return;

		$move->{ parent } = $square->{ id };
		$move->drow_black( $app );

		my $n = 0;
		#$square->read_children;

	}
		read_from_db( $rect );
}



sub read_children {
	my( $square ) = @_;

	$square->{ children } or return;

	for my $s( $square->{ children }->@* ) {
		
		$s->read_children;
}
