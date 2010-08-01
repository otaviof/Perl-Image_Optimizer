#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 01:54:46
#

use strict;
use warnings;

use Test::More tests => 3;

BEGIN {
    use_ok('Image::Optimizer');
    use Image::Optimizer;
    use Image;
}

my $opt;

eval { $opt = Image::Optimizer->new(); };
ok( !$opt and $@, "Shoud Fail, there's no image object." );

$opt = new_ok( 'Image::Optimizer',
    [ { image => Image->new( { path => 't/images/1247136.gif' } ) } ] );

__END__
