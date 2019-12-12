package AppRect;

use strict;
use warnings;

use threads;
use threads::shared;
use SDL::Time;

use SDLx::App;
use SDL::Event;
use Scalar::Util qw/ weaken blessed /;


use Rect;
use Btn_del;
use Btn;
use Circle;
use Btn_Circle;
use Table;
use Cursor;

use base 'Shape';


my $HINT_TIMER =  1000;
my $APP;
sub SCREEN { return $APP }

## Создаёт событие USEREVENT
sub callback3 {
	my $event =  SDL::Event->new();
	$event->type( SDL_USEREVENT );
	$event->user_code( 10 );
	$event->user_data1( 'hello event' );

	SDL::Events::push_event($event);

	return 0;
};


sub new {
	my( $rect, $app_w, $app_h ) =  @_;

	my $app_rect =  $rect->SUPER::new( 0, 0, $app_w, $app_h );

	$APP =  $app_rect->{ app } =  SDLx::App->new(
		width      =>  $app_w,
		height     =>  $app_h,
		resizeable =>  1,
	);

	$app_rect->{ btn } =  Btn->new( 0, 0, 50, 30 );
	$app_rect->{ btn }{ parent } =  $app_rect;
	weaken $app_rect->{ btn }{ parent };

	$app_rect->{ btn_c } =  Btn_Circle->new;
	$app_rect->{ btn_c }{ parent } =  $app_rect;
	weaken $app_rect->{ btn_c }{ parent };

	$app_rect->{ btn_del } =  Btn_del->new;
	$app_rect->{ btn_del }{ parent } =  $app_rect;
	weaken $app_rect->{ btn_del }{ parent };

	$app_rect->{ children } =  [];
	$app_rect->load_children;

	# $APP->add_event_handler( sub{ _on_down( @_, $app_rect ) } );
	# $APP->add_event_handler( sub{ _on_move( @_, $app_rect ) } );

	$APP->add_show_handler ( sub{ $app_rect->draw } );


	$APP->add_event_handler( sub{ _on_user_event( @_, $app_rect ) } );
	$APP->add_event_handler( sub{ _on_mouse_move( @_, $app_rect ) } );
	$APP->add_event_handler( sub{ _is_mousedown ( @_, $app_rect ) } );
	$APP->add_event_handler( sub{ _is_mouseup   ( @_, $app_rect ) } );


	$APP->add_event_handler( sub{ _observer( @_, $app_rect ) } );


	return $app_rect;
}


## Включает свойство hint (по событию USEREVENT )
sub _on_user_event {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_USEREVENT   or return;

	##!
	if( my $h =  $app_rect->{ is_hint } ) {
		$h->{ target }->on_hint( $h, $e );
	}
}



sub _on_move {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEMOTION   or return;

	print "MOVE  ", $e->motion_x, "  ", $e->motion_y, "\n";
}



sub _on_down {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONDOWN   or return;
	print "DOWN  ", $e->button_x, "  ", $e->button_y, "\n";
}



my $event_types =  {
	SDL_MOUSEBUTTONDOWN() => sub {
	},
	SDL_MOUSEMOTION()     => sub {
		my( $app_rect ) =  @_;

		$app_rect->{ event_state }
	},
};
my $mouse_btn =  {
	SDL_BUTTON_LEFT()   =>  'mbl',
	SDL_BUTTON_MIDDLE() =>  'mbm',
	SDL_BUTTON_RIGHT()  =>  'mbr',
};
sub _observer {
	my( $e, $app, $app_rect ) =  @_;

	# $event_types->{ $e->type }->( $app_rect );


	if( $e->type == SDL_MOUSEMOTION ) {
		$app_rect->{ event_state }{ x } =  $e->motion_x;
		$app_rect->{ event_state }{ y } =  $e->motion_y;
	}

	if( $e->type == SDL_MOUSEBUTTONDOWN ) {
		$app_rect->{ event_state }{ $mouse_btn->{ $e->button_button } } =  1;
	}

	if( $e->type == SDL_MOUSEBUTTONUP ) {
		$app_rect->{ event_state }{ $mouse_btn->{ $e->button_button } } =  0;
	}

	if( $e->type == SDL_KEYDOWN ) {
		$app_rect->{ event_state }{ $e->key_sym } =  1;

		if( my $h =  $app_rect->{ is_over } ) {
			$h->{ target }->on_keydown( $h, $e );
		}
	}

	if( $e->type == SDL_KEYUP ) {
		$app_rect->{ event_state }{ $e->key_sym } =  0;

		if( my $h =  $app_rect->{ is_over } ) {
			$h->{ target }->on_keyup( $h, $e );
		}
	}
}



