#!/usr/bin/env perl

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 09/19/2010 11:55:26
#

use strict;
use warnings;

BEGIN {
    push @INC, q{./lib/} if -d q{./lib/};
}

use Image;
use Image::Optimizer;

use File::Find;
use Number::Bytes::Human qw(format_bytes);
use Try::Tiny;

#
# GetOptions
#

my $search_directory = $ARGV[0] || die "Inform the search directory.";

$search_directory = $ENV{PWD} . "/" . $search_directory
    if ( $search_directory !~ /^\/.*?/ );

print "Searching images on: ", $search_directory, "\n";

#
# Searching and optimizing
#

my @image_paths;
my @optimized_images;

try {
    find(
        sub {
            push @image_paths, $File::Find::name
                if /.*?\.(jpeg|jpg|png|gif)$/i;
        },
        $search_directory
    );
}
catch {
    die "Cannot find any image on $search_directory"
        if ( defined $_ or @image_paths );
};

print "Found ", $#image_paths, " images at '", $search_directory, "'\n";

foreach my $path (@image_paths) {
    my ( $img, $opt, $end );

    try {
        $img = Image->new( { path => $path } ) or die $!;
        $opt = Image::Optimizer->new( { image => $img } ) or die $!;
        $end = $opt->run() or die $!;
    }
    catch {
        warn "Cannot create object or optimize: $_"
            and next;
    };

    # optimization has no good result
    if ( $end->_size >= $img->_size ) {
        print "\n(WARN) No reduction: ", $img->path, "\n";
        $end->unlink or warn $!;
        next;
    }

    push @optimized_images, { img => $img, opt => $end }
        and print "*";
}

#
# Analizing the results
#

my ( $size_after, $size_before ) = ( 0, 0 );

foreach my $img (@optimized_images) {
    $size_after  += $img->{img}->_size();
    $size_before += $img->{opt}->_size();
    $img->{opt}->unlink();
}

print "\n" x 2;
print "Size -- Before: ", format_bytes($size_after),  "\n";
print "Size --- After: ", format_bytes($size_before), "\n";
print "Size Reduction: ", format_bytes( $size_after - $size_before ), "\n";

__END__
