use Test::Requires qw/Test::PostgreSQL/;
use Test::Most;
use Test::DBIx::Class {
    schema_class => 'OpusVL::CMS::Schema',
    traits => [qw/Testpostgresql/],
}, 'Page', 'Site', 'Attachment', 'Asset', 'AssetAttributeDetail', 'PageAttributeDetail';

ok my $profile = Site->create({ name => 'test' });
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
});
my $asset_att = $site->create_related('asset_attributes', {
    code => 'logo',
    type => 'text',
    name => 'Logo',
    active => 1,
});
ok my $attachment_attribute = $site->create_related('attachment_attribute_details',
    {
        code => 'test',
        name => 'Test',
        type => 'text',
        active => 1,
    }
);
ok my $attribute = $site->create_related('page_attribute_details',
    {
        code => 'test',
        name => 'Original',
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
                    field_id => $attachment_attribute->id,
                },
            ],
        }
    ],
});

sub still_intact
{
    is Page->count, 1;
    is Site->count, 2;
}

still_intact();
$page->attribute_values->delete;
is PageAttributeDetail->count, 1;
still_intact();
PageAttributeDetail->delete;
still_intact();
AssetAttributeDetail->delete;

done_testing;
