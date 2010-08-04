package Image::Optimizer;

use warnings;
use strict;

our $VERSION = '0.01';

use App::PNGCrush;
use File::Basename;
use File::Temp qw(tempdir);
use Graphics::Magick;
use Image;
use Moose;

has 'image' => (
    is       => 'rw',
    isa      => 'Image',
    required => 1,
);

has 'dir_out' => (
    is      => 'ro',
    isa     => 'Str',
    default => _mk_temp_dir(),
);

sub _mk_temp_dir { return tempdir( DIR => "/tmp" ) . '/'; }

sub _optimize_png {
    my ($self) = @_;
    my $crush = App::PNGCrush->new() or return;
    $crush->set_options(
        ( "-d", $self->dir_out, "-rem", "alla", "-brute", "1" ),
        remove => [qw(gAMA cHRM sRGB iCCP)], );
    $crush->run( $self->image->path ) or return;
    return (
        Image->new( { path => $self->dir_out . $self->image->_basename } ) );
}

sub _optimize_jpg {
    my ($self) = @_;
    my @cmd = (
        "jpegtran", "-copy", "none", "-optimize", "-perfect", "-outfile",
        $self->dir_out . $self->image->_basename,
        $self->image->path,
    );
    system(@cmd) == 0 or return;
    return (
        Image->new( { path => $self->dir_out . $self->image->_basename } ) );
}

sub _optimize_gif {
    my ($self) = @_;
    my $magick     = Graphics::Magick->new();
    my $output_png = $self->dir_out . $self->image->_basename . '.png';
    $magick->Read( $self->image->path );
    $magick->Write($output_png);
    return ( Image->new( { path => $output_png } ) );
}

sub run {
    my ($self) = @_;

    if ( $self->image->type =~ /image.*gif/ ) {
        $self->{last_image} = $self->{image};
        $self->{image}      = $self->_optimize_gif();
        $self->{dir_out}    = $self->_mk_temp_dir();
        $self->run();
    }

    return $self->_optimize_png()
        if ( $self->image->type =~ /image.*png/ );

    return $self->_optimize_jpg()
        if ( $self->image->type =~ /image.*jpeg/ );

    return 0;
}

1;

__END__
