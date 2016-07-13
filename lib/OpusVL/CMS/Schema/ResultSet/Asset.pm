package OpusVL::CMS::Schema::ResultSet::Asset;
our $VERSION = '2';

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Asset -

=head1 DESCRIPTION

Accessors for the Elements of the CMS

=head1 METHODS

published - returns all published (live) assets

=cut
###########################################################################################

use DBIx::Class::ResultSet;
use Moose;
extends 'DBIx::Class::ResultSet';
use experimental 'switch';

=head2 available

Returns all published, or global assets

=cut

sub available {
    my ($self, $site_id) = @_;
    my $schema = $self->result_source->schema;
    return $self->search({
        status => 'published',
        site => { -in => $schema->resultset('Site')->expand_site_ids($site_id) },
    });
}

=head2 published

Returns all published (i.e. live) assets

=cut

sub published
{
    my $self = shift;
    
    return $self->search({ status => 'published' });
}

sub by_id_desc
{
    my $self = shift;
    return $self->search(undef, { order_by => { -desc => 'id' } });
}

##

sub attribute_search {
    my ($self, $query, $options) = @_;

    $query   //= {};
    $options //= {};

    if (scalar keys %$query) {
        my $attribute_query;
        my @page_ids;
        my $join_count = 0;
        foreach my $field ($self->result_source->schema->resultset('AssetAttributeDetail')->active->all) {
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
    } else { return {}; }

    my $me = $self->current_source_alias;

    given (delete $options->{sort}) {
        when ('updated') { $options->{order_by} = {'-desc' => "$me.updated"} }
        when ('newest')  { $options->{order_by} = {'-desc' => "$me.created"} }
        when ('oldest')  { $options->{order_by} = {'-asc'  => "$me.created"} }
        default          { $options->{order_by} = {'-asc' => "$me.priority"} }
    }

    return $self->search($query, $options);
}

1;
