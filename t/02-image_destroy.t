#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/02/2010 16:28:27
#

use strict;
use warnings;

use Test::More tests => 1;

BEGIN {
    use_ok('Image');
    use Image;
}

my $img = Image->new( { path => 't/images/1699091' } ) or die $!;

ok( $img->destroy(), "Should Pass, this method exists." );

__END__
