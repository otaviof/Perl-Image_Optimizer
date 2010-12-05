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

my $img = Image->new( { path => $full_path } )       or die $!;
my $opt = Image::Optimizer->new( { image => $img } ) or die $!;

ok(    $opt->_optimize_jpg(), "Should Pass: run JPG (jpegtran) must work." );
ok( -f $opt->image_out->path, "Should Pass, output file should exists."    );
ok(    $opt->is_optimized,    "Should Pass: Yes, it is!"                   );

# clean things up
$opt->image_out->unlink() or warn "Error on unlink.";

__END__
