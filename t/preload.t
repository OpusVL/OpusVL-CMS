use Test::Most;
use Test::DBIx::Class {
    schema_class => 'OpusVL::CMS::Schema',
    traits => [qw/Testpostgresql/],
}, 'Page', 'Site', 'Attachment', 'Asset';

ok my $profile = Site->create({ name => 'test' }), "Created a profile";
ok my $site = Site->create({ 
        name => 'main', 
        profile_site => $profile->id, 
        site_attributes => [
            {
                code => 'test',
                name => 'Test',
                value => 'test value',
            },
        ],
    }),
    "Created a site"
;
is $site->attribute('test'), undef, 'site attribute not accessible because not on profile';
is $site->attribute('test'), undef, 'should be cached';

ok my $pesky_site = Site->create({ 
        name => 'pesky site', 
        profile_site => $profile->id, 
        site_attributes => [
            {
                code => 'test',
                name => 'Test',
                value => 'test value',
            },
        ],
    }),
    "Created a site to be a pest"
;
ok my $template = $site->create_related('templates', {
    name => 'Default',
    template_contents => [{
        data => '[% PROCESS content %]',
    }],
}), "Created simple template";


my $set_embargo_date = DateTime->today;
subtest 'Page attributes' => sub {
    my $site = Site->find({ name => 'main' });
    ok my $profile_attr = $profile->create_related('page_attribute_details',
        {
            code => 'profile_attr',
            name => 'Simple',
            type => 'text',
            active => 1,
        }
    ), "Created profile page attribute";

    ok my $external_link = $profile->create_related('page_attribute_details',
        {
            code => 'external_link',
            name => 'External Link',
            active => 1,
        }
    ), "Created profile page attribute";

    ok my $pesky_link = $pesky_site->create_related('page_attribute_details',
        {
            code => 'external_link',
            name => 'External Link',
            active => 1,
        }
    ), "Created pesky page attribute";

    ok my $new_tab = $profile->create_related('page_attribute_details',
        {
            code => 'open_in_new_tab',
            name => 'Open In New Tab',
            type => 'boolean',
            active => 1,
        }
    ), "Created profile page attribute";

    ok my $main_menu = $profile->create_related('page_attribute_details',
        {
            code => 'main_menu',
            name => 'Main Menu',
            type => 'boolean',
            active => 1,
        }
    ), "Created profile page attribute";
    ok my $exclude_from_main_menu = $profile->create_related('page_attribute_details',
        {
            code => 'exclude_from_menu',
            name => 'Exclude from Main Menu',
            type => 'boolean',
            active => 1,
        }
    ), "Created profile page attribute";

    ok my $embargo = $profile->create_related('page_attribute_details',
        {
            code => 'embargo_date',
            name => 'Embargo date',
            type => 'date',
            active => 1,
        }
    ), "Created profile page attribute";


    ok my $page = $site->create_related('pages', {
        url => '/',
        template_id => $template->id,
        h1 => 'Header',
        title => 'Test',
        breadcrumb => 'Wat',
        page_contents => [
            {
                body => '<h1>Hello World</h1>',
            }
        ],
        attribute_values => [
            {
                value => 'a nice value',
                field_id => $profile_attr->id,
            },
            {
                value => '1',
                field_id => $main_menu->id,
            },
            {
                value => undef,
                field_id => $exclude_from_main_menu->id,
            },
            {
                value => '1',
                field_id => $new_tab->id,
            },
            {
                value => 'http://opusvl.com',
                field_id => $pesky_link->id,
            },
            {
                value => 'http://opusvl.com',
                field_id => $external_link->id,
            },
        ],
    }), "Created page with external link";

    ok my $page2 = $site->create_related('pages', {
        url => '/p2',
        template_id => $template->id,
        h1 => 'Header',
        title => 'Test',
        breadcrumb => 'Wat',
        page_contents => [
            {
                body => '<h1>Hello World</h1>',
            }
        ],
        attribute_values => [
            {
                value => 'A nice value',
                field_id => $profile_attr->id,
            },
            {
                value => '1',
                field_id => $main_menu->id,
            },
            {
                value => undef,
                field_id => $new_tab->id,
            },
            {
                value => undef,
                field_id => $external_link->id,
            },
        ],
    }), "Created page without external link";

    ok my $page3 = $site->create_related('pages', {
        url => '/p3',
        template_id => $template->id,
        h1 => 'Header',
        title => 'Test',
        breadcrumb => 'Wat',
        page_contents => [
            {
                body => '<h1>Hello World</h1>',
            }
        ],
        attribute_values => [
            {
                value => 'another nice value',
                field_id => $profile_attr->id,
            },
            {
                value => undef,
                field_id => $main_menu->id,
            },
            {
                value => undef,
                field_id => $new_tab->id,
            },
            {
                value => undef,
                field_id => $external_link->id,
            },
        ],
    }), "Created page not on main menu";

    ok my $page4 = $site->create_related('pages', {
        url => '/p4',
        template_id => $template->id,
        h1 => 'Header',
        title => 'Test',
        breadcrumb => 'Wat',
        page_contents => [
            {
                body => '<h1>Hello World</h1>',
            }
        ],
        attribute_values => [
            {
                value => 'something something',
                field_id => $profile_attr->id,
            },
            {
                value => '1',
                field_id => $main_menu->id,
            },
            {
                date_value => $set_embargo_date,
                field_id => $embargo->id,
            },
            {
                value => '1',
                field_id => $new_tab->id,
            },
        ],
    }), "Created page with external link";

    my $pages = Page->attribute_search($site, { $profile_attr->code => 'a nice value'});
    is $pages->count, 1, "Found page by profile value";
    is $pages->first->url, '/', "correct page identified";
    $pages = Page->attribute_search($site, { $profile_attr->code => 'a nice value'}, {as_rs => 1});
    is $pages->count, 1, "Found page by profile value";
    is $pages->first->url, '/', "correct page identified";
    ok $pages = Page->attribute_search($site, { $profile_attr->code => 'a nice value'}, {as_subselect => 1}), 'as subselect';
    is $pages->count, 1, "Found page by profile value";
    is $pages->first->url, '/', "correct page identified";
    ok $pages = Page->attribute_search($site, { $profile_attr->code => 'a nice value'}, {order_by => []}), 'no order by';
    is $pages->count, 1, "Found page by profile value";
    is $pages->first->url, '/', "correct page identified";

    $pages = Page->attribute_search($site, { 
            $external_link->code => 'http://opusvl.com', 
            $profile_attr->code => { '!=' => 'yes'}
        }, {});
    is $pages->count, 1, "Found page by two attributes";

    $pages = Page->attribute_search($site, { 
            $external_link->code => 1, 
            $profile_attr->code => { '!=' => 'a nice value'}
        }, {});
    is $pages->count, 0, "Filtered out page by two attributes";
};

