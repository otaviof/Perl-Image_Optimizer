package Image::Optimizer;

use warnings;
use strict;

our $VERSION = '0.01';

use App::PNGCrush;
use Data::Dumper;    # Debug
use File::Basename;
use File::Temp qw/ tempdir /;
use Moose;

has 'image' => (
    is       => 'rw',
    isa      => 'Image',
    required => 1
);

has 'dir_out' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub { return tempdir(); },
);

sub _optimize_png {
    my ($self) = @_;
    my $crush = App::PNGCrush->new()
        or warn $! and return;
    $crush->set_options(
        ( "-d", $self->dir_out, "-brute", "1" ),
        remove => [qw(gAMA cHRM sRGB iCCP)],
    );
    $crush->run( $self->image->path )
        or warn $! and return;
    return 1;
}

sub _optimize_jpg {
    my ($self)   = @_;
    my $filename = fileparse( $self->image->path );
    my @cmd      = (
        "jpegtran",
        "-copy",
        "none",
        "-optimize",
        "-progressive",
        "-outfile",
        $self->dir_out . '/' . $filename,
        $ENV{PWD} . '/' . $self->image->path
    );
    return ( system(@cmd) == 0 ) ? 1 : 0;
}

sub run {
    my ($self) = @_;

    _optimize_png()
        or return
        if ( $self->image->type =~ /image.*png/ );

    return $self->dir_out;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
