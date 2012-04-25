package OpusVL::CMS::Schema::Result::PageContents;

=head1 NAME

OpusVL::CMS::Schema::Result::PageContents -

=head1 DESCRIPTION

Schema configuration of the PageContents in the SimpleCMS

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
__PACKAGE__->table("page_contents");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "page_id" => {
        data_type     => "integer",
        default_value => undef,
        is_nullable   => 0,
    },
    "status" => {
        data_type     => "text",
        default_value => "Published",
        is_nullable   => 0,
    },
    "body" => {
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
    "page",
    "OpusVL::CMS::Schema::Result::Pages",
    { "foreign.id" => "self.page_id" },
);


## 
1;
