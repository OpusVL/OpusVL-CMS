package OpusVL::CMS::Schema::RolesFor::ResultSet::AttributeValue;

use Moose::Role;

=head1 NAME

OpusVL::CMS::Schema::RolesFor::ResultSet::AttributeValue - Make an AttributeValue resultset.

=head1 DESCRIPTION

This Role defines common functionality for AttributeValues, i.e. the options for an attribute of type select, for pages, assets, and attachments.

=head1 SYNOPSIS

    package My::Schema::ResultSet::ArbitraryAttributeValue;

    use Moose;
    use MooseX::NonMoose;
    extends 'DBIx::Class::ResultSet';
    with 'OpusVL::CMS::Schema::RolesFor::ResultSet::AttributeValue';

=head1 METHODS

=head2 for_site

Combines value for this site's version of the attribute with the ones for this
site's profile. This is mostly for display purposes, so users can see which
values are already available in a select box when creating new ones.

=cut

sub for_site {
    my $self = shift;
    my $site = shift;

    my @s = $site->id;
    push @s, $site->profile->id if $site->profile;

    # Put profile options at the top of the list
    return $self->search(
        { site_id => \@s },
        { 
            order_by => { 
                -desc => \'site.profile_site IS NULL'
            },
            join => 'site'
        }
    );
}

1;

=head1 SEE ALSO

=over

=item L<OpusVL::CMS::Schema::RolesFor::Result::AttributeValue>

=back
