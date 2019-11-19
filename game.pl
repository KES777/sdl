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
   

my $app_w = 700; #размер экрана;
my $app_h = 700; #размер экрана;
my $app = SDLx::App->new( width => $app_w, height => $app_h, resizeable => 1);

my $app_rect =  AppRect->new( $app_w, $app_h );

{
	# my $app_rect =  AppRect->new( $app );
	# my $btn      =  Rect->new( 0, 0, 50, 30 );
	# my $btn_del  =  Btn_del->new;

	my @flag_1;
	my @first;
	my @rect =  ();
	# push $app_rect->{ children }->@*, $btn, $btn_del, $sel, @rect;

	# $app->add_show_handler ( sub{ #show
	# 	show( @_, $btn, $sel, @rect, $btn_del, @first ) 
	# } );
	$app->add_show_handler( sub{ $app_rect->draw } );

	# read_from_db( \@rect );

	# $app->add_event_handler( sub{ new_rect( @_, $btn, \@rect ) } );

	# ## Rect moving
	# $app->add_event_handler( sub{ move_start ( @_, \@rect, \@first, \@flag_1 ) } );
	# $app->add_event_handler( sub{ move_rect  ( @_, \@rect ) } );
	# $app->add_event_handler( sub{ drop_rect( @_, \@rect, \@first, \@flag_1 ) } );

	# $app->add_event_handler( sub{ drag_flag ( @_, \@rect, \@flag_1 ) } );
	# $app->add_event_handler( sub{ drag_start ( @_, \@rect, \@first, \@flag_1 ) } );



	# ## Rect grouping
	# $app->add_event_handler( sub{ #sel_start
	# 	if( my $res =  sel_start ( @_, $sel, \@rect, $btn, $btn_del ) ) {
	# 		$sel =  $res;
	# 	}
	# } );
	# $app->add_event_handler( sub{ sel_resize( @_, $sel, \@rect ) } );
	# $app->add_event_handler( sub{ #sel_finish
	# 	if( my $res =  sel_finish( @_, $sel, \@rect ) ) {
	# 		$sel =  undef;
	# 	}
	# } );


	# $app->add_event_handler( sub{ resize_start ( @_, \@rect ) } );
	# $app->add_event_handler( sub{ resize_rect  ( @_, \@rect ) } );
	# $app->add_event_handler( sub{ resize_finish( @_, \@rect ) } );



	# $app->add_event_handler( sub{ del_start ( @_, $btn_del ) } );
	# $app->add_event_handler( sub{ del_move  ( @_, $btn_del ) } );
	# $app->add_event_handler( sub{ del_all( @_, $btn_del, $btn, \@rect ) } );
	# $app->add_event_handler( sub{ del_first( @_, $btn_del, \@rect ) } );

	# $app->add_event_handler( sub{ is_over( @_, \@rect ) } );


}
$app->add_event_handler( \&Util::pause_handler );


$app->run();
exit();



sub is_over {
	my( $e, $app, $rect ) =  @_;

	$e->type == SDL_MOUSEMOTION
		or return;

	for my $r ( @$rect ) {
		my $over =  $r->is_over( $e->motion_x, $e->motion_y )
			or next;

		print $over->{ id }, "\n";
	}
}	



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

    $app_rect->draw();

 #    for my $object ( @objects ){
 #    	$object   or next;   	

	# 	$object->draw( $app );
	# }

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



sub move_start {
	my( $event, $app, $squares, $first, $flag_1 ) =  @_;

	if( @$flag_1 ) {
		return;
	}

	$event->type == SDL_MOUSEBUTTONDOWN 
		or return;

	for my $square ( @$squares ){
		if( $square->Util::resize_field( $event->motion_x, $event->motion_y ) ) {
			return;
		}

		$square->Util::mouse_target_square( $event->motion_x, $event->motion_y )  or next;
		$square->moving_on( $event->motion_x, $event->motion_y );
		push @$first, $square;
	}
}



