package OpusVL::CMS::Schema::Result::AttachmentAttributeDetail;
our $VERSION = '28';

use 5.010;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->table('attachment_attribute_details');

__PACKAGE__->add_columns(
    'id' => {
        data_type         => "integer",
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
    "site_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },

);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "field_values",
  "OpusVL::CMS::Schema::Result::AttachmentAttributeValue",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

__PACKAGE__->has_many(
  "values",
  "OpusVL::CMS::Schema::Result::AttachmentAttributeData",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 site

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
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
