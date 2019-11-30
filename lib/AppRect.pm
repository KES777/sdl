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

use base 'Rect';



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


	$APP->add_event_handler( sub{ _drag_flag    ( @_, $app_rect ) } );

	$APP->add_event_handler( sub{ _observer( @_, $app_rect ) } );

	return $app_rect;
}


## Включает свойство hint (по событию USEREVENT )
sub _on_user_event {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_USEREVENT   or return;

	if( my $h =  $app_rect->{ is_hint } ) {
		$h->{ target }->on_hint( $h, $e, $app_rect );
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
	}

	if( $e->type == SDL_KEYUP ) {
		$app_rect->{ event_state }{ $e->key_sym } =  0;
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



sub _is_mousedown {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONDOWN
		or return;


	## Создание свойства (ключа) "изменение размеров объекта"
	if( my $h =  $app_rect->{ is_over_rf } ) {
		$h->resize_color;
		$app_rect->{ on_resize } =  $h;
	}


	## Создание свойства (ключа) "передвижение объекта"
	if( (my $h =  $app_rect->{ is_over })  &&  !$app_rect->{ is_over_rf } ) {
		if( $h->{ target } ){
			$h->{ target }->on_press( $h, $e );


			if( $h->{ target }->{ parent }  &&  $app_rect->{ drag } ) {
				$h->{ target }->drag( $h, $app_rect, $e );
			}

			if( my $move =  $h->{ target }->is_moveable( $h, $e ) ) {
				$app_rect->{ is_moveable } =  $move;
				$move->{ target }->moving_on( $e );
			}
		}
	}

	## Создание поля selection
	# if( (!$app_rect->{ is_over } || "CTRL_KEY"  )  &&  !$app_rect->{ is_selection } ) {
	if( !$app_rect->{ is_over }  &&  !$app_rect->{ is_selection } ) {
		# $app_rect->{ is_selection } =  Selection->new(
		# 	$e->motion_x, $e->motion_y, 0, 0,
		# 	Color->new( 0, 0, 0 )
		# );
		my $h =  {
			target =>  $app_rect->{ is_over } || $app_rect,
			draw   =>  Selection->new( $e->motion_x, $e->motion_y, 0, 0,
						Color->new( 0, 0, 0 ) )
		};
		DDP::p $h;
		$app_rect->{ is_selection } =  $h;
	}


	##! CLICK
	if( my $h =  $app_rect->{ is_over } ) {
		$app_rect->{ is_click }{ type } =  'CLICK';
		$app_rect->{ is_click }->@{ keys %$h } =  values %$h;
	}
}


## Флаг для начала функции drag
sub _drag_flag {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_KEYDOWN
	&&  $e->key_sym == SDLK_d
		or return;


	$app_rect->{ drag } =  1;

}



sub _is_mouseup {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONUP
		or return;

	delete $app_rect->{ drag };


	## Выключение свойства "изменение размеров объекта"
	if( my $h =  $app_rect->{ on_resize } ) {

		$h->restore_state;## Возврат цвета объекту
		$h->store;

		delete $app_rect->{ on_resize };
	}

	## Выключение свойства "движение объекта"
	if( my $h =  $app_rect->{ is_moveable } ) {

		my $shape =  $h->{ target };
		# $shape->delete_target( $e, $app_rect );
		$shape->moving_off( $app_rect, $e );
		$shape->store;

		delete $app_rect->{ is_moveable };

		## Drop object
		if( my $group_rect =  $shape->can_drop( $app_rect, $e->motion_x, $e->motion_y ) ) {
			$group_rect->{ target }->drop( $shape, $app_rect, $e->motion_x, $e->motion_y );
		}
	}

	## Создание группы из поля selection
	if( my $h =  $app_rect->{ is_selection } ) {
		if( my $group =  $app_rect->_can_group( $h, $e ) ) {
			$group->{ target }->on_group( $h, $e, $group );
		}

		# $h->draw_black;
		$h->{ draw }->draw_black;
		delete $app_rect->{ is_selection };
	}


	##! CLICK
	if( my $ch =  $app_rect->{ is_click } ) {
		delete $app_rect->{ is_click };


		##! DBL CLICK
		if( my $dh =  $app_rect->{ is_dbl_click } ) {
			delete $app_rect->{ is_dbl_click }; # TODO: удалять лучше сначала

			if( $dh->{ target } == $ch->{ target }
				&&  (SDL::get_ticks() -$dh->{ time }) < 2000
			) {
				$dh->{ target }->on_dbl_click( $dh, $e );
			}

		}
		else {
			$ch->{ target }->on_click( $ch, $e );
			$app_rect->{ is_dbl_click }->@{ keys %$ch } =  values %$ch;
			$app_rect->{ is_dbl_click }{ time } =  SDL::get_ticks();
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
	# $app_rect->{ is_over } =  _is_over( $app_rect, $e->motion_x, $e->motion_y );
	my $oo =  $app_rect->{ is_over };                             # OLD OVER
	my $no =  _is_over( $app_rect, $e->motion_x, $e->motion_y );  # NEW OVER
	$app_rect->{ is_over } =  $no;

	if( $no  &&  !$oo ) {
		$no->{ target }->on_mouse_over( $e );
	}

	if( $oo  &&  $no  &&  $no->{ target } != $oo->{ target } ) {
		$oo->{ target }->on_mouse_out( $e );
		$no->{ target }->on_mouse_over( $e );
	}

	if( $oo  &&  !$no ) {
		$oo->{ target }->on_mouse_out( $e );
	}

	##
	if( my $h =  $app_rect->{ is_moveable } ) {
		$h->{ target }->on_move( $h, $e, $app_rect );
	}

	## Активация свойства "изменение размеров" поля выделения
	if( my $h =  $app_rect->{ is_selection } ) {
		$h->{ draw }->on_resize( $h, $e );
	}

	##! HINT EVENT
	if( my $h =  $app_rect->{ is_hint } ) {
		delete $app_rect->{ is_hint };
		SDL::Time::remove_timer( $h->{ timer_id } );
	}

	if( $no ) {
		my $timer_id =  SDL::Time::add_timer( 1000, 'AppRect::callback3' );
		$app_rect->{ is_hint } =  {
			target   =>  $app_rect->{ is_over }->{ target },
			timer_id =>  $timer_id,
		}
	}

	##! CLICK
	delete $app_rect->{ is_click };


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
	$app_rect->{ is_over } =  _is_over( @_ );
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

	if( $app_rect->{ children } ) {
		for my $s ( $app_rect->{ children }->@* ) {
			$s   or next;
			$s->draw( $app_rect->{ app } );
		}
	}

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
