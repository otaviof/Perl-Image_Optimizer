#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 02:14:12
#

use strict;
use warnings;

use Test::More tests => 12;

use Image::Optimizer;
use Data::Dumper;
use Image;

# optimizing GIF (to PNG)
{
    my $gif = sprintf( "%s/%s", $ENV{PWD}, 't/images/1626084.gif' );
    my $img = new_ok( 'Image',            [ { path  => $gif } ] );
    my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );

    my $png = $opt->run();

    ok( $png, "Should Pass, method run() should return." );
    cmp_ok( $img->_size, '>', $png->_size,
        "Should Pass, Thats my job!! (GIF > PNG)." );
}

# optimizing JPG
{
    my $jpg = sprintf( "%s/%s", $ENV{PWD}, 't/images/1699091.jpg' );
    my $img = new_ok( 'Image',            [ { path  => $jpg } ] );
    my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );

    my $new_jpg = $opt->run();
    ok( $new_jpg,
        "Should Pass, this method exists and can optimize an JPG." );
    cmp_ok( $img->_size, '>=', $new_jpg->_size,
        "Should Pass, Thats my job!! (JPG > new JPG)." );
}

# optimizing PNG
{
    my $png = sprintf( "%s/%s", $ENV{PWD}, 't/images/booking.png' );
    my $img = new_ok( 'Image',            [ { path  => $png } ] );
    my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );

    my $new_png = $opt->run();
    ok( $new_png,
        "Should Pass, this method exists and can optimize an JPG." );
    cmp_ok( $img->_size, '>=', $new_png->_size,
        "Should Pass, Thats my job!! (PNG > new PNG)." );
}

__END__
