package OpusVL::CMS::Schema::ResultSet::Template;
our $VERSION = '23';

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Template -

=head1 DESCRIPTION

Accessors for the Elements of the CMS

=head1 METHODS

published - returns all published (live) assets

=cut
###########################################################################################

use DBIx::Class::ResultSet;
use Moose;
extends 'DBIx::Class::ResultSet';
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});


=head2 published

Returns all published (i.e. live) assets

=cut

sub published
{
    my $self = shift;
    
    return $self->search({ status => 'published' });
}

##
1;
