use Test::Most;
use Test::DBIx::Class {
    schema_class => 'OpusVL::CMS::Schema',
}, 'Page', 'Site', 'Attachment';

ok my $profile = Site->create({ name => 'test' });
ok my $site = Site->create({ name => 'test', profile_site => $profile->id });

ok my $profile_attribute = $profile->create_related('page_attribute_details',
    {
        code => 'test',
        name => 'Original',
        type => 'text',
        active => 1,
    }
);
ok $profile->create_related('attachment_attribute_details',
    {
        code => 'test',
        name => 'Original',
        type => 'text',
        active => 1,
    }
);

ok my $attribute = $site->create_related('page_attribute_details',
    {
        code => 'test',
        name => 'Test',
        type => 'text',
        active => 1,
    }
);
ok my $attachment_attribute = $site->create_related('attachment_attribute_details',
    {
        code => 'test',
        name => 'Test',
        type => 'text',
        active => 1,
    }
);

ok my $template = $site->create_related('templates', {
    name => 'Default',
    template_contents => [{
        data => '[% PROCESS content %]',
    }],
});
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
            value => 'a test value',
            field_id => $attribute->id,
        }
    ],
    attachments => [
        {
            slug => 'test.css',
            filename => 'test.css',
            mime_type => 'text/css',
            att_data => [
                {
                    data => '/* test */',
                }
            ],
            attribute_values => [
            ],
        }
    ],
});
ok my $page2 = $site->create_related('pages', {
    url => '/about',
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
        #{
        #    value => 'a test value',
        #    field_id => $attribute->id,
        #}
    ],
    attachments => [
        {
            slug => 'other.css',
            filename => 'other.css',
            mime_type => 'text/css',
            att_data => [
                {
                    data => '/* test2 */',
                }
            ],
            attribute_values => [
                {
                    value => 'pick me',
                    field_id => $attachment_attribute->id,
                }
            ],
        }
    ],
});
# lets add some attributes.
# FIXME: probably want to change this prototype.
ok my $pages = Page->attribute_search($site, { test => 'a test value'}, {});
is $pages->count, 1;
is $pages->first->url, '/';

my $a = Attachment->attribute_search($site->id, {
    test => 'pick me',
});
is $a->count, 1;
# FIXME: do attachment and asset attribute_search.


done_testing;
