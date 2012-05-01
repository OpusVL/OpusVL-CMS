package OpusVL::CMS::Schema::Result::Aliases;

=head1 NAME

OpusVL::CMS::Schema::Result::Aliases -

=head1 DESCRIPTION

Schema to support URL aliases in the SimpleCMS

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

OpusVL - JJ

=head1 COPYRIGHT & LICENSE

Copyright 2012 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut

###########################################################################################

use DBIx::Class;
use Moose;
extends 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("aliases");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "page_id" => {
        data_type     => "integer",
        is_nullable   => 0,
    },
    "url" => {
        data_type     => "text",
        is_nullable   => 0,
    },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    "page",
    "OpusVL::CMS::Schema::Result::Pages",
    { "foreign.id" => "self.page_id" },
);


##
1;
