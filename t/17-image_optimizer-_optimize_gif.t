#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/03/2010 15:59:31
#

use strict;
use warnings;

use Test::More tests => 3;

use Image::Optimizer;
use Image;

my $base_dir  = "t/images/";
my $file_name = "1922171.gif";
my $full_path = sprintf "%s/%s%s", $ENV{PWD}, $base_dir, $file_name;

my $img = Image->new( { path => $full_path } )       or die $!;
my $opt = Image::Optimizer->new( { image => $img } ) or die $!;

ok( $opt->_optimize_gif(), "Should Pass, this method must exists." );

isa_ok( $opt->image_out, "Image",
    "Should Pass, this method return an Image object." );

like( $opt->image_out->type, qr/image.*png/,
    "Should Pass, an optimize GIF should be a PNG." );

__END__
