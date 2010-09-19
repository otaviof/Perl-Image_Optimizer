use strict;
use warnings;

use ExtUtils::MakeMaker;
use Try::Tiny;

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
        'App::PNGCrush'    => 0.001,
        'File::Basename'   => 0,
        'File::Copy'       => 0,
        'File::Path'       => 0,
        'File::Temp'       => 0,
        'File::Type'       => 0.22,
        'File::stat'       => 0,
        'Git::Wrapper'     => 0.006,
        'Graphics::Magick' => 0,
        'Moose'            => 1.09,
        'Moose'            => 1.09,
        'Test::More'       => 0,
        'Try::Tiny'        => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Image-Optimizer-*' },
);

try {    # write 'Changes' file from Git
    eval {q{use Git::Wrapper;}} or die $@;
    my $git = new Git::Wrapper( $ENV{PWD} ) or die $!;
    unlink 'Changes' if ( -f 'Changes' );
    open( my $CHG, '>', 'Changes' ) or die $!;
    foreach my $log ( $git->log ) {
        print $CHG "commit: ", $log->id, "\n";
        print $CHG "Author: ", $log->attr->{date},   "\n";
        print $CHG "  Date: ", $log->attr->{author}, "\n\n";
        print $CHG "\t", $log->message, "\n\n";
    }
    close($CHG);
}
catch {
    warn $_;
};

__END__
