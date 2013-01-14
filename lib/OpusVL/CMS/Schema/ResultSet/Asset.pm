package OpusVL::CMS::Schema::ResultSet::Asset;

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Assets -

=head1 DESCRIPTION

Accessors for the Elements of the CMS

=head1 METHODS

published - returns all published (live) assets

=head1 BUGS

=head1 AUTHOR

OpusVL - JJ

=head1 COPYRIGHT & LICENSE

Copyright 2012 OpusVL.

This sofware is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut
###########################################################################################

use feature 'switch';
use DBIx::Class::ResultSet;
use Moose;
extends 'DBIx::Class::ResultSet';

=head2 available

Returns all published, or global assets

=cut

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

Returns all published (i.e. live) assets

=cut

sub published
{
    my $self = shift;
    
    return $self->search({ status => 'published' });
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

    given (delete $options->{sort}) {
        when ('updated') { $options->{order_by} = {'-desc' => 'updated'} }
        when ('newest')  { $options->{order_by} = {'-desc' => 'created'} }
        when ('oldest')  { $options->{order_by} = {'-asc'  => 'created'} }
        default          { $options->{order_by} = {'-asc' => 'priority'} }
    }

    return $self->search($query, $options);
}

1;
