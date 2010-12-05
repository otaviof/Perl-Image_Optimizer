#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/04/2010 19:37:01
#

use strict;
use warnings;

use Data::Dumper;
use Test::More skip_all => q(No crawling for now.);
use WWW::Mechanize::Image;
use WWW::Mechanize;
use File::Slurp;

use Image::Optimizer;
use Image;

my $mech = WWW::Mechanize->new() or die $!;

my $tdir = sprintf( '/var/tmp/crawler_%f/', rand(100) );
mkdir($tdir) or die $!;

my $size_before = 0;
my $size_after  = 0;

foreach my $site ( read_file('t/image_urls.txt') ) {
    next if ( $site =~ /^\#/ );
    chomp($site);
    diag( sprintf( "\n* Images from: %s\n", $site ) );

    $mech->get($site)
        or next;

    foreach my $img_url (
        $mech->find_all_images( url_regex => qr/\.(png|jpg|jpeg|gif)/i ) )
    {
        $mech->get( $img_url->url )
            or die $!;

        my $uri = $img_url->URI();
        my $rpath = $tdir . ( $uri->path_components() )[-1];

        $mech->save_content($rpath)
            if !-f $rpath;

        my $img_before = Image->new( { path => $rpath } ) or die $!;
        my $optimizer = Image::Optimizer->new( { image => $img_before } )
            or die $!;
        my $img_after = $optimizer->run() or die $!;

        ok( $img_after, "Should Pass, we can optimize an image" ) or next;
        ok( $img_after->type ) or next;

        ok( $img_after,
                  "Optimized: "
                . $img_before->type
                . " loses: "
                . ( $img_before->_size - $img_after->_size )
                . " bytes." )
            or next;

        $size_before += $img_before->_size;
        $size_after  += $img_after->_size;

        $img_after->unlink();
    }
}

done_testing();

sub bytes_to_kilo($) {
    my ($bytes) = @_;
    return sprintf( "%0.2f", $bytes / 1024 );
}

diag("\n");
diag( "Size before:   ", bytes_to_kilo $size_before,               " kb\n" );
diag( "Size  after: - ", bytes_to_kilo $size_after,                " kb\n" );
diag( "####### Sum:   ", bytes_to_kilo $size_before - $size_after, " kb\n" );

__END__
