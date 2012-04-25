package OpusVL::CMS::Schema::Result::AttachmentTags;

=head1 NAME

OpusVL::CMS::Schema::Result::AttachmentTags -

=head1 DESCRIPTION

Schema configuration of the AttachmentTags in the SimpleCMS

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

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("attachment_tags");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "attachment_id" => {
        data_type     => "integer",
        is_nullable   => 0,
    },
    "tag_id" => {
        data_type     => "integer",
        is_nullable   => 0,
    },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    "tag",
    "OpusVL::CMS::Schema::Result::Tags",
    { "foreign.id" => "self.tag_id" },
);

__PACKAGE__->belongs_to(
    "attachment",
    "OpusVL::CMS::Schema::Result::Attachments",
    { "foreign.id" => "self.attachment_id" },
);


##
1;
