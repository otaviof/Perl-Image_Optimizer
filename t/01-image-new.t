#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 00:43:09
#

use Test::More tests => 6;

use Try::Tiny;

BEGIN {
    use_ok('Image');
    use Image;
}

# Image class wihout a path, should die
try { Image->new( { path => "" } ); }
catch {
    like( $_, qr/No such imag/, "Should Fail, there's no such empty path." );
};

# There's a path, but the file doesn't exists
try { Image->new( { path => "/tmp/" . rand(1000) . ".txt" } ); }
catch {
    like( $_, qr/No such image/, "Should Fail, there's no such path." );
};

# Testint with a truly image, should pass
{
    my $img = new_ok( 'Image',
        [ { path => $ENV{PWD} . "/t/images/1247136.gif" } ] );
    isa_ok( $img, 'Image' );
    is( $img->type, "image/gif", "Should Pass, this image is a gif." );
}
__END__
