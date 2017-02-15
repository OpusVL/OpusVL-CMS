use Test::Most;
use Test::DBIx::Class {
    schema_class => 'OpusVL::CMS::Schema',
    traits => [qw/Testpostgresql/],
}, 'Page', 'Site', 'Attachment', 'Asset';

ok my $profile = Site->create({ name => 'Main Profile' }), "Created a profile";
ok my $site = Site->create({ 
        name => 'Main Site', 
        profile_site => $profile->id, 
    }),
    "Created a site"
;

ok my $template = $profile->create_related('templates', {
    name => 'Default',
    template_contents => [{
        data => '[% PROCESS content %]',
    }],
}), "Created simple template";

subtest 'Several asset attributes' => sub {
    ok my $gallery_album = $profile->create_related('asset_attribute_details', {
        code => 'gallery_album',
        type => 'text',
        name => 'Gallery Album',
        active => 1,
    }), "Created asset 'gallery_album' attribute";
    ok my $gallery_image_id = $profile->create_related('asset_attribute_details', {
        code => 'gallery_image_id',
        type => 'text',
        name => 'Gallery Image ID',
        active => 1,
    }), "Created asset 'gallery_image_id' attribute";
    ok my $type = $profile->create_related('asset_attribute_details', {
        code => 'type',
        type => 'text',
        name => 'Type',
        active => 1,
    }), "Created asset 'type' attribute";
    ok my $asset = $site->create_related('assets', {
        filename => 'some.css',
        mime_type => 'text/css',
        slug => 'some.css',
        attribute_values => [
            {
                value => 'Gallery Album',
                field_id => $gallery_album->id,
            }
            {
                value => 'Gallery Image ID',
                field_id => $gallery_image_id->id,
            }
            {
                value => 'Type',
                field_id => $type->id,
            }
        ],
        asset_datas => [
            {
                data => '/* blah */',
            },
        ],
    }), "Created asset with three attributes set";

    my $assets = Asset->attribute_search($site, {
        gallery_album => 'Gallery Album',
        gallery_image_id => 'Gallery Image ID',
        type => 'Type',
    });
    is $assets->count, 1, "Asset attribute defined by profile was found via attribute_search against site";
};

done_testing;
