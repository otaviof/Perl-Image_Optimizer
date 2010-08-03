#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 22:52:45
#

use strict;
use warnings;

use File::stat;
use Test::More tests => 5;

use Image::Optimizer;
use Image;

my $base_dir  = 't/images/';
my $file_name = 'booking.png';
my $full_path = sprintf( "%s/%s/%s", $ENV{PWD}, $base_dir, $file_name );

my $img = Image->new( { path => $full_path } ) or die $!;
my $opt = Image::Optimizer->new( { image => $img } ) or die $!;

my $run = $opt->_optimize_png();

ok( $run, "Should Pass, run PNG optimization should work." );

isa_ok( $run, 'Image', "Should Pass, this is a new image." );

ok( -d $opt->dir_out, "Should Pass, output dir should exists." );
ok( -f $run->path,    "Should Pass, output file should exists." );

cmp_ok( $img->_size, '>', $run->_size,
    "Should Pass, old file size is higher than newer" );

# clean things up
$run->unlink;

__END__
