#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 02:14:12
#

use strict;
use warnings;

use Test::More tests => 6;

use Image::Optimizer;
use Data::Dumper;
use Image;

# optimizing PNG
{
    my $gif = sprintf( "%s/%s", $ENV{PWD}, 't/images/1247136.gif' );
    my $img = new_ok( 'Image',            [ { path  => $gif } ] );
    my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );
    ok( $opt->run(),
        "Should Pass, this method exists and can optimize an PNG." );
}

# optimizing JPG
{
    my $jpg = sprintf( "%s/%s", $ENV{PWD}, 't/images/1699089.jpg' );
    my $img = new_ok( 'Image',            [ { path  => $jpg } ] );
    my $opt = new_ok( 'Image::Optimizer', [ { image => $img } ] );
    ok( $opt->run(),
        "Should Pass, this method exists and can optimize an JPG." );
}

__END__
