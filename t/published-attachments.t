use Test::Most;
use Test::DBIx::Class {
    schema_class => 'OpusVL::CMS::Schema',
    traits => [qw/Testpostgresql/],
}, 'Page', 'Site', 'Attachment', 'Asset';


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

ok $page->create_related('attachments', {
    status => 'deleted',
    priority => 1,
    description => 'broken',
    mime_type => 'text/plain',
    filename => 'broken.txt',
    slug => 'broken',
});

ok $page->create_related('attachments', {
    priority => 2,
    description => 'fine',
    mime_type => 'text/plain',
    filename => 'fine.txt',
    slug => 'fine',
});

ok my $rs = $page->attachments_rs;
ok my $a = $rs->first;
is $a->description, 'fine', 'Make sure we pull out the correct attachment';

done_testing;

