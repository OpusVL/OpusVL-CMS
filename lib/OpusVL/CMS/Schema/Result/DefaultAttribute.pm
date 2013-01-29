use utf8;
package OpusVL::CMS::Schema::Result::DefaultAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::DefaultAttribute

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

=head1 TABLE: C<default_attributes>

=cut

__PACKAGE__->table("default_attributes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'default_attributes_id_seq'

=head2 code

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 name

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 value

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 type

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 field_type

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "default_attributes_id_seq",
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
  "value",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "type",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "field_type",
  {
    data_type   => "text",
    is_nullable => 1,
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

=head2 default_attribute_values

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::DefaultAttributeValue>

=cut

__PACKAGE__->has_many(
  "values",
  "OpusVL::CMS::Schema::Result::DefaultAttributeValue",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2013-01-29 14:43:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rBa505qLqPQIK61SWlUCrQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
