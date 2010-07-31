#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 00:43:09
#

use strict;
use warnings;

use Test::More tests => 3;

BEGIN {
    use_ok('Image');
    use Image;
}

my $img;

eval { $img = Image->new(); };
ok( !$img and $@, "Should Fail, no image informed ($@)." );

( $img, $@ ) = ( undef, undef );

eval { $img = Image->new( { path => '/tmp/' . rand(1000) . '.txt' } ) };
ok( !$img and $@, "Should Fail, file don't exists. ($@)." );

__END__
