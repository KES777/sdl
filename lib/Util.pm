package Util;

use strict;
use warnings;

use SDL::Event;

use Schema;

my $schema;
sub db {
	return $schema   if $schema;

	my $DB =  {
		NAME => 'game_n',
		HOST => '127.0.0.1',
		DRVR => 'Pg',
		USER => 'gamer_n',
		PASS => 'V74F3iV4xQ1NAcdp',
		PORT => '5433',
	};
	$DB->{ DSN } =  sprintf "dbi:%s:dbname=%s;host=%s;port=%s",  @$DB{ qw/ DRVR NAME HOST PORT / };

	$schema //=  Schema->connect( $DB->{ DSN },  @$DB{ qw/ USER PASS / },  {
		AutoCommit => 1,
		RaiseError => 1,
		PrintError => 1,
		ShowErrorStatement => 1,
		# HandleError => sub{ DB::x; 1; },
		# unsafe => 1,
		quote_char => '"',  # Syntax error: SELECT User.id because of reserwed word
	});
	return $schema;
}



sub pause_handler {
	my ($event, $app) = @_;

	if( $event->type == SDL_QUIT ) {
		$app->stop;
	}

	elsif($event->type == SDL_ACTIVEEVENT) {
		if($event->active_state & SDL_APPINPUTFOCUS) {
			if($event->active_gain) {
				return 1;
			}
			else {
				$app->pause(\&pause_handler);
			}
		}
	}

	elsif($event->type == SDL_KEYDOWN) {
		if($event->key_sym == SDLK_SPACE) {
			return 1 if $app->paused;

			$app->pause(\&pause_handler);
		}
	}
}



sub mouse_target_square {
	my( $object, $x, $y ) =  @_;

	return $x >= $object->{ x }
		&& $x <= $object->{ x } + $object->{ w }
		&& $y >= $object->{ y }
		&& $y <= $object->{ y } + $object->{ h }
}



sub resize_field_rect {
	my( $rect, $x, $y ) =  @_;

	return $x > $rect->{ x } + $rect->{ w } - 15
		&& $x < $rect->{ x } + $rect->{ w }
		&& $y > $rect->{ y } + $rect->{ h } - 10
		&& $y < $rect->{ y } + $rect->{ h }
}



sub resize_field_circle {
	my( $rect, $x, $y ) =  @_;

	return $x > $rect->{ x } + $rect->{ radius } - 15
		&& $x < $rect->{ x } + $rect->{ radius }
		&& $y > $rect->{ y } - 5
		&& $y < $rect->{ y } + 5
}


1;
