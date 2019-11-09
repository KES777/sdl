package Schema::Result;

use Modern::Perl;
use base 'DBIx::Class::Core';

# Put useful things here which will be available from any Result:: class
__PACKAGE__->load_components(qw/
	InflateColumn::Serializer
	InflateColumn::DateTime
/);


1;
