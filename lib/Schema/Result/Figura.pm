package Schema::Result::Figura;

use Modern::Perl;
use base 'Schema::Result';



my $X =  __PACKAGE__;
$X->table( 'figura' );

$X->add_columns(
	id => {
		data_type         =>  'integer',
		is_auto_increment =>  1,
	},
	x => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	y => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	w => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	h => {
		data_type   =>  'integer',
		is_nullable => 1,
	},
	r => {
		data_type   =>  'integer',
		default_value => 23,
	},
	g => {
		data_type   =>  'integer',
		default_value => 220,
	},
	b => {
		data_type   =>  'integer',
		default_value => 190,
	},
	a => {
		data_type   =>  'integer',
		default_value => 180,
	},
	parent_id => {
		data_type   =>  'integer',
		is_nullable => 1,
	},

);

$X->set_primary_key( 'id' );

1;

