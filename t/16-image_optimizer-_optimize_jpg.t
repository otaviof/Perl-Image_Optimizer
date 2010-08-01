#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 23:16:18
#

use strict;
use warnings;

use Test::More tests => 1;

use Image::Optimizer;
use Image;

my $base_dir  = "t/images/";
my $file_name = "1247136.jpg";

my $img = Image->new( { path => $base_dir . $file_name } )
    or die $!;
my $opt = Image::Optimizer->new( { image => $img } )
    or die $!;

my $run = $opt->_optimize_jpg();

ok( $run, "Should Pass, run JPG (jpegtran) optimization should work." );

__END__
