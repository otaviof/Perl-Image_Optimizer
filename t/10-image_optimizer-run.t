#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 02:14:12
#

use strict;
use warnings;

use Test::More tests => 17;

use Image::Optimizer;
use Data::Dumper;
use Image;

# optimizing GIF (to PNG)
{
    my $gif = sprintf "%s/%s", $ENV{PWD}, 't/images/1626084.gif';
    my $img = new_ok( 'Image',            [ { path  => $gif } ] );
    my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );

    ok( $opt->run(), "Should Pass: method run() should return." );

    isa_ok( $opt->image_out, "Image", "Should Pass: image_out is Image." );
    isa_ok( $opt->swap,      "Image", "Should Pass: swap is Image." );

    cmp_ok( $img->_size, '>=', $opt->image_out->_size,
        "Should Pass: GIF >= PNG (opt)." );
    ok( $opt->is_optimized, "Should Pass: Yes, it is." );
}

# optimizing JPG
{
    my $jpg = sprintf "%s/%s", $ENV{PWD}, 't/images/1699091.jpg';
    my $img = new_ok( 'Image',            [ { path  => $jpg } ] );
    my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );

    ok( $opt->run(), "Should Pass: optimize a JPG." );
    cmp_ok( $img->_size, '>=', $opt->image_out->_size,
        "Should Pass: JPG >= new JPG." );
    ok( $opt->is_optimized, "Should Pass: Yes, it is." );
}

# optimizing PNG
{
    my $png = sprintf "%s/%s", $ENV{PWD}, 't/images/booking.png';
    my $img = new_ok( 'Image',            [ { path  => $png } ] );
    my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );

    $opt->run();
    ok( $opt->run(), "Should Pass: optimize PNG." );
    cmp_ok( $img->_size, '>=', $opt->image_out->_size,
        "Should Pass: PNG >= new PNG." );
    ok( $opt->is_optimized, "Should Pass: Yes, it is." );
}

__END__
