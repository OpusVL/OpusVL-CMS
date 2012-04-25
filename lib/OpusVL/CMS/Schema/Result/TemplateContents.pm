package OpusVL::CMS::Schema::Result::TemplateContents;

=head1 NAME

OpusVL::CMS::Schema::Result::TemplateContents -

=head1 DESCRIPTION

Schema configuration of the TemplateContents in the SimpleCMS

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

OpusVL - Nuria

=head1 COPYRIGHT & LICENSE

Copyright 2009 OpusVL

This sofware is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut

###########################################################################################


use DBIx::Class;
use Moose;
extends 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("template_contents");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "template_id" => {
        data_type     => "integer",
        default_value => undef,
        is_nullable   => 0,
    },
    "data" => {
        data_type   => "text",
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
    "template",
    "OpusVL::CMS::Schema::Result::Templates",
    { "foreign.id" => "self.template_id" },
);


## 
1;
