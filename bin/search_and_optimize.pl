#!/usr/bin/env perl

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 09/19/2010 11:55:26
#

use strict;
use warnings;

BEGIN { push @INC, q{./lib/}; }

use Try::Tiny;
use Data::Dumper;
use Image;
use Image::Optimizer;

# ----------------------------------------------------------------------------
#                             -- Subroutines --
# ----------------------------------------------------------------------------

sub search_recursive ( $$$ ) {
    my ( $path, $file_list, $search_pattern ) = @_;
    return if ( !-d $path );

    foreach my $f ( get_files_from_dir($path) ) {
        next if ( defined $search_pattern and $f !~ $search_pattern );
        &search_recursive( $path . '/' . $f, $file_list )
            if ( -d $path . '/' . $f );
        push @{$file_list}, $path . '/' . $f;
    }
}

sub get_files_from_dir ( $ ) {
    my ($path) = @_;
    return if ( not defined $path );
    my @dots;

    opendir my $DIR, $path or die $!;
    foreach ( readdir($DIR) ) {
        push @dots, $_
            if ( !/^\.+$/ );
    }
    closedir $DIR;

    return (@dots);
}

# ----------------------------------------------------------------------------
#                            -- GetOptions --
# ----------------------------------------------------------------------------

my $search_directory = $ARGV[0] || die "Inform the search directory.";

$search_directory = $ENV{PWD} . "/" . $search_directory
    if ( $search_directory !~ /^\/.*?/ );

# ----------------------------------------------------------------------------
#                               -- Main --
# ----------------------------------------------------------------------------

my @image_paths;

try {    # search for image paths
    search_recursive( $search_directory, \@image_paths,
        qr/.*?\.(jpeg|jpg|png|gif)$/ );
}
catch {
    die "Cannot find any image on $search_directory"
        if ( defined $_ or $#image_paths <= 0 );
};

my @optimized_images;

foreach my $path (@image_paths) {
    my $img = Image->new( { path => $path } )
        or warn $! and next;
    my $opt = Image::Optimizer->new( { image => $img } )
        or warn $! and next;
    my $optimized = $opt->run()
        or warn "Cannot create object or optimize -- $!" and next;

    # optimization has no good result
    if ( $optimized->_size >= $img->_size ) {
        print "\n(WARN) No reduction: ", $img->path, "\n";
        $optimized->unlink or warn $!;
        next;
    }

    push @optimized_images, { img => $img, opt => $optimized }
        and print "*";
}

# ----------------------------------------------------------------------------
#                       -- Analizing the results --
# ----------------------------------------------------------------------------

my ( $size_after, $size_before ) = ( 0, 0 );

foreach my $img (@optimized_images) {
    $size_after  += $img->{img}->_size();
    $size_before += $img->{opt}->_size();
    $img->{opt}->unlink() or warn $!;
}

print "\n" x 2;
print "Size     After: ", $size_after,  "\n";
print "Size    Before: ", $size_before, "\n";
print "Size Reduction: ", $size_after - $size_before, "\n";

__END__
