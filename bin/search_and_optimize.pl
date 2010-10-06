#!/usr/bin/env perl

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 09/19/2010 11:55:26
#

use strict;
use warnings;

BEGIN {
    my $lib_dir = './lib/';
    push @INC, $lib_dir if -d $lib_dir;
}

use Image;
use Image::Optimizer;

use File::Find;
use Number::Bytes::Human qw(format_bytes);
use Try::Tiny;

#
# GetOptions
#

my $output;
my $result = GetOptions( "out=s", \$output ) or die $!;
my $search_directory = $ARGV[$#$ARGV] || undef;

$search_directory = $ENV{PWD} . "/" . $search_directory
    if ( $search_directory !~ /^\/.*?/ );

die "Please inform and valid directory for output."
    if ( not defined $output or not -d $output );
die "Could not find this directory '$search_directory'."
    if ( not -d $search_directory );

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
    my ( $img, $opt, $end, $less );
    try {
        $img = Image->new( { path => $path } ) or die $!;
        $opt = Image::Optimizer->new( { image => $img } ) or die $!;
        $end = $opt->run() or die $!;
        $less = $img->_size - $end->_size;
    }
    catch {
        warn "Cannot create Image object or optimize: $_";
        next;
    };

    if ( not $less ) {
        print "No reduction on: '", $img->path, "'\n";
        $end->unlink or warn $!;
        next;
    }

    push @optimized_images, { img => $img, opt => $end, less => $less };
}

#
# Analizing the results
#

my ( $size_after, $size_before ) = ( 0, 0 );

foreach my $img (@optimized_images) {
    my $move_to = $output . '/' . $img->{img}->_basename;
    $move_to .= '.' . time() if ( -f $move_to );

    $size_after  += $img->{img}->_size();
    $size_before += $img->{opt}->_size();

    # moving to new location
    rename $img->{opt}->path, $move_to
        or warn $!;

    print "Optimized (-", format_bytes( $img->{less} ), "): '",
        $img->{opt}->path, "' -> '", $move_to, "'\n";

    $img->{opt}->unlink();
}

print "\n" x 2;
print "Size -- Before: ", format_bytes($size_after),  "\n";
print "Size --- After: ", format_bytes($size_before), "\n";
print "Size Reduction: ", format_bytes( $size_after - $size_before ), "\n";

__END__
