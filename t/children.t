# This tests that the priority field of child pages actually has an effect.
# There is probably scope for testing more stuff than that.
use Test::Most;
use Test::DBIx::Class {
    schema_class => 'OpusVL::CMS::Schema',
    traits => [qw/Testpostgresql/],
}, 'Page', 'Site', 'Attachment', 'Asset';

sub check_priority
{
    my @children = @_;
    my $count = 0;
    my $priority = 0;
    for my $child (@children)
    {
        ok $child->priority > $priority, 'Priority order correct';
        $priority = $child->priority;
        $count++;
    }
    return $count;
}

ok my $profile = Site->create({ name => 'test' }), "Created a profile";
ok my $site = Site->create({ 
        name => 'test', 
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

ok my $template = $site->create_related('templates', {
    name => 'Default',
    template_contents => [{
        data => '[% PROCESS content %]',
    }],
}), "Created simple template";

ok my $profile_attr = $profile->create_related('page_attribute_details',
    {
        code => 'profile_attr',
        name => 'Simple',
        type => 'text',
        active => 1,
    }
), "Created profile page attribute";

ok my $site_attr = $site->create_related('page_attribute_details',
    {
        code => 'site_attr',
        name => 'Test',
        type => 'text',
        active => 1,
    }
), "Created site page attribute";


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
            value => 'a test value',
            field_id => $site_attr->id,
        },
    ],
}), "Created page with one of each attribute";

ok my $child1 = $site->create_related('pages', {
    url => '/child1',
    template_id => $template->id,
    h1 => 'Header',
    title => 'Test',
    breadcrumb => 'Wat',
    priority => 30,
    parent_id => $page->id,
    page_contents => [
        {
            body => '<h1>Something</h1>',
        }
    ],
    attribute_values => [
        {
            value => 'a nice value',
            field_id => $profile_attr->id,
        },
        {
            value => 'a test value',
            field_id => $site_attr->id,
        },
    ],
}), "Created first child";
ok my $child2 = $site->create_related('pages', {
    url => '/child2',
    template_id => $template->id,
    h1 => 'Header',
    title => 'Test',
    breadcrumb => 'Wat',
    priority => 10,
    parent_id => $page->id,
    page_contents => [
        {
            body => '<h1>Something else</h1>',
        }
    ],
    attribute_values => [
        {
            value => 'a nice value',
            field_id => $profile_attr->id,
        },
        {
            value => 'a test value',
            field_id => $site_attr->id,
        },
    ],
}), "Created second child";
ok my $child3 = $site->create_related('pages', {
    url => '/child3',
    template_id => $template->id,
    h1 => 'Header',
    title => 'Test',
    breadcrumb => 'Wat',
    priority => 40,
    parent_id => $page->id,
    page_contents => [
        {
            body => '<h1>Something else again</h1>',
        }
    ],
    attribute_values => [
        {
            value => 'a nice value',
            field_id => $profile_attr->id,
        },
        {
            value => 'a test value',
            field_id => $site_attr->id,
        },
    ],
}), "Created third child";

my $count = check_priority($page->children->all);
is $count, 3, 'Found all 3 children';

$count = check_priority($page->children({ profile_attr => 'a nice value' })->all);
is $count, 3, 'Found all 3 children';


done_testing;
