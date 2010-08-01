package Image::Optimizer;

use warnings;
use strict;

our $VERSION = '0.01';

use Moose;
use App::PNGCrush;

has 'image' => (
    is       => 'rw',
    isa      => 'Image',
    required => 1
);

sub run {
    my ($self) = @_;

    if ( $self->image->type == "image/png" ) {
        my $crush = App::PNGCrush->new();
        $crush->set_options( qw( -d OUT_DIR -brute 1 ),
            remove => [qw( gAMA cHRM sRGB iCCP )], );

        my $out_ref = $crush->run( $self->image->path )
            or die "Error: " . $crush->error;

        print "Size reduction: $out_ref->{size}%\n"
            . "IDAT reduction: $out->{idat}%\n";
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
