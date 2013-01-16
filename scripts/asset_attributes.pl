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

my @asset_attributes = (
    'portfolio' => {
        code => 'portfolio',
        name => 'Portfolio',
        type => 'select',
    },
    'carousel' => {
        code => 'carousel',
        name => 'Carousel',
        type => 'select',
    },
);

my $detail_rs = $schema->resultset('AssetAttributeDetail');

# iterate over each site
foreach my $site ($schema->resultset('Site')->all) {
    say "Adding default attributes to " . $site->name;
    # page attributes
    for my $attr (@asset_attributes) {
        if ($attr->{code} and $attr->{code} ne '') {
            if (not $detail_rs->search({ code => $attr->{code} })->first) {
                say "Asset attribute ($attr->{code}) in " . $site->name . ": NOT FOUND";
                say "Adding $attr->{code} as $attr->{type}";
                my $new_attr = $detail_rs->create({
                    site_id => $site->id,
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
