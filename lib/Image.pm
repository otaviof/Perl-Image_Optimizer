package Image;

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 00:45:48
#

use strict;
use warnings;

use File::Basename qw(dirname basename);
use File::Path;
use File::Type;
use File::stat;
use Moose;

has 'path' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    trigger  => sub {
        my ( $self, $value ) = @_;
        die "No such image ($value)." if !-f $value;
        $self->type;
        $self->_basename;
        $self->_dirname;
        $self->_size;
    }
);

has 'type' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    lazy     => 1,
    default  => sub {
        my $f = File::Type->new() or return;
        return $f->checktype_filename( $_[0]->path );
    },
);

has '_basename' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    lazy     => 1,
    default  => sub { return basename( $_[0]->path ); },
);

has '_dirname' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    lazy     => 1,
    default  => sub { return dirname( $_[0]->path ); },
);

has '_size' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
    lazy     => 1,
    default  => sub { return ( stat( $_[0]->path ) )->size; }
);

sub destroy {
    my ($self) = @_;
    $self->unlink( $self->path )
        or return;
    return rmtree( dirname( $self->path ) );
}

sub unlink {
    return unlink( $_[0]->path );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__
