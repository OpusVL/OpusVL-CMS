package OpusVL::CMS::Schema::ResultSet::Element;
our $VERSION = '2';

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Element -

=head1 DESCRIPTION

Accessors for the Elements of the CMS

=head1 METHODS

published - returns all published (live) elements

=cut
###########################################################################################

use DBIx::Class::ResultSet;
use Moose;
extends 'DBIx::Class::ResultSet';

sub available {
    my ($self, $site_id) = @_;
    my $schema = $self->result_source->schema;
    return $self->search({
        status => 'published',
        site => { -in => $schema->resultset('Site')->expand_site_ids($site_id) },
    });
}

=head2 published

Returns all published (i.e. live) pages

=cut

sub published
{
    my $self = shift;
    
    return $self->search({ status => 'published' });
}

##
1;
