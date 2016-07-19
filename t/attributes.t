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
ok my $profile_only_attribute = $profile->create_related('page_attribute_details',
    {
        code => 'simple',
        name => 'Simple',
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
ok my $profile_aa = $profile->create_related('attachment_attribute_details',
    {
        code => 'wat',
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
            value => 'not',
            field_id => $profile_only_attribute->id,
        },
        {
            value => 'a test value',
            field_id => $attribute->id,
        },
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
                {
                    value => 'me',
                    field_id => $profile_aa->id,
                },
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
        #},
        {
            value => 'yes',
            field_id => $profile_only_attribute->id,
        }
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
                    value => 'not me',
                    field_id => $profile_aa->id,
                },
                {
                    value => 'pick me',
                    field_id => $attachment_attribute->id,
                },
            ],
        }
    ],
});
# lets add some attributes.
# FIXME: probably want to change this prototype.
ok my $pages = Page->attribute_search($site, { test => 'a test value'}, {}), 'Setup resultset';
is $pages->count, 1, 'Correct number of pages';
is $pages->first->url, '/';

my $a = Attachment->attribute_search($site, {
    test => 'pick me',
});
is $a->count, 1;

my $a2 = Attachment->attribute_search($site, {
    wat => 'me',
});
is $a2->count, 1;
is $a2->first->slug, 'test.css';

ok my $simple_pages = Page->attribute_search($site, { simple => 'yes'}, {});
is $simple_pages->count, 1;
is $simple_pages->first->url, '/about';

# FIXME: do asset attribute_search.
done_testing;
