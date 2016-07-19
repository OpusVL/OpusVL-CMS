package OpusVL::CMS::Schema::ResultSet::Attachment;
our $VERSION = '13';

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
sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});
use experimental 'switch';

=head2 published

Returns all published (i.e. live) attachments

=cut

sub published
{
	my $self = shift;
    
    return $self->search({ status => 'published' });
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

    $query   //= {};
    $options //= {};
    
    if (scalar keys %$query) {
        my $attribute_query;
        my @page_ids;
        my $join_count = 0;
        my @resultset = $site->all_attachment_attribute_details->active->search({ code => { -in => [keys %$query] } })->filter_by_code;
        foreach my $field (@resultset) {
            if (my $value = delete $query->{$field->code}) {
                $join_count++;
                my $alias = 'attribute_values';
                push @{$options->{join}}, $alias;
                
                if ($join_count > 1) {
                    $alias .= "_$join_count";
                }
                
                $query->{"$alias.field_id"} = $field->id;
                $query->{"$alias.value"}    = $value;
            }
        }
    }
    
    my $me = $self->current_source_alias;

    given (delete $options->{sort}) {
        when ('updated') { $options->{order_by} = {'-desc' => "$me.updated"} }
        when ('newest')  { $options->{order_by} = {'-desc' => "$me.created"} }
        when ('oldest')  { $options->{order_by} = {'-asc'  => "$me.created"} }
        default          { $options->{order_by} = {'-asc' => "$me.priority"} }
    }
    
    if (delete $options->{rs_only}) {
        return $self->search_rs($query, $options);
    }
    else {
        return $self->search($query, $options);
    }
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
