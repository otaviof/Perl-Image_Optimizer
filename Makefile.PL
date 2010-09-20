use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Image::Optimizer',
    ABSTRACT_FROM => '',
    AUTHOR        => 'Otavio Fernandes <otaviof@gmail.com>',
    EXE_FILES     => [ 'bin/search_and_optimize.pl', ],
    VERSION_FROM  => 'lib/Image/Optimizer.pm',
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
    PL_FILES  => {},
    PREREQ_PM => {
        'App::PNGCrush'        => 0.001,
        'File::Basename'       => 0,
        'File::Copy'           => 0,
        'File::Find'           => 0,
        'File::Path'           => 0,
        'File::Temp'           => 0,
        'File::Type'           => 0.22,
        'File::stat'           => 0,
        'Git::Wrapper'         => 0.006,
        'Graphics::Magick'     => 0,
        'Moose'                => 1.09,
        'Moose'                => 1.09,
        'Number::Bytes::Human' => 0,
        'Test::More'           => 0,
        'Try::Tiny'            => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Image-Optimizer-*' },
);

# --
# Git Changes
# --

my @changes = `git log` or exit;
unlink('Changes') if ( -f 'Changes' );
open( my $fh, '>', "Changes" )
    or warn $! and exit;
print $fh @changes;
close $fh;

__END__
