package OpusVL::CMS::Schema::Result::AttachmentAttributeDetail;
our $VERSION = '60';

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

=head1 METHODS

=head2 form_options

=over

=item $site

Since fields are always defined against profiles, but sites can augment the set
of values, you must pass in the site whose values you want. This will default to
that profile.

=back

Returns an arrayref of arrayrefs for HTML::FormFu usage, for when the field's
type is C<select>

=cut

sub form_options
{
    my $self = shift;
    my $site = shift // $self->site;
    my @all = map { [ $_->value, $_->value ] } $self->field_values->for_site($site)->all;
    return \@all;
}

=head2 valid_option

=over

=item $value

The value to check

=item $site

Since fields are always defined against profiles, but sites can augment the set
of values, you must pass in the site whose values you want. This will default to
that profile.

=back

Returns a true value if the input value exists in the provided site's set of
options for this C<select> field. If it's not a C<select> field, this is false,
because no options are defined.

=cut

sub valid_option
{
    my $self = shift;
    my $value = shift;
    my $site = shift // $self->site;
    return $self->field_values->for_site($site)->find({ value => $value });
}

__PACKAGE__->meta->make_immutable();

1;
