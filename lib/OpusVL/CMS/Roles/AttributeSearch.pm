package OpusVL::CMS::Roles::AttributeSearch;

use Moose::Role;
use Switch::Plain;
use Data::Dump;

sub _attribute_search {
    my ($self, $site, $query, $options) = @_;

    $query   //= {};
    $options //= {};

    my $me = $self->current_source_alias;

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
    my $join_count = 0;
    my %safe_options = map { $_ => $options->{$_} } grep { /join|prefetch/ } keys %$options;

    foreach my $field (@params) {
        if (exists $query->{$field}) {
            my $value = delete $query->{$field};
            $join_count++;
            my $alias = 'attribute_values';
            my $field_alias = 'field';

            push @{$safe_options{join}}, {
                $alias => $field_alias
            };

            if ($join_count > 1) {
                $_ .= "_$join_count" for $alias, $field_alias;
            }

            if ($site->profile) {
                $query->{"$field_alias.site_id"} = $site->profile->id;
            }
            else {
                $query->{"$field_alias.site_id"} = $site->id;
            }
            $query->{"$field_alias.code"} = $field;
            $query->{"$field_alias.active"} = 1;
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

    if (delete $options->{rs_only}) {
        return $self->search_rs({ 'me.id' => { -in => $subselect->as_query }}, { %$options });
    }
    if(delete $options->{as_subselect})
    {
        return $self->search({ 'me.id' => { -in => $subselect->as_query }}, { %$options })->as_subselect_rs->search_rs;
    }
    return $self->search({ 'me.id' => { -in => $subselect->as_query }}, { %$options });
}

1;
