package Image::PNG;

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 02:41:43
#

use strict;
use warnings;

use Moose;

has 'image' => (
    is       => 'rw',
    isa      => 'Image',
    required => 1
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__
