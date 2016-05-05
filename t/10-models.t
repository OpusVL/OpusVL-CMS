#!/usr/bin/env perl

use Dir::Self;
use lib __DIR__.'/lib';

use Test::Most;
use Moose::Util qw/ensure_all_roles/;
use OpusVL::CMS::Schema;

ensure_all_roles(
    "OpusVL::CMS::Schema" =>
        "OpusVL::DBIC::Helper::RolesFor::Schema::DataInitialisation",
);

ensure_all_roles(
    "OpusVL::CMS::Schema::ResultSet::Page" =>
        "OpusVL::CMS::RolesFor::Schema::ResultSet::Page" # in lib/
);
ensure_all_roles(
    "OpusVL::CMS::Schema::ResultSet::Template" =>
        "OpusVL::CMS::RolesFor::Schema::ResultSet::Template" # in lib/
);
my $schema = OpusVL::CMS::Schema->connect('dbi:SQLite:dbname=:memory:',"","");
$schema->deploy_with_data;

plan tests => 1;

ok($schema->resultset('Page')->find(1)->get_attachments, "Attachments don't crash");