subtest prefetch => sub {
    # equivalent to [% cms.pages %]
    my $site = Site->find({ name => 'main' });
    # in theory there should be just one query after this point.
    my $pages = $site->pages->published->attribute_search($site, {
        main_menu => 1,
        # perhaps check it's not been excluded from the main menu?
    }, { load_attributes => [qw/external_link open_in_new_tab embargo_date/]});
    is $pages->count, 3;
    # FIXME: somehow check we aren't emitting queries.
    my $expected = {
        '/' => {
            external_link => 'http://opusvl.com',
            open_in_new_tab => 1,
            embargo_date => undef,
        },
        '/p2' => {
            external_link => undef,
            open_in_new_tab => undef,
            embargo_date => undef,
        },
        '/p4' => {
            external_link => undef,
            open_in_new_tab => 1,
            embargo_date => $set_embargo_date->ymd,
        },
    };
    my $actual = {};
    for my $page ($pages->all)
    {
        my $embargo_date = $page->attribute('embargo_date');
        $embargo_date = $embargo_date->ymd if $embargo_date;

        $actual->{$page->url} = {
            external_link => $page->attribute('external_link'),
            open_in_new_tab => $page->attribute('open_in_new_tab'),
            embargo_date => $embargo_date,
        };
    }
    eq_or_diff $actual, $expected, 'Retrieved correct params';
    ok $pages = $site->pages->published->attribute_search($site, undef, { load_attributes => [qw/external_link open_in_new_tab embargo_date/]}), 'No criteria';
    is $pages->count, 4;
    $expected->{'/p3'} = {
        external_link => undef,
        open_in_new_tab => undef,
        embargo_date => undef,
    };
    for my $page ($pages->all)
    {
        my $embargo_date = $page->attribute('embargo_date');
        $embargo_date = $embargo_date->ymd if $embargo_date;

        $actual->{$page->url} = {
            external_link => $page->attribute('external_link'),
            open_in_new_tab => $page->attribute('open_in_new_tab'),
            embargo_date => $embargo_date,
        };
    }
    eq_or_diff $actual, $expected, 'Retrieved correct params';
    ok $pages = $site->pages->published->attribute_search($site, undef, { load_attributes => [qw//]}), 'No criteria, no preload';
    is $pages->count, 4;
    for my $page ($pages->all)
    {
        my $embargo_date = $page->attribute('embargo_date');
        $embargo_date = $embargo_date->ymd if $embargo_date;

        $actual->{$page->url} = {
            external_link => $page->attribute('external_link'),
            open_in_new_tab => $page->attribute('open_in_new_tab'),
            embargo_date => $embargo_date,
        };
    }
    eq_or_diff $actual, $expected, 'Retrieved correct params';
};

done_testing;
