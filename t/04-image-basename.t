#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/02/2010 17:55:10
#

use strict;
use warnings;

use File::stat;
use Test::More tests => 3;

use Image;

my $basename  = '1699112.gif';
my $dirname   = $ENV{PWD} . '/t/images';
my $full_path = $dirname . '/' . $basename;

my $img = Image->new( { path => $full_path } ) or die $!;

cmp_ok( $basename, 'eq', $img->_basename,
    "Should Pass, basename must work." );
cmp_ok( $dirname, 'eq', $img->_dirname, "Should Pass, dirname must work." );

cmp_ok(
    ( stat($full_path) )->size, '==', $img->_size, "Should Pass, sizes
    must be same."
);

__END__
