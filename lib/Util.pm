package Util;

use strict;
use warnings;

use SDL::Event;

use Schema;

my $DB =  {
	NAME => 'game_n',
	HOST => '127.0.0.1',
	DRVR => 'Pg',
	USER => 'gamer_n',
	PASS => 'V74F3iV4xQ1NAcdp',
	PORT => '5438',
	CLEAN_PASS => 'Zo4Tb7uuJUfJRNAZ',
	CLEAN_USER => 'game_n_cleaner',
};

my $schema;
sub db {
	return $schema   if $schema;

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

sub clear_database {
	my $dsn =  $DB->{ DSN } =  sprintf "dbi:%s:dbname=postgres;host=%s;port=%s",  @$DB{ qw/ DRVR HOST PORT / };

	my $schema =  Schema->connect( $dsn,  @$DB{ qw/ CLEAN_USER CLEAN_PASS / },  {
		AutoCommit => 1,
		RaiseError => 1,
	});

	$schema->storage->dbh->do( "DROP   DATABASE IF EXISTS $DB->{ NAME }" );
	$schema->storage->dbh->do( "CREATE DATABASE           $DB->{ NAME }" );

	$schema->storage->dbh->do( <<"		SQL" =~ s!^\t\t!  !grm
		DROP ROLE IF EXISTS $DB->{ USER };
		CREATE ROLE $DB->{ USER }
		  NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN
		  PASSWORD '$DB->{ PASS }'
		;
		SQL
	);
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

	return !defined $max  ||  $value > $max ? $value : $max;
}



sub min {
	my( $value, $min ) =  @_;

	return !defined $min  ||  $value < $min ? $value : $min;
}



1;
