use utf8;
package OpusVL::CMS::Schema::Result::PageAttributeValue;
our $VERSION = '27';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::PageAttributeValue

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

=head1 TABLE: C<page_attribute_values>

=cut

__PACKAGE__->table("page_attribute_values");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'page_attribute_values_id_seq'

=head2 value

  data_type: 'text'
  is_nullable: 1

=head2 field_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    "id",
    {
        data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
        sequence          => "page_attribute_values_id_seq",
    },
    "value",
    { data_type => "text", is_nullable => 1 },
    "field_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
    # A field's value can be defined by the profile, or by a site that consumes
    # that profile. We don't let the site edit the profile's fields.
    site_id => {
        data_type => "integer",
        is_foreign_key => 1,
        is_nullable => 1
    },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 field

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::PageAttributeDetail>

=cut

__PACKAGE__->belongs_to(
  "field",
  "OpusVL::CMS::Schema::Result::PageAttributeDetail",
  { id => "field_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 site

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
