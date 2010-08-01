#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 00:43:09
#

use strict;
use warnings;

use Test::More tests => 4;

BEGIN {
    use_ok('Image');
    use Image;
}

my @tests = (
    { path => '', },                               # nothing
    { path => '/tmp/' . rand(1000) . '.txt', },    # inexistent
    { path => 't/images/1247136.gif' },            # normal git
);

my $img;

foreach my $t (@tests) {
    eval {                                         # new Image obj
        $img = Image->new( ( $t->{path} ) ? { path => $t->{path} } : '' );
    };

    if ( !$t->{path} or !-f $t->{path} ) {
        ok( !$img and $@, "Should Fail, no image informed ($@)." );
    } else {
        isa_ok( $img, 'Image' );
    }

    ( $img, $@ ) = ( undef, undef );
}

__END__
