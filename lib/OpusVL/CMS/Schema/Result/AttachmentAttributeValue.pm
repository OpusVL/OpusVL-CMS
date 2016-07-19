package OpusVL::CMS::Schema::Result::AttachmentAttributeValue;
our $VERSION = '14';

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
        data_type   => 'text',
        is_nullable => 1,
        default_value => 50,
    },
    'field_id' => {
        data_type => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    'field' => 'OpusVL::CMS::Schema::Result::AttachmentAttributeDetail',
    { 'foreign.id' => 'self.field_id' },
);

__PACKAGE__->meta->make_immutable();


1;

