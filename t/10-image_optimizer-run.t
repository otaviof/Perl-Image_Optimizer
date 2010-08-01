#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 02:14:12
#

use strict;
use warnings;

use Test::More tests => 3;

use Image::Optimizer;
use Image;

my $img = new_ok( 'Image', [ { path => 't/images/1247136.gif' } ] );
my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );

ok( $opt->run(), "Should Pass, this method exists and return true." );

__END__
