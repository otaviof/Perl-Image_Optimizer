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
my $full_path = sprintf "%s/%s%s", $ENV{PWD}, $base_dir, $file_name;

my $img = Image->new( { path => $full_path } )       or die $!;
my $opt = Image::Optimizer->new( { image => $img } ) or die $!;

ok( $opt->_optimize_png(), "Should Pass: run PNG optimization must work." );

isa_ok(
    $opt->image_out, 'Image',
    "Should Pass: this is a new image."
);

ok( -d $opt->dir_out,         "Should Pass: output dir should exists."  );
ok( -f $opt->image_out->path, "Should Pass: output file should exists." );
ok(    $opt->is_optimized(),  "Should Pass: Yes, it is."                );

# clean things up
$opt->image_out->unlink() or warn "Error on unlink.";

__END__
