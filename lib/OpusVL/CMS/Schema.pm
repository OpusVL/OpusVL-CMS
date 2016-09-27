package OpusVL::CMS::Schema;

###########################################################################################

=head1 NAME

OpusVL::CMS::Schema - 

=head1 DESCRIPTION

Base CMS schema

=head1 METHODS

=head1 BUGS


=cut

###########################################################################################

use DBIx::Class::Schema;
use Moose;
BEGIN { extends qw/DBIx::Class::Schema/; }

our $VERSION = '31';

__PACKAGE__->load_namespaces;

with 'OpusVL::DBIC::Helper::RolesFor::Schema::DataInitialisation';
with 'OpusVL::AppKit::RolesFor::Schema::AppKitAuthDB';
__PACKAGE__->merge_authdb;
__PACKAGE__->meta->make_immutable;

sub schema_version { 29 }

1;
