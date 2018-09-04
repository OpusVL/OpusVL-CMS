package OpusVL::CMS::Schema::Result::AttachmentAttributeValue;
our $VERSION = '68';

use 5.010;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->table('attachment_attribute_values');

__PACKAGE__->add_columns(
    'id' => {
        data_type         => "serial",
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    'value' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    priority => {
        data_type   => 'integer',
        is_nullable => 1,
        default_value => 50,
    },
    'field_id' => {
        data_type => 'integer',
        is_nullable => 0,
    },
    # A field's value can be defined by the profile, or by a site that consumes
    # that profile. We don't let the site edit the profile's fields.
    site_id => {
        data_type => "integer",
        is_foreign_key => 1,
        is_nullable => 1
    },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    'field' => 'OpusVL::CMS::Schema::Result::AttachmentAttributeDetail',
    { 'foreign.id' => 'self.field_id' },
);

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


__PACKAGE__->meta->make_immutable();


1;

