package OpusVL::CMS::Schema::Result::PageAttributeData;

use 5.010;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('page_attribute_data');

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
    'date_value' => {
        data_type   => 'date',
        is_nullable => 1,
    },
    'field_id' => {
        data_type => 'integer',
        is_nullable => 0,
    },
    'page_id' => {
        data_type => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
  "field",
  "OpusVL::CMS::Schema::Result::PageAttributeDetails",
  { "foreign.id" => "self.field_id" },
);

__PACKAGE__->belongs_to(
  "page",
  "OpusVL::CMS::Schema::Result::Pages",
  { "foreign.id" => "self.page_id" },
);

__PACKAGE__->meta->make_immutable();

1;

