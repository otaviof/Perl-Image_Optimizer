#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Image::Optimizer' ) || print "Bail out!
";
}

diag( "Testing Image::Optimizer $Image::Optimizer::VERSION, Perl $], $^X" );
