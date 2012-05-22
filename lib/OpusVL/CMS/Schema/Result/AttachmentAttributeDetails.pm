package OpusVL::CMS::Schema::Result::AttachmentAttributeDetails;

use 5.010;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->table('attachment_attribute_details');

__PACKAGE__->add_columns(
    'id' => {
        data_type         => "serial",
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    'code' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    'name' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    'type' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    active => {
        data_type => 'boolean',
        is_nullable => 0,
        default_value => 1,
    },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "field_values",
  "OpusVL::CMS::Schema::Result::AttachmentAttributeValues",
  { "foreign.field_id" => "self.id" },
);

__PACKAGE__->has_many(
  "values",
  "OpusVL::CMS::Schema::Result::AttachmentAttributeData",
  { "foreign.field_id" => "self.id" },
);

sub form_options
{
    my $self = shift;
    my @all = map { [ $_->value, $_->value ] } $self->field_values->all;
    return \@all;
}

sub valid_option
{
    my $self = shift;
    my $value = shift;
    return $self->field_values->find({ value => $value });
}

__PACKAGE__->meta->make_immutable();

1;
