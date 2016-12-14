package OpusVL::CMS::Roles::AttributeSearch;

use Moose::Role;
use Switch::Plain;
use Data::Dump;

sub _attribute_search {
    my ($self, $site, $query, $options) = @_;

    $query   //= {};
    $options //= {};

    my $me = $self->current_source_alias;
    if(my $preload = delete $options->{load_attributes})
    {
		$self = $self->prefetch_attributes($preload);
    }


    # don't fuck it up if it's been specified.
    unless($options->{order_by})
    {
        my $sort = delete $options->{sort} || 'priority';
        sswitch ($sort) {
            # FIXME: Perhaps the individual resultsets should have these as methods?
            # We can 'requires' them.
            case 'alphabetical' : { $options->{order_by} = {'-asc' => "$me.h1"} }
            case 'updated'      : { $options->{order_by} = {'-desc' => "$me.updated"} }
            case 'newest'       : { $options->{order_by} = {'-desc' => "$me.created"} }
            case 'oldest'       : { $options->{order_by} = {'-asc'  => "$me.created"} }
            default             : { $options->{order_by} = {'-asc' => "$me.priority"} }
        }
    }

    if (!%$query) {
        if (delete $options->{rs_only}) {
            return $self->search_rs(undef, $options);
        }
        if(delete $options->{as_subselect})
        {
            return $self->search(undef, $options)->as_subselect_rs->search_rs;
        }
        return $self->search(undef, $options);
    }

    # lets make this simpler.
    # forget anything with a . as they presumably knew what they were doing.
    # forget anything starting - because those are special keys like -and, -or
    # forget anything that is a real column
    # everything else is an attribute to search on
    my %columns = map { $_ => 1 } $self->result_source->columns;
    my @params = grep { !$columns{$_} } grep { !/\./ } grep { !/^-/ } keys %$query;
    my $alias = 'our_attributes';
    my %safe_options = map { $_ => $options->{$_} } grep { /join|prefetch/ } keys %$options;
    my $join_count = 0;

    foreach my $field (@params) {
        if (exists $query->{$field}) {
            my $value = delete $query->{$field};
            $join_count++;

            push @{$safe_options{join}}, $alias;

            if ($join_count > 1) {
                $_ .= "_$join_count" for $alias;
            }

            $query->{"$alias.site_id"} = $site->profile_site || $site->id;
            $query->{"$alias.code"} = $field;
            push @{$query->{'-and'}}, (
                {"$alias.value" => $value},
            );
            if(defined $value)
            {
                # note that this still won't really allow for { -in => [undef, 0 ] }
                # assuming that's a valid construct.
                push @{$query->{'-and'}}, (
                    {"$alias.value" => { '!=' => undef }}
                );
            }
        }
    }

    # ensure all direct columns are aliased
    for (grep { $columns{$_} } keys %$query) {
        $query->{"$me.$_"} = delete $query->{$_};
    }

    # By creating a select for only ID, we reduce the query time, since id is
    # then the only thing that shows up in the GROUP BY.
    my $subselect = $self->search_rs($query, {
        columns => ['me.id'], distinct => 1, %safe_options
    });

    if(delete $options->{invert_attribute_search})
    {
        my $regular_query = $self->search_rs(undef, { columns => ['me.id'], distinct => 1 });
        $subselect = $regular_query->except_all([$subselect]);
    }
    if (delete $options->{rs_only}) {
        return $self->search_rs({ 'me.id' => { -in => $subselect->as_query }}, { %$options });
    }
    if(delete $options->{as_subselect})
    {
        return $self->search({ 'me.id' => { -in => $subselect->as_query }}, { %$options })->as_subselect_rs->search_rs;
    }
    return $self->search({ 'me.id' => { -in => $subselect->as_query }}, { %$options });
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
        push @column_names, $column_name . '_cascade';
        push @column_names, $column_name . '_type';
        push @columns, \"$alias.value as $column_name";
        push @columns, \"$alias.cascade as ${column_name}_cascade";
        push @columns, \"$alias.type as ${column_name}_type";
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


1;
