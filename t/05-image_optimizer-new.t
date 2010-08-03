#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 01:54:46
#

use strict;
use warnings;

use Test::More tests => 3;
use Try::Tiny;

BEGIN {
    use_ok('Image::Optimizer');
    use Image::Optimizer;
    use Image;
}

try { Image::Optimizer->new(); }
catch {
    like( $_, qr/image.*?required/,
        "Should Fail, no parameters for the new object." );
};

my $obj = new_ok(
    'Image::Optimizer',
    [   {   image =>
                Image->new( { path => $ENV{PWD} . '/t/images/1247136.gif' } )
        }
    ]
);

__END__