## Проверяет, попали ли в поле selection объекты.
# Если да, то разделить объекты на две группы
sub _can_group {
	my( $app_rect, $h, $e ) =  @_;
	# h - объект selection

	my @alone;
	my @grouped;
	for my $shape ( $app_rect->{ children }->@* ) {
		$shape->is_inside( $h->{ draw }->@{qw/ x y w h /} )?
			push @grouped, $shape :
			push @alone, $shape;
	}

	@grouped   or return;

	# !H
	# target  - экран (поверхность), на которой происходит выделение
	# grouped - выделенные объекты на "экране"
	# alone   - не выделенные объекты на "экране"
	return {
		target  =>  $app_rect,
		grouped =>  \@grouped,
		alone   =>  \@alone,
	};
}



sub make_handle {
	my( $app_rect, $key, $props ) =  @_;

	$props   or return delete $app_rect->{ $key };


	my %h =  %$props;
	$h{ app } =  $app_rect;
	weaken $h{ app };

	$app_rect->{ $key } =  \%h;
}



sub _is_mousedown {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONDOWN
		or return;


	## Создание свойства (ключа) "изменение размеров объекта"
	if( my $h =  $app_rect->{ is_over_rf } ) {
		$h->resize_color;
		$app_rect->{ on_resize } =  $h;
	}



	## Создание поля selection
	# if( (!$app_rect->{ is_over } || "CTRL_KEY"  )  &&  !$app_rect->{ is_selection } ) {
	if( !$app_rect->{ is_over }  &&  !$app_rect->{ is_selection } ) {
		$app_rect->make_handle( is_selection => {
			target =>  $app_rect->{ is_over } || $app_rect,
			draw   =>  Selection->new( $e->motion_x, $e->motion_y, 0, 0,
						Color->new( 0, 0, 0 ) )
		} );
		# DDP::p $h;
	}



	##! PRESS
	if( my $h =  $app_rect->{ is_over } ) {
		$h->{ target }->on_press( $h, $e );

		$app_rect->make_handle( is_down => $h );
	}
}



sub _is_mouseup {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONUP
		or return;

	delete $app_rect->{ event_state }{ SDLK_d };


	## Выключение свойства "изменение размеров объекта"
	if( my $h =  delete $app_rect->{ on_resize } ) {
		$h->restore_state;## Возврат цвета объекту
		$h->store;
	}

	## Выключение свойства "движение объекта"
	##! MOVE STOP
	if( my $h =  delete $app_rect->{ is_moveable } ) {
		$h->{ target }->on_drop( $h, $e );

		# my $shape =  $h->{ target };
		# # $shape->delete_target( $e, $app_rect );
		# $shape->moving_off( $app_rect, $e );###передать нужно только $shape
		# $shape->store;### нужно ли переносить в Shape.pm в  sub moving_off?


		# ## Drop object
		# if( my $group_rect =  $shape->can_drop( $h, $e->motion_x, $e->motion_y ) ) {###замена $app_rect на $h
		# 	$group_rect->{ target }->drop( $shape, $app_rect, $e->motion_x, $e->motion_y );
		# }
	}

	## Создание группы из поля selection
	if( my $h =  delete $app_rect->{ is_selection } ) {
		if( my $group =  $app_rect->_can_group( $h, $e ) ) {
			$group->{ target }->on_group( $h, $e, $group );
		}

		$h->{ draw }->draw_black;## Затираем перед удалением
	}


	##! RELEASE
	if( my $h =  $app_rect->{ is_over } ) {
		$h->{ target }->on_release( $h, $e );
	}


	##! CLICK
	my $up  =  $app_rect->{ is_over };
	my $dw  =  delete $app_rect->{ is_down };
	my $dcl =  delete $app_rect->{ is_double_click };
	my $tcl =  delete $app_rect->{ is_triple_click };


	if( $up  &&  $dw  &&  $up->{ target } == $dw->{ target } ) {
		if   ( $tcl  &&  (SDL::get_ticks() -$tcl->{ time }) < 1000 ) {
			$tcl->{ target }->on_triple_click( $up, $e );

			# $app_rect->make_handle( is_quad_click => { %$up,
			# 	time => SDL::get_ticks(),
			# });
		}
		elsif( $dcl  &&  (SDL::get_ticks() -$dcl->{ time }) < 1000 ) {
			$dcl->{ target }->on_double_click( $up, $e );

			$app_rect->make_handle( is_triple_click => { %$up,
				time => SDL::get_ticks(),
			});
		}
		# else ( $dw   &&  (SDL::get_ticks() -$dcl->{ time }) < 1000 ) {
		else {
			$up->{ target }->on_click( $up, $e );

			$app_rect->make_handle( is_double_click => { %$up,
				time => SDL::get_ticks(),
			});
		}
	}
}



