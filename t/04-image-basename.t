#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/02/2010 17:55:10
#

use strict;
use warnings;

use Test::More tests => 1;

use Image;

my $gif = 't/images/1699112.gif';

my $img = Image->new( { path => $gif } ) or die $!;

cmp_ok( "1699112.gif", 'eq', $img->_basename, "Should Pass, basename must work." );

__END__
