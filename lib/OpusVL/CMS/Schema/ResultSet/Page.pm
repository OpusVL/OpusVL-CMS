package OpusVL::CMS::Schema::ResultSet::Page;
our $VERSION = '11';

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Page -

=head1 DESCRIPTION

Accessors for the Pages of the SimpleCMS

=head1 METHODS

toplevel - returns the top level record to the pages tree.

=cut
###########################################################################################

use 5.010;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
with 'OpusVL::CMS::Roles::ResultSetFilter' => { field => 'url' };

sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});

use experimental 'switch';


=head2 toplevel

Returns the top level resultset of pages.

=cut

sub toplevel
{
	my $self = shift;
	return $self->search({ parent_id => undef });
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

=head2 attribute_search

Searches pages by attribute, e.g.

 my @pages = $resultset->attribute_search($site, {
     section => 'Applications',
 }, {
     order_by => 'newest',
     results  => 10,
     page     => 1,
 });

 my $page = $resultset->attribute_search($site, {homepage_slot => 1})->first;

=cut

sub attribute_search {
    my $self    = shift;
    my $site = shift;
    my ($query, $options) = @_;

    $query   //= {};
    $options //= {};
    
    # we want published pages only!
    my $me = $self->current_source_alias;
    my $rs = $self->search_rs({ "$me.status" => { '!=', 'deleted' } });

    if (scalar keys %$query) {
        my $attribute_query;
        my @page_ids;
        my $join_count = 0;
        my @resultset = $site->all_page_attribute_details->active->search({ code => { -in => [keys %$query] } })->filter_by_code;
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

    given (delete $options->{sort}) {
        when ('alphabetical') { $options->{order_by} = {'-asc' => "$me.h1"} }
        when ('updated') { $options->{order_by} = {'-desc' => "$me.updated"} }
        when ('newest')  { $options->{order_by} = {'-desc' => "$me.created"} }
        when ('oldest')  { $options->{order_by} = {'-asc'  => "$me.created"} }
        default          { $options->{order_by} = {'-asc' => "$me.priority"} } # -desc ?
    }
    
    if (delete $options->{rs_only}) {
        return $rs->search_rs($query, $options);
    }
    else {
        return $rs->search($query, $options);
    }
}

##
1;
