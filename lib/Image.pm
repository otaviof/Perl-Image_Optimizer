package Image;

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 08/01/2010 00:45:48
#

use strict;
use warnings;

use Moose;
use File::Type;
use File::Path;
use File::Basename qw(dirname basename);

has 'path' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    trigger  => sub {
        my ( $self, $value ) = @_;
        die "No such image ($value)."
            if !-f $value;
    }
);

has 'type' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my ($self) = @_;
        my $f = File::Type->new()
            or return;
        my $t = $f->checktype_filename( $self->path );
        return $t;
    },
);

has '_basename' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my ($self) = @_;
        return basename( $self->path );
    },
);

sub destroy {
    my ($self) = @_;
    $self->unlink( $self->path )
        or return;
    return rmtree( dirname( $self->path ) );
}

sub unlink {
    my ($self) = @_;
    return unlink( $self->path );
}

1;

__END__
