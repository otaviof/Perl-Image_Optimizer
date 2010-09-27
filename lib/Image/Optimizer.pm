package Image::Optimizer;

use warnings;
use strict;

our $VERSION = '0.01';

use Carp;
use App::PNGCrush;
use File::Basename;
use File::Temp qw(tempdir);
use Graphics::Magick;
use Proc::Reliable;
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

sub _mk_temp_dir {
    return tempdir( DIR => "/tmp/", CLEANUP => 1 ) . '/';
}

sub _optimize_png {
    my ($self) = @_;
    my $crush = App::PNGCrush->new() or return;
    my $final_image = $self->dir_out . $self->image->_basename;
    $crush->set_options(
        ( "-d", $self->dir_out, "-rem", "alla", "-brute", "1" ),
        remove => [qw(gAMA cHRM sRGB iCCP)], );
    $crush->run( $self->image->path ) or carp $!;
    carp "Error on PNG optimization: " . $crush->error
        if ( $crush->error or !-f $final_image );
    return ( Image->new( { path => $final_image } ) );
}

sub _optimize_jpg {
    my ($self) = @_;
    my $final_image = $self->dir_out . $self->image->_basename;
    my $proc = Proc::Reliable->new() or return;
    my $output = $proc->run(
        [   "jpegtran",   "-copy",
            "none",       "-optimize",
            "-perfect",   "-outfile",
            $final_image, $self->image->path,
        ]
    );
    carp "Jpegtran Error: $output (" . $self->image->path . ")"
        if ( $proc->status() or !-f $final_image );
    return ( Image->new( { path => $final_image } ) );
}

sub _optimize_gif {
    my ($self) = @_;
    my $magick = Graphics::Magick->new() or return;
    my $output_png = $self->dir_out . $self->image->_basename . '.png';
    $magick->Read( $self->image->path );
    $magick->Write($output_png);
    carp "Error on GIF optimization" if ( !-f $output_png );
    return ( Image->new( { path => $output_png } ) );
}

sub run {
    my ($self) = @_;

    carp "No image object." if ( !$self->{image} );

    if ( $self->image->type =~ /image.*gif/ ) {
        $self->{last_image} = $self->{image};
        $self->{image}      = $self->_optimize_gif()
            or carp "Could not optimize Gif.";
        $self->{dir_out} = $self->_mk_temp_dir();
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
