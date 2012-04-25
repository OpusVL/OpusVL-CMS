package OpusVL::CMS::Schema::Result::TagGroups;

=head1 NAME

OpusVL::CMS::Schema::Result::TagGroups -

=head1 DESCRIPTION

Schema configuration of the TagGroups in the SimpleCMS

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

OpusVL - Nuria

=head1 COPYRIGHT & LICENSE

Copyright 2009 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut

###########################################################################################

use DBIx::Class;
use Moose;
extends 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("tag_groups");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "name" => {
        data_type   => "text",
        is_nullable => 0,
    },
    "cascade" => {
      data_type     => "boolean",
      default_value => "false",
      is_nullable   => 0,
    },
    "multiple" => {
      data_type     => "boolean",
      default_value => "false",
      is_nullable   => 0,
    },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
    "tags",
    "OpusVL::CMS::Schema::Result::Tags",
    { "foreign.group_id" => "self.id" },
);


##
1;
