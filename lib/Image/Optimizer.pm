package Image::Optimizer;

use warnings;
use strict;

our $VERSION = '0.01';

use App::PNGCrush;
use File::Basename;
use File::Temp qw(tempdir);
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
    my $crush = App::PNGCrush->new() or warn $! and return;
    $crush->set_options(
        ( "-d", $self->dir_out, "-rem", "alla", "-brute", "1" ),
        remove => [qw(gAMA cHRM sRGB iCCP)], );
    $crush->run( $self->image->path ) or warn $! and return;
    return 1;
}

sub _optimize_jpg {
    my ($self) = @_;
    my $filename = fileparse( $self->{image}->{path} ) or return;
    my @cmd = (
        "jpegtran", "-copy", "none", "-optimize", "-perfect", "-outfile",
        $self->{dir_out} . '/' . $filename,
        $self->{image}->{path},
    );
    return ( system(@cmd) == 0 ) ? 1 : 0;
}

sub run {
    my ($self) = @_;

    $self->_optimize_png()
        or return
        if ( $self->image->type =~ /image\/png/ );

    $self->_optimize_jpg()
        or return
        if ( $self->image->type =~ /image\/jpeg/ );

    return $self->dir_out;
}

1;

__END__
