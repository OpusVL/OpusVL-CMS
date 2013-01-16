#!/usr/bin/env perl

use 5.010;
use lib 'lib';
use OpusVL::CMS::Schema;

if (scalar(@ARGV) < 2) {
    printf(STDERR "Usage: %s <database> <username> <password>\n", $0);
    exit(1);
}

my ($database, $username, $password) = @ARGV;
my $schema = OpusVL::CMS::Schema->connect("dbi:Pg:dbname=${database}", $username, $password);

my @attachment_attributes = (
    'title' => {
        code => 'title',
        name => 'Title',
        type => 'text',
    },
    'gallery_album' => {
        code => 'gallery_album',
        name => 'Gallery Album',
        type => 'select',
     },
    'gallery_image_id' => {
        code => 'gallery_image_id',
        name => 'Gallery Image ID',
        type => 'text',
    },
    'panel_link' => {
        code => 'panel_link',
        name => 'Panel Link',
        type => 'text',
    },
    'link_panel' => {
        code => 'link_panel',
        name => 'Link Panel',
        type => 'select',
        values => ['Slot 1', 'Slot 2', 'Slot 3'],
    },
    'right_link_panel' => {
        code => 'right_link_panel',
        name => 'Right Link Panel',
        type => 'select',
        values => ['Slot 1', 'Slot 2', 'Slot 3', 'Slot 4'],
    },
    'special_offers_panel' => {
        code => 'special_offers_panel',
        name => 'Special Offers Panel',
        type => 'select',
        values => ['Slot 1', 'Slot 2', 'Slot 3', 'Slot 4', 'Slot 5', 'Slot 6'],
    },
);
    
# iterate over each site
foreach my $site ($schema->resultset('Site')->all) {
    say "Adding default attributes to " . $site->name;
    # page attributes
    for my $attr (@attachment_attributes) {
        if ($attr->{code} and $attr->{code} ne '') {
            if (not $site->attachment_attribute_details->search({ code => $attr->{code} })->first) {
                say "Attachment attribute ($attr->{code}) in " . $site->name . ": NOT FOUND";
                say "Adding $attr->{code} as $attr->{type}";
                my $new_attr = $site->create_related('attachment_attribute_details', {
                    code => $attr->{code},
                    name => $attr->{name},
                    type => $attr->{type},
                    active => 1,
                });
                say "Added.";

                # does it have values?
                if (@{$attr->{values}} > 0) {
                    say "Adding values to $attr->{code}";
                    for my $value (@{$attr->{values}}) {
                        $new_attr->create_related('field_values', { value => $value });
                    }
                }
            }
        }
    }   
}
