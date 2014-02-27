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
    'mobile_review_text' => {
        code => 'mobile_review_text',
        name => 'Mobile Review Text',
        type => 'text',
    },
    'mobile_review_name' => {
        code => 'mobile_review_name',   
        name => 'mobile_review_name',
        type => 'text',
    },
    'mobile_show_in_navmenu' => {
        code => 'mobile_show_in_navmenu',
        name => 'Mobile - Show in Navigational Menu?',
        type => 'boolean',
    },
    'mobile_icon' => {
        code => 'mobile_icon',
        name => 'Mobile - Icon',
        type => 'text',
    },
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