sub drag_flag {
	my( $event, $app, $squares, $flag_1 ) =  @_;

	$event->type == SDL_KEYDOWN
	&&  $event->key_sym == SDLK_d
		or return;

	push @$flag_1, $squares;
}


sub drag_start{
	my( $event, $app, $squares, $first, $flag_1 ) =  @_;

	@$flag_1  &&  $event->type == SDL_MOUSEBUTTONDOWN 
		or return;

	Rect::draw_black_group( $squares, $app, $event->motion_x, $event->motion_y  );
		
	for my $square ( @$squares ){
		my $child =  $square->is_over( $event->motion_x, $event->motion_y )
		   or next;
		$child->detach;
		$child->{ parent }->regroup;
		$child->{ parent_id } =  undef;
		$child->store;

		my( $x, $y ) =  $child->parent_coord( $child->{ x }, $child->{ y } );
		$child->{ x } =  $x;
		$child->{ y } =  $y;
		
		$child->moving_on( $event->motion_x, $event->motion_y );

		push @$squares, $child;
			return;
	}
}



sub drop_rect {

	my( $event, $app, $squares, $first, $flag_1 ) = @_;

	$event->type == SDL_MOUSEBUTTONUP
		or return;

	@$flag_1 =  ();
	@$first  =  ();

	for my $square ( @$squares ){
		$square->{ moving }   or next;

		if( my $g  =  $square->can_drop( $squares, $event->motion_x, $event->motion_y ) ) {
			
			if( my $can =  $g->can_group( $square )) {

				$square->drop( $g, $squares, $event->motion_x, $event->motion_y );

				$square->store;
			}
			else {
				$square->moving_cancel( $app );
				$square->store;
			}
		}

		else {
			$square->moving_off;
		}
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



sub sel_start {
	my( $event, $app, $app_rect ) = @_;

	!$app_rect->{ sel }  &&  $event->type == SDL_MOUSEBUTTONDOWN
		or return;

	AppRect::can_select( $app_rect, $event->motion_x, $event->motion_y )
		or return;

	AppRect::new_selecting_field( $app_rect, $event->motion_x, $event->motion_y )
		or return;


	return 1;##?

	# for my $square ( @$squares ){
	# 	$square->is_over( $event->motion_x, $event->motion_y )   or next;

	# 	return;
	# }

	# if( $btn->is_over( $event->motion_x, $event->motion_y ) ) { 
	# 	return;
	# }
	# if( $btn_del->is_over( $event->motion_x, $event->motion_y ) ) { 
	# 	return;
	# }

	# my $r =  Selection->new( 
	# 	$event->motion_x, $event->motion_y, 0, 0,
	# 	Color->new( 0, 0, 0 )
	# );
	# $r->{ selection } = 1;

	# return $r;
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

	Rect::to_group( $rect, @grouped );

	$rect->{ children } =  \@grouped;
	push @$squares, $rect;

	$rect->save_prev;#load parent###########

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
	&&  $btn_d->is_over( $event->motion_x, $event->motion_y )
		or return;

	$btn_d->moving_on( $event->motion_x, $event->motion_y );
}



sub del_move {
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
		if( Util::mouse_target_square( $square, $btn_d->{ x }, $btn_d->{ y } ) ) {
				return;
		}
	}

	if( Util::mouse_target_square( $btn, $btn_d->{ x }, $btn_d->{ y } ) ){
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
	my $x;
	for my $square( @$rect ){
		# $square->is_over( $btn_d->{ x }, $btn_d->{ y } )   or next;
		Util::mouse_target_square( $square, $btn_d->{ x }, $btn_d->{ y } ) or next;
		$x =  $square;
		$square->child_destroy;
		$square->draw_black( $app );
	}

	# read_from_db( $rect );
	@$rect =  grep{ $_ != $x } @$rect;

	$btn_d->btn_d_come_back( $app );
}



