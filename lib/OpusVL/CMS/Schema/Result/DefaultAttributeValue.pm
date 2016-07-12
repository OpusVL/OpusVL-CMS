use utf8;
package OpusVL::CMS::Schema::Result::DefaultAttributeValue;
our $VERSION = '2';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::DefaultAttributeValue

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

=head1 TABLE: C<default_attribute_values>

=cut

__PACKAGE__->table("default_attribute_values");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'default_attribute_values_id_seq'

=head2 field_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 value

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "default_attribute_values_id_seq",
  },
  "field_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "value",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
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

Related object: L<OpusVL::CMS::Schema::Result::DefaultAttribute>

=cut

__PACKAGE__->belongs_to(
  "field",
  "OpusVL::CMS::Schema::Result::DefaultAttribute",
  { id => "field_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2013-01-29 14:43:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mv4b2TaeO2iDd2U6nVXCxw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
