use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Image::Optimizer',
    AUTHOR        => q{Otavio Fernandes <otaviof@gmail.com>},
    VERSION_FROM  => 'lib/Image/Optimizer.pm',
    ABSTRACT_FROM => 'lib/Image/Optimizer.pm',
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
    PL_FILES  => {},
    PREREQ_PM => {
        'Test::More'    => 0,
        'Moose'         => 1.09,
        'File::Type'    => 0.22,
        'App::PNGCrush' => 0.001,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Image-Optimizer-*' },
);
