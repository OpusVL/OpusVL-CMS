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
    return $self->search({
         status => 'published',
         -or => [
             site => $site_id,
             global => 1,
         ],
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
