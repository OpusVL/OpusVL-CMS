package OpusVL::CMS::Schema::ResultSet::Template;
our $VERSION = '2';

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


=head2 published

Returns all published (i.e. live) assets

=cut

sub published
{
    my $self = shift;
    
    return $self->search({ status => 'published' });
}

sub for_site
{
    my $self = shift;
    my $site = shift;
    return $self->search({ site => { -in => [ $site->id, $site->profile_site ] }});
}

##
1;
