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

my @page_attributes = (
    'main_menu' => {
        code    => 'main_menu',
        name    => 'Main Menu',
        type    => 'boolean',
    },
    'gallery_album_title' => {
        code => 'gallery_album_title',
        name => 'Gallery Album Title',
        type => 'text',
    },
    'quick_link' => {
        code => 'quick_link',
        name => 'Quick Links',
        type => 'boolean',
    },
    'corporate_site_top_menu' => {
        'corporate_site_top_menu',
        name => 'Corporate Site Top Menu',
        type => 'boolean',
    },
    'corporate_link_panel_square_colour' => {
        code => 'corporate_link_panel_square_colour',
        name => 'Corporate Links Panel Square Colour',
        type => 'select',
        values => ['Blue', 'Grey', 'Orange', 'Green', 'Teal', 'Grey Light', 'Grey Dark'],
    },
    'title' => {
        code => 'title',
        name => 'Title',
        type => 'text',
    },
    'top_menu' => {
        code => 'top_menu',
        name => 'Top Menu',
        type => 'boolean',
    },
    'corporate_page_style' => {
        code => 'corporate_page_style',
        name => 'Corporate Page Style',
        type => 'select',
        values => ['Blue', 'Orange', 'Red'],
    },
    'quick_links' => {
        code => 'quick_links',
        name => 'Quick Links',
        type => 'select',
    },
    'portfolio_set' => {
        code => 'portfolio_set',
        name => 'Portfolio Set',
        type => 'text',
    },
    'carousel_set' => {
        code => 'carousel_set',
        name => 'Carousel Set',
        type => 'text',
    }
);
    
# iterate over each site
foreach my $site ($schema->resultset('Site')->all) {
    say "Adding default attributes to " . $site->name;
    # page attributes
    for my $attr (@page_attributes) {
        if ($attr->{code} and $attr->{code} ne '') {
            if (not $site->page_attribute_details->search({ code => $attr->{code} })->first) {
                say "Page attribute ($attr->{code}) in " . $site->name . ": NOT FOUND";
                say "Adding $attr->{code} as $attr->{type}";
                my $new_attr = $site->create_related('page_attribute_details', {
                    code => $attr->{code},
                    name => $attr->{name},
                    type => $attr->{type},
                    active => 1,
                    cascade => 0
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
