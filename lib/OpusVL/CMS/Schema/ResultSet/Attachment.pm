package OpusVL::CMS::Schema::ResultSet::Attachment;
our $VERSION = '31';

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Attachment -

=head1 DESCRIPTION

Accessors for the Attachment of the SimpleCMS

=head1 METHODS

published - returns all publiched (live) attachments.

=cut

###########################################################################################

use 5.010;
use DBIx::Class::ResultSet;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
with 'OpusVL::CMS::Roles::ResultSetFilter' => { field => 'slug' };
with 'OpusVL::CMS::Roles::AttributeSearch';
sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});
use experimental 'switch';

=head2 published

Returns all published (i.e. live) attachments

=cut

sub published
{
	my $self = shift;
    my $me = $self->current_source_alias;
    return $self->search({ "$me.status" => 'published' });
}

=head2 attribute_search

Searches attachments by attribute, e.g.

 my @attachments = $resultset->attribute_search($site, {
     type => 'Screenshot',
 }, {
     order_by => 'newest',
     results  => 10,
     page     => 1,
 });

 my $attachment = $resultset->attribute_search($site, {homepage_slot => 1})->first;

=cut

sub attribute_search {
    my $self = shift;
    my $site = shift;
    my ($query, $options) = @_;

    return $self->_attribute_search($site, $query, $options);
}

sub available {
    my ($self, $site_id) = @_;
    my $me = $self->current_source_alias;
    my $schema = $self->result_source->schema;
    return $self->search({
        "$me.status" => 'published',
        'page.site' => { -in => $schema->resultset('Site')->expand_site_ids($site_id) },
    }, {
        join => [{ page => 'site'} ],
        order_by => ['site.profile_site'],
    });
}

##
1;
