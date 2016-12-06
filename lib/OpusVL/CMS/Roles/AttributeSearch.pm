package OpusVL::CMS::Roles::AttributeSearch;

use Moose::Role;
use Switch::Plain;
use Data::Dump;

sub _attribute_search {
    my ($self, $site, $query, $options) = @_;

    $query   //= {};
    $options //= {};

    my $me = $self->current_source_alias;

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

    if (!%$query) {
        if (delete $options->{rs_only}) {
            return $self->search_rs(undef, $options);
        }
        return $self->search(undef, $options);
    }

    # lets make this simpler.
    # forget anything with a . as they presumably knew what they were doing.
    # then check the columns on the resultset to see if it was presumably a param.
    my %columns = map { $_ => 1 } $self->result_source->columns;
    my @params = grep { !$columns{$_} } grep { !/\./ } keys %$query;
    my $join_count = 0;
    my %safe_options = map { $_ => $options->{$_} } grep { /join|prefetch/ } keys %$options;

    foreach my $field (@params) {
        if (my $value = delete $query->{$field}) {
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
                {"$alias.value" => { '!=' => undef }} # need to double check this is the right thing.
            );
        }
    }

    # ensure all direct columns are aliased
    for (grep { $columns{$_} } keys %$query) {
        $query->{"$me.$_"} = delete $query->{$_};
    }

    $sort = delete $options->{order_by};

    # By creating a select for only ID, we reduce the query time, since id is
    # then the only thing that shows up in the GROUP BY.
    my $subselect = $self->search_rs($query, {
        columns => ['me.id'], distinct => 1, %safe_options
    });

    if (delete $options->{rs_only}) {
        return $self->search_rs({ 'me.id' => { -in => $subselect->as_query }}, { %$options, order_by => $sort });
    }
    return $self->search({ 'me.id' => { -in => $subselect->as_query }}, { %$options, order_by => $sort });
}

1;
