package Image::Optimizer;

use warnings;
use strict;

our $VERSION = '0.01';

use App::PNGCrush;
use File::Basename;
use File::Temp qw(tempdir);
use Image;
use Moose;

has 'image' => (
    is       => 'rw',
    isa      => 'Image',
    required => 1
);

has 'dir_out' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub { return tempdir( DIR => "/tmp" ); },
);

sub _optimize_png {
    my ($self) = @_;
    my $crush = App::PNGCrush->new() or warn $! and return;
    $crush->set_options(
        ( "-d", $self->dir_out, "-rem", "alla", "-brute", "1" ),
        remove => [qw(gAMA cHRM sRGB iCCP)], );
    $crush->run( $self->image->path ) or warn $! and return;
    return Image->new(
        { path => $self->dir_out . '/' . $self->image->_basename } );
}

sub _optimize_jpg {
    my ($self) = @_;
    my @cmd = (
        "jpegtran", "-copy", "none", "-optimize", "-perfect", "-outfile",
        $self->dir_out . '/' . $self->image->_basename,
        $self->image->path,
    );
    system(@cmd) == 0 or return;
    return Image->new(
        { path => $self->dir_out . '/' . $self->image->_basename } );
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
