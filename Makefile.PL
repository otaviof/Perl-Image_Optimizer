use strict;
use warnings;

use ExtUtils::MakeMaker;
use Git::Wrapper;

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
        'App::PNGCrush'  => 0.001,
        'File::Basename' => 0,
        'File::Copy'     => 0,
        'File::Path'     => 0,
        'File::Temp'     => 0,
        'File::Type'     => 0.22,
        'File::stat'     => 0,
        'Git::Wrapper'   => 0.006,
        'Moose'          => 1.09,
        'Moose'          => 1.09,
        'Test::More'     => 0,
        'Try::Tiny'      => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Image-Optimizer-*' },
);

# --
# Writing 'Changes' file from Git
# --

use Git::Wrapper;

my $git = new Git::Wrapper( $ENV{PWD} );

unlink 'Changes' if ( -f 'Changes' );

open( my $CHG, '>', 'Changes' ) or die $!;
foreach my $log ( $git->log ) {
    print $CHG "commit: ", $log->id, "\n";
    print $CHG "Author: ", $log->attr->{date},   "\n";
    print $CHG "  Date: ", $log->attr->{author}, "\n\n";
    print $CHG "\t", $log->message, "\n\n";
}
close($CHG);

__END__
