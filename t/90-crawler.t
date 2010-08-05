#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/04/2010 19:37:01
#

use strict;
use warnings;

use Data::Dumper;
use Test::More;
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
    chomp $site;
    diag("\n$site");

    $mech->get($site) or next;

    foreach my $img_url (
        $mech->find_all_images( url_regex => qr/\.(png|jpg|jpeg|gif)/i ) )
    {
        $mech->get( $img_url->url ) or next;

        my $uri = $img_url->URI();
        my $path = $tdir . ( $uri->path_components() )[-1];

        $mech->save_content($path)
            if !-f $path or next;

        my $img_before = Image->new( { path => $path } ) or next;
        my $optimizer = Image::Optimizer->new( { image => $img_before } )
            or next;
        my $img_after;

        eval { $img_after = $optimizer->run() };
        print "Error: " . $@ if $@;

        ok( $img_after, "Should Pass, we can optimize an image" ) or next;
        ok( $img_after->type ) or next;

        print "Debug -> img_before #", $img_before->_size, "#\n";
        print "Debug ->  img_after #", $img_after->_size,  "#\n";

        my $sum = $img_before->_size - $img_after->_size;

        print "Debug ->        sum #", $sum, "#\n";

        ok( $img_after,
                  "Optimized: "
                . $img_before->type
                . " loses: "
                . $sum
                . " bytes." );

        $size_before += $img_before->_size;
        $size_after  += $img_after->_size;

        $img_after->destroy();
    }

}

print "Total size before:   $size_before\n";
print "Total size after : - $size_after\n";
print "              Sum:   ", ( $size_before - $size_after ), "\n";

done_testing();

__END__
