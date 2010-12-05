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

# ----------------------------------------------------------------------------
# -- Atributes:
# ----------------------------------------------------------------------------

has image     => ( is => 'rw', isa => 'Image', required => 1 );
has dir_out   => ( is => 'rw', isa => 'Str',   default  => _mk_temp_dir() );
has image_out => ( is => 'rw', isa => 'Image', required => 0 );
has swap      => ( is => 'rw', isa => 'Image', required => 0 );
has optimized => (
    is        => 'rw',
    isa       => 'Int',
    predicate => 'is_optimized',
);

# ----------------------------------------------------------------------------
# -- Instance Methods:
# ----------------------------------------------------------------------------

sub _mk_temp_dir {
    return tempdir( DIR => "/tmp/", CLEANUP => 1 ) . '/';
}

sub _mk_image {
    my ( $self, $path ) = @_;

    # creating a new Image object
    $self->image_out( Image->new( { path => $path } ) )
        or carp "Cannot create Image object: $path";

    my $original_size = ( ( $self->swap )
        ? $self->swap->_size
        : $self->image->_size
    );

    $self->optimized( $original_size <=> $self->image_out->_size );

    return 1;
}

sub _optimize_png {
    my ($self) = @_;
    my $crush = App::PNGCrush->new() or return;
    my $final_image = sprintf "%s%s", $self->dir_out, $self->image->_basename;

    $crush->set_options(
        ( "-d", $self->dir_out, "-rem", "alla", "-brute", "1" ),
        remove => [qw(gAMA cHRM sRGB iCCP)], );
    $crush->run( $self->image->path ) or carp $!;

    carp "Error on PNG optimization: " . $crush->error
        if $crush->error
            or not -f $final_image;

    return $self->_mk_image($final_image);
}

sub _optimize_jpg {
    my ($self) = @_;
    my $proc = Proc::Reliable->new() or return;
    my $final_image = $self->dir_out . $self->image->_basename;

    my $output = $proc->run(
        [   "jpegtran",   "-copy",
            "none",       "-optimize",
            "-perfect",   "-outfile",
            $final_image, $self->image->path,
        ]
    );

    carp "Jpegtran Error: $output (" . $self->image->path . ")"
        if ( $proc->status() or not -f $final_image );

    return $self->_mk_image($final_image);
}

sub _optimize_gif {
    my ($self) = @_;
    my $magick = Graphics::Magick->new() or return;
    my $output_png = sprintf "%s%s.png", $self->dir_out,
        $self->image->_basename;

    $magick->Read( $self->image->path );
    $magick->Write($output_png);

    carp "Error on GIF optimization"
        if ( not -f $output_png );

    return $self->_mk_image($output_png);
}

# ----------------------------------------------------------------------------
# -- Class Method:
# ----------------------------------------------------------------------------

sub run {
    my ($self) = @_;

    carp "No image object."
        if ( not $self->image );

    if ( $self->image->type =~ /image.*gif/ ) {
        $self->swap( $self->image );
        $self->_optimize_gif()
            or carp "Cannot optimize: " . $self->image->type;
        $self->image( $self->image_out );
        $self->dir_out( $self->_mk_temp_dir() );
        $self->run();
    }

    $self->_optimize_png() || carp "Cannot optimize: ", $self->image->type
        if ( $self->image->type =~ /image.*png/ );

    $self->_optimize_jpg() || carp "Cannot optimize: ", $self->image->type
        if ( $self->image->type =~ /image.*jpeg/ );

    return $self->image_out;
}

1;

__END__
