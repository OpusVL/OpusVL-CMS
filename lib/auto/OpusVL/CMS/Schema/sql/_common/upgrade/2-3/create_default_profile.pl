use DBIx::Class::Report;

sub {
    my $schema = shift;
    my $users = $schema->resultset('User');
    my $sites = $schema->resultset('Site');
    my $elements = $schema->resultset('Element');
    my $assets = $schema->resultset('Asset');
    my $templates = $schema->resultset('Template');
    my $profile_info = {
        name => 'Default Profile',
        template => 1,
    };
    die 'Default profile already exists' if $sites->search($profile_info)->count > 0;
    my $profile = $sites->create($profile_info);
    my $site_attr  = $profile->site_attributes;
    my $page_attr  = $profile->page_attribute_details;
    my $att_attr   = $profile->attachment_attribute_details;

    # NOTE: we don't have the resultset any more.
    # so we create it temporarily for the migration.
    my $default_attributes = DBIx::Class::Report->new(
        schema => $schema,
        sql => 'select id, code, name, value, type, field_type from default_attributes',  
        columns => [
            "id",
            {
                data_type         => "integer",
                is_auto_increment => 1,
                is_nullable       => 0,
                sequence          => "default_attributes_id_seq",
            },
            "code",
            {
                data_type   => "text",
                is_nullable => 0,
                original    => { data_type => "varchar" },
            },
            "name",
            {
                data_type   => "text",
                is_nullable => 0,
                original    => { data_type => "varchar" },
            },
            "value",
            {
                data_type   => "text",
                is_nullable => 1,
                original    => { data_type => "varchar" },
            },
            "type",
            {
                data_type   => "text",
                is_nullable => 0,
                original    => { data_type => "varchar" },
            },
            "field_type",
            {
                data_type   => "text",
                is_nullable => 1,
                original    => { data_type => "varchar" },
            },
        ]
    );
    for my $attr ($default_attributes->fetch)
    {
        if ($attr->type eq 'site') {
            $site_attr->find_or_create({
                    site_id => $profile->id,
                    code    => $attr->code,
                    value   => $attr->value||'',
                    name    => $attr->name,
                    super   => 1,
                });
        }
        elsif ($attr->type eq 'page') {
            my $new_attr = $page_attr->find_or_create({
                    site_id => $profile->id,
                    name    => $attr->name,
                    code    => $attr->code,
                    type    => $attr->field_type,
                });

            if ($new_attr) {
                if ($attr->field_type eq 'select') {
                    # the select field has values
                    if ($attr->values->count > 0) {
                        for my $value ($attr->values->all) {
                            $new_attr->field_values->find_or_create({
                                    field_id => $new_attr->id,
                                    value    => $value->value
                                });
                        }
                    }
                }
            }
        }
        elsif ($attr->type eq 'attachment') {
            my $new_attr = $att_attr->find_or_create({
                    site_id => $profile->id,
                    name    => $attr->name,
                    code    => $attr->code,
                    type    => $attr->field_type,
                });

            if ($new_attr) {
                if ($attr->field_type eq 'select') {
                    # the select field has values
                    if ($attr->values->count > 0) {
                        for my $value ($attr->values->all) {
                            $new_attr->field_values->find_or_create({
                                    field_id => $new_attr->id,
                                    value    => $value->value
                                });
                        }
                    }
                }
            }
        }
    }
    my $a = $assets->search({ global => 1 })->search_related('site');
    my $e = $elements->search({ global => 1 })->search_related('site');
    my $t = $templates->search({ global => 1 })->search_related('site');
    my $s = $a->union($e)->union($t);
    my @users = $s->search_related('sites_users')->get_column('user_id')->func('distinct');
    my @updates = map { { user_id => $_ } } @users;
    # ensure the users that previously access still do.
    # since we're grouping up the elements from various s this may
    # not be precise.
    for my $user (@updates)
    {
        $profile->create_related('sites_users', $user);
    }
    $sites->search({ template => 0 })->update({ profile_site => $profile->id });
    for my $rs ($assets, $elements, $templates)
    {
        $rs->search({ global => 1 })->update({ site => $profile->id });
    }
    # find users with user restrictions.
    my $restricted = $users->search({
            'parameter.parameter' => 'Restricted'
        },
        {
            join => { users_parameters => 'parameter' }
        }
    );
    if($restricted->count > 0)
    {
        # if we have some, create a role for the restricted users.
        # then ensure all the users have it.
        my $feature = 'Pages/Restrict Access to Individual Items';
        my $roles = $schema->resultset('Role');
        my $role = $roles->find_or_create({ role => 'Restricted Users' });
        my $feature_rs = $schema->resultset('Aclfeature');
        my $f = $feature_rs->find_or_create({ feature => $feature });
        $f->add_to_roles($role);
        for my $user ($restricted->all)
        {
            $user->add_to_roles($role);
        }
    }
};
