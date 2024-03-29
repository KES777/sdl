package AppRect;

use strict;
use warnings;

use threads;
use threads::shared;
use SDL::Time;

use SDLx::App;
use SDL::Event;
use Scalar::Util qw/ weaken blessed /;


use Dumper;
use Rect;
use Btn_del;
use Btn;
use Circle;
use Btn_Circle;
use Table;
use Cursor;

use base 'Shape';


my $HINT_EVENT;
my $HINT_TIMER =  1000;
my $APP;
sub SCREEN { return $APP }



# Добавляет обработчик и возвращает следующий номер для пользовательского события
my $next_user_event_type =  0;
sub user_event {
	my( $handler, $code, $data ) =  @_;

	my $user_event =  SDL_USEREVENT + $next_user_event_type++;

	## Генерация функции для создания пользовательского события
	no strict 'refs';
	my $sub_name =  "AppRect::issue_event_$user_event";
	*{ $sub_name } =  sub{
		my $event =  SDL::Event->new();
		$event->type( $user_event );
		$event->user_code( $code );
		$event->user_data1( $data );

		SDL::Events::push_event( $event );

		return 0;
	};


	## Регистрируем обработчик для пользовательского события
	$APP->add_event_handler( sub{
		#my( $e ) =  @_;
		$_[0]->type == $user_event   or return;

		&$handler;
	});


	## Возвращаем имя функции, которая генерирует пользовательское событие
	return $sub_name;
}


