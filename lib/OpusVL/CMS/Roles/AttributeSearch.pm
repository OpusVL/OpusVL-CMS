package OpusVL::CMS::Roles::AttributeSearch;

use Moose::Role;
use Switch::Plain;

sub _attribute_search {
    my ($self, $site, $query, $options) = @_;

    $query   //= {};
    $options //= {};

    my $me = $self->current_source_alias;

    if (%$query) {
        # lets make this simpler.
        # forget anything with a . as they presumably knew what they were doing.
        # then check the columns on the resultset to see if it was presumably a param.
        my %columns = map { $_ => 1 } $self->result_source->columns;
        my @params = grep { !$columns{$_} } grep { !/\./ } keys %$query;
        my $join_count = 0;

        foreach my $field (@params) {
            if (my $value = delete $query->{$field}) {
                $join_count++;
                my $alias = 'attribute_values';
                my $field_alias = 'field';
                my $site_alias = 'site';

                push @{$options->{join}}, { 
                    $alias => { $field_alias => $site_alias }
                };

                if ($join_count > 1) {
                    $_ .= "_$join_count" for $alias, $field_alias, $site_alias;
                }

                if ($site->profile) {
                    $query->{'-or'} = [
                        {"$site_alias.id" => $site->id},
                        {"$site_alias.id" => $site->profile->id},
                    ]
                }
                else {
                    $query->{"$site_alias.id"} = $site->id;
                }
                $query->{"$field_alias.code"} = $field;
                $query->{"$field_alias.active"} = 1;
                $query->{'-and'} = [
                    {"$alias.value" => $value},
                    {"$alias.value" => { '!=' => undef }} # need to double check this is the right thing.
                ];
            }
        }
        $options->{distinct} = 1;


        # ensure all direct columns are aliased
        for (grep { $columns{$_} } keys %$query) {
            $query->{"$me.$_"} = delete $query->{$_};
        }
    }

    if (my $sort = delete $options->{sort}) {
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

    if (delete $options->{rs_only}) {
        return $self->search_rs($query, $options);
    }
    return $self->search($query, $options);
}

1;
