#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/02/2010 16:47:51
#

use strict;
use warnings;

use File::Copy;
use Test::More tests => 3;

BEGIN {
    use_ok('Image');
    use Image;
}

my $full_path = sprintf( "/var/tmp/%f.gif", rand 1000 );
copy( 't/images/1699091.gif', $full_path )
    or die "Copy failed: $!";

my $img = Image->new( { path => $full_path } ) or die $!;

ok( $img->unlink(), "Should Pass, this method exists." );
ok( !-f $img->path, "Should Fail, this file should't exists" );

__END__
