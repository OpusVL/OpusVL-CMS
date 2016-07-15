sub {
    my $schema = shift;
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
};
