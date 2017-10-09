package OpusVL::FB11Website;

use strict;
use warnings;
use OpusVL::FB11Website::Builder;

our $VERSION = '0.014';

my $builder = OpusVL::FB11Website::Builder->new(
    appname => __PACKAGE__,
    version => $VERSION,
);

$builder->bootstrap;

1;

=head1 NAME

OpusVL::FB11Website - Vanilla CMS Frontend website

=head1 DESCRIPTION

=head1 METHODS

=head1 ATTRIBUTES


=cut
