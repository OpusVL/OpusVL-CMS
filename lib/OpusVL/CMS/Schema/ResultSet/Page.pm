package OpusVL::CMS::Schema::ResultSet::Page;
our $VERSION = '49';

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
with 'OpusVL::CMS::Roles::AttributeSearch';

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

    if(my $preload = delete $options->{load_attributes})
    {
		$rs = $rs->prefetch_attributes($preload);
    }

    return $rs->_attribute_search($site, $query, $options);
}

sub prefetch_attributes
{
    my ($self, $names) = @_;

    my @params;
    my @joins;
    my $x = 1;
    my %aliases;
    my @columns;
    my @column_names;
    for my $name (@$names)
    {
        my $alias = $x == 1 ? "_our_attributes" : "_our_attributes_$x";
        push @params, $name;
        # NOTE: guard against SQLi
        my $column_name = "attribute_$name" =~ s/\W/_/gr;
        push @column_names, $column_name;
        push @columns, \"$alias.value as $column_name";
        push @joins, '_our_attributes';
        $aliases{$name} = $alias;
        $x++;
    }
    my $rs = $self->search(undef, {
        bind => \@params,
        # Doing this manually since prefetch tries to be too clever
        # by collapsing stuff and then providing no way to get to the dat
        # as it doesn't consider multiple joins of the same relationship
        # to be sane.
        # Also our data should be flat (there should only be 1 or 0 row we're joining to
        # so we don't need to do that collapse business.
        join => \@joins,
        '+select' => \@columns,
    });
    return $rs->as_subselect_rs->search(undef, { '+columns' => \@column_names })
}

##
1;
