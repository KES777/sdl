package Color;




sub new {
	my( $color, $r, $g, $b, $a ) =   @_;

	my %color =  (
		r => $r //  23,
		g => $g // 220,
		b => $b // 190,
		a => $a // 180,
	);

	return bless \%color, $color;
}



sub get_color {
	my( $color ) =  @_;

	return map{ $_>255?255:$_ } $color->@{qw/ r g b a /};
	return $color->@{qw/ r g b a /};
}



sub geth_color {
	my( $color ) =  @_;

	return $color->%{qw/ r g b a /};
}



1;
