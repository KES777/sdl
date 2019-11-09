package Schema;

our $VERSION =  1;

#CHECK LIST:
# Pay attention when column is renamed: you probably should use RENAME instead
# of DROP/ADD

use strict;
use warnings;

# based on the DBIx::Class Schema base class
use base qw/DBIx::Class::Schema/;



# This will load any classes within
# App::Schema::Result and App::Schema::ResultSet (if any)
__PACKAGE__->load_namespaces(
	default_resultset_class =>  'ResultSet'
);



1;
