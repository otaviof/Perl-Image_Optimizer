#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 22:52:45
#

use strict;
use warnings;

use File::stat;
use Test::More tests => 4;

use Image::Optimizer;
use Image;

my $base_dir  = 't/images/';
my $file_name = 'booking.png';

my $img = Image->new( { path => $base_dir . $file_name } )
    or die $!;
my $opt = Image::Optimizer->new( { image => $img } )
    or die $!;

my $run = $opt->_optimize_png();

ok( $run,             "Should Pass, run PNG optimization should work." );
ok( -d $opt->dir_out, "Should Pass, output dir should exists." );
ok( -f $opt->dir_out . '/' . $file_name,
    "Should Pass, output file should exists."
);

my $old_stat = stat( $base_dir . $file_name )           or die $!;
my $new_stat = stat( $opt->dir_out . '/' . $file_name ) or die $!;

cmp_ok( $old_stat->size, '>', $new_stat->size,
    "Should Pass, old file size is higher than newer" );

# clean things up
unlink $opt->dir_out . '/' . $file_name
    and rmdir $opt->dir_out;

__END__
