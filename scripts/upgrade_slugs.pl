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
my $asset_rs   = $schema->resultset('Asset');
my $element_rs = $schema->resultset('Element');
my $att_rs     = $schema->resultset('Attachment');

while(my $asset = $asset_rs->next) {
    if ($asset->slug eq '') {
        $asset->update({ slug => $asset->id });
    }
}

while(my $element = $element_rs->next) {
    if ($element->slug eq '') {
        $element->update({ slug => $element->id });
    }
}

while(my $att = $att_rs->next) {
    if ($att->slug eq '') {
        $att->update({ slug => $att->id });
    }
}

