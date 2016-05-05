package OpusVL::CMS::Schema;

###########################################################################################

=head1 NAME

OpusVL::CMS::Schema - 

=head1 DESCRIPTION

Base CMS schema

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

Jon Allen (JJ) - jj@opusvl.com

=head1 COPYRIGHT & LICENSE

Copyright (C) 2012 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut

###########################################################################################

use DBIx::Class::Schema;
use Moose;
BEGIN { extends qw/DBIx::Class::Schema/; }
__PACKAGE__->load_namespaces;

with 'OpusVL::DBIC::Helper::RolesFor::Schema::DataInitialisation';
with 'OpusVL::AppKit::RolesFor::Schema::AppKitAuthDB';
__PACKAGE__->merge_authdb;
__PACKAGE__->meta->make_immutable;

1;
