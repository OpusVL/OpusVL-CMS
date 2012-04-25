#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'OpusVL::CMS' ) || print "Bail out!\n";
}

diag( "Testing OpusVL::CMS $OpusVL::CMS::VERSION, Perl $], $^X" );
