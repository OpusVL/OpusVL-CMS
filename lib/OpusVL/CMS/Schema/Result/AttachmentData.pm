package OpusVL::CMS::Schema::Result::AttachmentData;

=head1 NAME

OpusVL::CMS::Schema::Result::Attachments -

=head1 DESCRIPTION

Schema configuration of the Attachments in the SimpleCMS

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

__PACKAGE__->load_components("Core");
__PACKAGE__->table("attachment_data");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "att_id" => {
        data_type   => "integer",
        is_nullable => 0,
    },
    "data" => {
        data_type   => "bytea",
        is_nullable => 0,
    },
    "created" => {
        data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    "attachment",
    "OpusVL::CMS::Schema::Result::Attachments",
    { 'foreign.id' => 'self.att_id' },
    { cascade_delete => 0 },
);

##
1;
