#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 02:43:02
#

use strict;
use warnings;

use Test::More tests => 3;

BEGIN {
    use_ok('Image::PNG');
    use Image::PNG;
    use Image;
}

my $png;
eval { $png = Image::PNG->new(); };
ok( !$png and $@, "Should Fail, no Image object informed." );
undef $png, $@;

my $img = Image->new( { path => 't/images/booking.png' } );
$png = new_ok( 'Image::PNG', [ { image => $img } ] );

use Image::Optimizer;
my $opt = Image::Optimizer->new( { image => $img } ) or die $!;

__END__