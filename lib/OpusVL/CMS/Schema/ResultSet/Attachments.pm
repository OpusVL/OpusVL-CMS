package OpusVL::CMS::Schema::ResultSet::Attachments;

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Attachments -

=head1 DESCRIPTION

Accessors for the Attachments of the SimpleCMS

=head1 METHODS

published - returns all publiched (live) attachments.

=head1 BUGS

=head1 AUTHOR

OpusVL - JJ

=head1 COPYRIGHT & LICENSE

Copyright 2012 OpusVL.

This sofware is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut

###########################################################################################

use 5.010;
use DBIx::Class::ResultSet;
use Moose;
extends 'DBIx::Class::ResultSet';

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

 my @attachments = $resultset->attribute_search({
     type => 'Screenshot',
 }, {
     order_by => 'newest',
     results  => 10,
     page     => 1,
 });

 my $attachment = $resultset->attribute_search({homepage_slot => 1})->first;

=cut

sub attribute_search {
    my ($self, $query, $options) = @_;

    $query   //= {};
    $options //= {};
    
    if (scalar keys %$query) {
        my $attribute_query;
        my @page_ids;
        my $join_count = 0;
        foreach my $field ($self->result_source->schema->resultset('AttachmentAttributeDetails')->active->all) {
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
    
    given (delete $options->{sort}) {
        when ('updated') { $options->{order_by} = {'-desc' => 'updated'} }
        when ('newest')  { $options->{order_by} = {'-desc' => 'created'} }
        when ('oldest')  { $options->{order_by} = {'-asc'  => 'created'} }
        default          { $options->{order_by} = {'-desc' => 'priority'} }
    }
    
    return $self->search($query, $options);
}

##
1;
