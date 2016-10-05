use Test::Most;
use Test::DBIx::Class {
    schema_class => 'OpusVL::CMS::Schema',
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

subtest 'Asset attributes' => sub {
    ok my $profile_asset_att = $profile->create_related('asset_attributes', {
        code => 'logo',
        type => 'text',
        name => 'Original',
        active => 1,
    }), "Created a profile asset attribute";
    ok my $asset = $site->create_related('assets', {
        filename => 'some.css',
        mime_type => 'text/css',
        slug => 'some.css',
        attribute_values => [
            {
                value => 'blah',
                field_id => $profile_asset_att->id,
            }
        ],
        asset_datas => [
            {
                data => '/* blah */',
            },
        ],
    }), "Create asset with value for site asset attribute";

    is $asset->attribute('logo'), 'blah', "Asset has attribute defined by the profile";
    my $assets = Asset->attribute_search($site, {
        logo => 'blah',
    });
    is $assets->count, 1, "Asset attribute defined by profile was found via attribute_search against site";
};

subtest 'Page attributes' => sub {
    ok my $profile_only_attribute = $profile->create_related('page_attribute_details',
        {
            code => 'profile',
            name => 'Simple',
            type => 'text',
            active => 1,
        }
    ), "Created profile page attribute";

    ok my $attribute = $site->create_related('page_attribute_details',
        {
            code => 'site',
            name => 'Test',
            type => 'text',
            active => 1,
        }
    ), "Created site page attribute";

    ok my $pesky_attribute = $pesky_site->create_related('page_attribute_details',
        {
            code => 'pest',
            name => 'Pest',
            type => 'text',
            active => 1,
        }
    ), "Created page attribute on another site";

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
                field_id => $profile_only_attribute->id,
            },
            {
                value => 'a test value',
                field_id => $attribute->id,
            },
            {
                value => 'a pesky value',
                field_id => $pesky_attribute->id,
            },
        ],
#        attachments => [
#            {
#                slug => 'test.css',
#                filename => 'test.css',
#                mime_type => 'text/css',
#                att_data => [
#                    {
#                        data => '/* test */',
#                    }
#                ],
#                attribute_values => [
#                    {
#                        value => 'me',
#                        field_id => $profile_aa->id,
#                    },
#                ],
#            }
#        ],
    }), "Created page with one of each attribute";

    my $pages = Page->attribute_search($site, { site => 'a test value'}, {});
    is $pages->count, 1, "Found page by site value";
    is $pages->first->url, '/', "correct page identified";
    is $pages->first->attribute('site'), "a test value", "Correct site attr";
    is $pages->first->attribute('profile'), "a nice value", "Correct profile attr";


    $pages = Page->attribute_search($site, { profile => 'a nice value'}, {});
    is $pages->count, 1, "Found page by profile value";
    is $pages->first->url, '/', "correct page identified";

    $pages = Page->attribute_search($site, { pest => 'a pesky value'}, {});
    is $pages->count, 0, "Did not find page by another site's value";

    $pages = Page->attribute_search($site, { 
            site => 'a test value', 
            profile => { '!=' => 'yes'}
        }, {});
    is $pages->count, 1, "Found page by two attributes";
};

subtest 'Attachment attributes' => sub {
    ok my $profile_aa = $profile->create_related('attachment_attribute_details',
        {
            code => 'profile',
            name => 'Original',
            type => 'text',
            active => 1,
        }
    ), "Created profile attachment attribute";

    ok my $attachment_attribute = $site->create_related('attachment_attribute_details',
        {
            code => 'site',
            name => 'Test',
            type => 'text',
            active => 1,
        }
    ), "Created site attachment attribute";

    ok my $pesky_attribute = $pesky_site->create_related('attachment_attribute_details',
        {
            code => 'pesky',
            name => 'Pest',
            type => 'text',
            active => 1,
        }
    ), "Created pesky attachment attribute";

    ok my $page = $site->create_related('pages', {
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
        attachments => [
            {
                slug => 'test.css',
                filename => 'test.css',
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
                    {
                        value => 'avoid me',
                        field_id => $pesky_attribute->id,
                    },
                ],
            }
        ],
    }), "Created /about page";
    
    my $s_att = Attachment->attribute_search($site, {
        site => 'pick me',
    });
    is $s_att->count, 1, "Found attachment by site attr";
    is $s_att->first->attribute('site'), 'pick me', "Correct attribute value";

    my $p_att = Attachment->attribute_search($site, {
        profile => 'not me',
    });
    is $p_att->count, 1, "Found attachment by profile attr";
    is $p_att->first->slug, 'test.css', "Correct slug";

    my $bad_att = Attachment->attribute_search($site, {
        pesky => 'avoid me',
    });
    is $bad_att->count, 0, "Did not find attachment by pesky attr";
};
done_testing;
