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



sub max {
	my( $value, $max ) =  @_;

	$value =  $value > $max ? $max : $value;
	return ( $value );
}



sub min {
	my( $value, $min ) =  @_;

	$value =  $value < $min ? $min : $value;
	return ( $value );
}



1;
