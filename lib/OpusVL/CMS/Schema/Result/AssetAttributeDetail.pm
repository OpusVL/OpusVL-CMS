use utf8;
package OpusVL::CMS::Schema::Result::AssetAttributeDetail;
our $VERSION = '63';

=head1 NAME

OpusVL::CMS::Schema::Result::AssetAttributeDetail

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<asset_attribute_details>

=cut

__PACKAGE__->table("asset_attribute_details");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'asset_attribute_details_id_seq'

=head2 code

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 name

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 type

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 site_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "asset_attribute_details_id_seq",
  },
  "code",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "name",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "type",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "site_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 asset_attribute_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AssetAttributeData>

=cut

__PACKAGE__->has_many(
  "values",
  "OpusVL::CMS::Schema::Result::AssetAttributeData",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 asset_attribute_values

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AssetAttributeValue>

=cut

__PACKAGE__->has_many(
  "field_values",
  "OpusVL::CMS::Schema::Result::AssetAttributeValue",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
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
    my @all = sort { $a->[0] cmp $b->[0] } map { [ $_->value, $_->value ] } $self->field_values->for_site($site);
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

1;
