use utf8;
package OpusVL::CMS::Schema::Result::AssetAttributeValue;
our $VERSION = '23';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::AssetAttributeValue

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

=head1 TABLE: C<asset_attribute_values>

=cut

__PACKAGE__->table("asset_attribute_values");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'asset_attribute_values_id_seq'

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
    sequence          => "asset_attribute_values_id_seq",
  },
  "value",
  { data_type => "text", is_nullable => 1 },
  "field_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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

Related object: L<OpusVL::CMS::Schema::Result::AssetAttributeDetail>

=cut

__PACKAGE__->belongs_to(
  "field",
  "OpusVL::CMS::Schema::Result::AssetAttributeDetail",
  { id => "field_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2013-01-08 10:30:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9Cbm3TG1NWHQfhA7XzmDFg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
