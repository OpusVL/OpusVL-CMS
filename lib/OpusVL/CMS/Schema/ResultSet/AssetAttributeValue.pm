package OpusVL::CMS::Schema::ResultSet::AssetAttributeValue;

our $VERSION = '42';

use 5.010;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

sub for_site {
    my $self = shift;
    my $site = shift;

    my @s = $site->id;
    push @s, $site->profile->id if $site->profile;

    return $self->search({ site_id => \@s });
}

1;

=head1 NAME

OpusVL::CMS::Schema::ResultSet::AssetAttributeValue - Resultset for asset attribute selects

=head1 DESCRIPTION

Resultset methods for values for asset attributes of type select.

=head1 METHODS

=head2 for_site

Combines value for this site's version of the attribute with the ones for this
site's profile. This is mostly for display purposes, so users can see which
values are already available in a select box when creating new ones.
