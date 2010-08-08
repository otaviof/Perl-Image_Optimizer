#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/02/2010 16:28:27
#

use strict;
use warnings;

use File::Basename qw(dirname);
use File::Path;
use File::Copy;
use File::Temp qw(tempdir);
use Test::More tests => 3;

BEGIN {
    use_ok('Image');
    use Image;
}

my $temp_dir = '/tmp/' . rand(1000);
mkdir($temp_dir);
my $full_path = tempdir( DIR => $temp_dir ) . '1699091.gif';

copy( 't/images/1699091.gif', $full_path )
    or die "Copy failed: $!";

my $img = Image->new( { path => $full_path } ) or die $!;

ok( $img->destroy(), "Should Pass, this method exists." );
ok( !-d dirname( $img->path ),
    "Should Fail, this directory should't exists" );

rmdir dirname( $img->path ) or warn $!
    if ( -d dirname( $img->path ) );

__END__
