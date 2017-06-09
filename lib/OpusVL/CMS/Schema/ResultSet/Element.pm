package OpusVL::CMS::Schema::ResultSet::Element;
our $VERSION = '61';

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
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
with 'OpusVL::CMS::Roles::ResultSetFilter' => { field => 'slug' };
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});

sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_

sub available {
    my ($self, $site_id) = @_;
    my $schema = $self->result_source->schema;
    my $me = $self->current_source_alias;
    return $self->search({
        "$me.status" => 'published',
        site => { -in => $schema->resultset('Site')->expand_site_ids($site_id) },
    }, {
        join => ['site'],
        order_by => ['site.profile_site'],
    });
}

=head2 published

Returns all published (i.e. live) pages

=cut

sub published
{
    my $self = shift;
    my $me = $self->current_source_alias;
    
    return $self->search({ "$me.status" => 'published' });
}

##
1;