# Создание окна приложения с какими-то формами
sub new {
	my( $rect, $app_w, $app_h ) =  @_;

	my $app_rect =  $rect->SUPER::new();

	$app_rect->{ w } =  $app_w;
	$app_rect->{ h } =  $app_h;
	$app_rect->{ c } =  Color::new( 0, 0, 0, 0 );


	$APP =  $app_rect->{ app } =  SDLx::App->new(
		width      =>  $app_w, ## Окно видимиости (ширина)
		height     =>  $app_h, ## Окно видимиости (длина)
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


	## Load data
	$app_rect->{ children } =  [];
	$app_rect->load_children;

	# $APP->add_event_handler( sub{ _on_down( @_, $app_rect ) } );
	# $APP->add_event_handler( sub{ _on_move( @_, $app_rect ) } );

	# Добавление в приложение функции, которая отвечает за рисование
	$APP->add_show_handler ( sub{ $app_rect->draw } );

	$HINT_EVENT =  user_event( sub{
		my( $e, $app ) =  @_;

		##!
		if( my $h =  $app_rect->{ is_hint } ) {
			$h->{ target }->on_hint( $h, $h->{ x }, $h->{ y } );
		}
	});

	# Добавление обработчиков событий в приложение
	$APP->add_event_handler( sub{ _on_mouse_move( @_, $app_rect ) } );
	$APP->add_event_handler( sub{ _is_mousedown ( @_, $app_rect ) } );
	$APP->add_event_handler( sub{ _is_mouseup   ( @_, $app_rect ) } );

	$APP->add_event_handler( sub{ _observer( @_, $app_rect ) } );


	return $app_rect;
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

		# TODO: send key event to active element
		# if( my $h =  $app_rect->{ is_over } ) {
		# 	$h->{ target }->on_keydown( $h, $e );
		# }

		my $act =  $app_rect->{ active };
		if( my $bool =  $app_rect->on_keydown( $act, $e ) ) {
			delete $app_rect->{ active };
			delete $app_rect->{ first };
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



sub handle {
	my( $app_rect, $key, $props ) =  @_;

	@_ > 2   or return $app_rect->{ $key };
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
	if( !$app_rect->{ is_over }
		&&  !$app_rect->{ is_selection }
		&&  !$app_rect->{ event_state }{ SDLK_s() }
	) {
		$app_rect->handle( is_selection => {
			target =>  $app_rect->{ is_over } || $app_rect,
			draw   =>  Selection->new( $e->motion_x, $e->motion_y, 0, 0,
						Color->new( 0, 0, 0, 0 ) )
		} );
		# DDP::p $h;
		# unshift $app_rect->{ children }->@*, $app_rect->{ is_selection }{ draw };?
	}




	##! PRESS
	if( my $h =  $app_rect->{ is_over } ) {
		$h->{ target }->on_press( $h, $e );
		$app_rect->handle( is_down => $h );
	}

	## on_shift
	if( $app_rect->{ event_state }{ SDLK_s() } ) {
		if( my $h =  $app_rect->{ is_over } ) {
			$app_rect->handle( on_shift => {
				target =>  $h->{ target },
				x      =>  $e->motion_x,## стартовые координаты ("х", "у") курсора
				y      =>  $e->motion_y,
			} );
		}
		else {
			$app_rect->handle( on_shift => {
				target =>  $app_rect,
				x      =>  $e->motion_x,## стартовые координаты ("х", "у") курсора
				y      =>  $e->motion_y,
			} );
		}
	}
}




sub _active {
	my( $app_rect, $shape, $e ) =  @_;

	if( !$app_rect->{ active } ) {
		$app_rect->{ active } =  $app_rect;
		weaken $app_rect->{ active };
	}


	if( $app_rect->{ active } != $shape ) {
		$app_rect->{ active }->off_active;
		$app_rect->{ active } =  $shape;
	}

	$app_rect->{ active }->on_active;
}



sub _is_mouseup {
	my( $e, $app, $app_rect ) =  @_;

	$e->type == SDL_MOUSEBUTTONUP
		or return;


	## Выключение свойства "изменение размеров объекта"
	if( my $h =  $app_rect->handle( on_resize => undef ) ) {
		$h->restore_state;## Возврат цвета объекту
		$h->store;
	}

	## Выключение свойства "движение объекта"
	##! MOVE STOP
	if( my $h =  $app_rect->handle( is_moveable => undef ) ) {
		$h->{ target }->on_drop( $e, $h );
	}

	## Создание группы из поля selection
	if( my $h =  $app_rect->handle( is_selection => undef ) ) {
		delete $app_rect->{ back };
		if( my $group =  $app_rect->_can_group( $h, $e ) ) {
			$group->{ target }->on_group( $h, $e, $group );
		}

		$h->{ draw }->draw_black;## Затираем перед удалением
	}

	## Удаление свойства first (отрисовка объекта первым)
	delete $app_rect->{ first };


	## ! RELEASE
	if( my $h =  $app_rect->{ is_over } ) {
		$h->{ target }->on_release( $h, $e );
	}


	##! CLICK
	my $up  =  $app_rect->{ is_over };
	my $dw  =  $app_rect->handle( is_down => undef );
	my $dcl =  $app_rect->handle( is_double_click => undef );
	my $tcl =  $app_rect->handle( is_triple_click => undef );


	if( $up  &&  $dw  &&  $up->{ target } == $dw->{ target } ) {
		if   ( $tcl  &&  (SDL::get_ticks() -$tcl->{ time }) < 1000 ) {
			# $tcl->{ target }->on_triple_click( $up, $e );

			# $app_rect->handle( is_quad_click => { %$up,
			# 	time => SDL::get_ticks(),
			# });
		}
		elsif( $dcl  &&  (SDL::get_ticks() -$dcl->{ time }) < 1000 ) {
			$dcl->{ target }->on_double_click( $up, $e );

			$app_rect->handle( is_triple_click => { %$up,
				time => SDL::get_ticks(),
			});
		}
		# else ( $dw   &&  (SDL::get_ticks() -$dcl->{ time }) < 1000 ) {
		else {
			$up->{ target }->on_click( $up, $e );
			$app_rect->_active( $up->{ target }, $e );
			$app_rect->handle( is_double_click => { %$up,
				time => SDL::get_ticks(),
			});
		}
	}
	else {
		$app_rect->_active( $app_rect, $e );
	}

	## off_shift
	if( my $h =  $app_rect->handle( on_shift => undef ) ) {
		$h->{ target }->off_shift;

		delete $h->{ target }{ old_x };
		delete $h->{ target }{ old_y };
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
	$app_rect->handle( is_over => $no );

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
		&&	!$app_rect->{ event_state }{ SDLK_s() }
		&&  ( my $h =  $app_rect->{ is_down } )
	) {
		$h->{ target }->on_drag( $e, $h );
		$app_rect->handle( is_moveable =>  $h );
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
	if( my $h =  $app_rect->handle( is_hint => undef ) ) {
		SDL::Time::remove_timer( $h->{ timer_id } );
	}

	if( $no ) {
		my $timer_id =  SDL::Time::add_timer( $HINT_TIMER, $HINT_EVENT );
		$app_rect->handle( is_hint => { %$no,
			timer_id =>  $timer_id,
			x        =>  $e->motion_x,
			y        =>  $e->motion_y,
		});
	}



	#### Nazar
	## Отрисовка объекта (над которым курсор) поверх других
	if( my $h =  $app_rect->{ is_over } ) {
		$app_rect->{ first } =  $h->{ owner };
	}

	## Отрисовка движущегося объекта поверх других
	if( my $h =  $app_rect->{ is_moveable } ) {
		$app_rect->{ first } =  $h->{ owner };
	}

	## Отрисовка объкта selection позади других объектов
	if( my $h =  $app_rect->{ is_selection } ) {
		$app_rect->{ back } =  $h->{ draw };
	}

	## on_shift
	if( my $h =  $app_rect->{ on_shift } ) {
		$h->{ target }->on_shift( $h, $e->motion_x, $e->motion_y );
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
	$app_rect->handle( is_over => _is_over( @_ ) );
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



## Отрисовка всех объектов
sub draw {
	my( $app_rect ) =  @_;

	$app_rect->{ app }->draw_rect([
		0,
		0,
		$app_rect->{ app }->width,
		$app_rect->{ app }->height,
	],[ 0, 0, 0, 0 ]);
	if( $app_rect->{ back } ) {
		$app_rect->{ back }->draw;
	}
	$app_rect->propagate( "draw" );


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
