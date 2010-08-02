use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Image::Optimizer',
    AUTHOR        => q{Otavio Fernandes <otaviof@gmail.com>},
    VERSION_FROM  => 'lib/Image/Optimizer.pm',
    ABSTRACT_FROM => '',
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
    PL_FILES  => {},
    PREREQ_PM => {
        'App::PNGCrush' => 0.001,
        'File::Type'    => 0.22,
        'File::stat'    => 0,
        'Moose'         => 1.09,
        'Test::More'    => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Image-Optimizer-*' },
);