sub _on_mouse_move {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEMOTION
		or return;

	## Объект, над полем resize которого находится курсор
	$app_rect->{ is_over_rf } =
		_is_over_res_field( $app_rect, $e->motion_x, $e->motion_y );


	## Активация свойства "изменение размеров обьекта"
	if( my $h =  $app_rect->{ on_resize } ){
		$h->resize( $e->motion_x, $e->motion_y );
	}


	##! OVER EVENT
	## Send events to objects with additional info
	my $oo =  $app_rect->{ is_over };                             # OLD OVER
	my $no =  _is_over( $app_rect, $e->motion_x, $e->motion_y );  # NEW OVER
	print ref( $no->{ target } ), "\n"   if $no;
	$app_rect->make_handle( is_over => $no );

	if( $no  &&  !$oo ) {
		$no->{ target }->on_mouse_over( $e, $no );
	}

	if( $oo  &&  $no  &&  $no->{ target } != $oo->{ target } ) {
		$oo->{ target }->on_mouse_out( $e, $oo );
		$no->{ target }->on_mouse_over( $e, $no );
	}

	if( $oo  &&  !$no ) {
		$oo->{ target }->on_mouse_out( $e, $oo );
	}


	##! MOVE START
	if( !$app_rect->{ is_moveable }
		&&	!$app_rect->{ on_resize }
		&&  ( my $h =  $app_rect->{ is_down } )
	) {
		$h->{ target }->on_drag( $e, $h );
		$app_rect->make_handle( is_moveable =>  $h );
	}


	##! MOVEABLE
	if( my $h =  $app_rect->{ is_moveable } ) {
		$h->{ target }->on_move( $e, $h );
	}


	## Активация свойства "изменение размеров" поля выделения
	if( my $h =  $app_rect->{ is_selection } ) {
		$h->{ draw }->on_resize( $h, $e );
	}


	##! HINT EVENT
	if( my $h =  delete $app_rect->{ is_hint } ) {
		SDL::Time::remove_timer( $h->{ timer_id } );
	}

	if( $no ) {
		my $timer_id =  SDL::Time::add_timer( $HINT_TIMER, 'AppRect::callback3' );
		$app_rect->make_handle( is_hint => { %$no,
			timer_id =>  $timer_id,
		});
	}



	#### Nazar
	## Отрисовка объекта (над которым курсор) поверх других
	if( my $h =  $app_rect->{ is_over } ) {
		$app_rect->{ first } =  $h->{ owner };
	}

	## Удаление ключа, отвечающего за отрисовку объекта поверх других
	if( !$app_rect->{ is_over } ) {
		delete $app_rect->{ first };
	}


	## Активация свойства "передвижение", отрисовка этого объекта поверх других
	if( my $h =  $app_rect->{ is_moveable } ) {
		$app_rect->{ first } =  $h->{ target };
	}
}


## Возвращает объект, над которым курсор
sub _is_over {
	my( $app_rect, $x, $y ) =  @_;

	my $over;
	my @interface =  ( $app_rect->{ btn }, $app_rect->{ btn_del }, $app_rect->{ btn_c } );
	for my $shape ( $app_rect->{ children }->@*, @interface ) {
		$over =  $shape->is_over( $x, $y )
			or next;

		$over->{ owner } =  $shape;
		last;
	}

	return $over;
}



sub refresh_over {
	my( $app_rect, $x, $y ) =  @_;

	# $app_rect->{ is_over } =  _is_over( $app_rect, $x, $y );
	$app_rect->make_handle( is_over => _is_over( @_ ) );
}



## Возвращает объект, если над его полем resize находится курсор
sub _is_over_res_field {
	my( $app_rect, $x, $y ) =  @_;

	my $object;
	for my $shape ( $app_rect->{ children }->@* ) {
		$shape->is_over_res_field( $x, $y )
			or next;
		$object =  $shape;
	}

	return $object;

}



## Определяет, есть ли в поле выделения объекты
sub can_select {
	my( $app_rect, $x, $y ) =  @_;

	for my $child ( @$app_rect ){## В is_over проверяем толко $app_rect->{ children }
		$child->is_over( $x, $y )   or next;

			return;
	}
}



## Отрисовка всех объектов
sub draw {
	my( $app_rect ) =  @_;

	$app_rect->{ app }->draw_rect([
		0,
		0,
		$app_rect->{ app }->width,
		$app_rect->{ app }->height,
	],[ 0, 0, 0, 0 ]);
	$app_rect->SUPER::draw;

	$app_rect->{ btn     }->draw;
	$app_rect->{ btn_del }->draw;
	$app_rect->{ btn_c   }->draw;
	if( $app_rect->{ first } ) {
		$app_rect->{ first }->draw;
	}

	$app_rect->{ app }->update;
}


# tv $app_rect->{ is_over }
# tv %$app_rect
# tv @array

1;
