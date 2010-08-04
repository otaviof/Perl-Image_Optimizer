#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 23:16:18
#

use strict;
use warnings;

use Test::More tests => 3;

use Image::Optimizer;
use Image;

my $base_dir  = "t/images/";
my $file_name = "1699105.jpg";
my $full_path = sprintf( "%s/%s%s", $ENV{PWD}, $base_dir, $file_name );

my $img = Image->new( { path => $full_path } ) or die $!;
my $opt = Image::Optimizer->new( { image => $img } ) or die $!;

my $run = $opt->_optimize_jpg();

ok( $run, "Should Pass, run JPG (jpegtran) optimization should work." );
ok( -f $run->path,    "Should Pass, output file should exists." );

cmp_ok( $img->_size, '>', $run->_size,
    "Should Pass, old file size is higher than newer" );

# clean things up
$run->unlink() or warn "Error on unlink ($run)";

__END__
