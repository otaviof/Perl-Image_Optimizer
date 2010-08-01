package Image::Optimizer;

use warnings;
use strict;

our $VERSION = '0.01';

use Moose;

has 'image' => (
    is       => 'rw',
    isa      => 'Image',
    required => 1
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
