use utf8;
package OpusVL::CMS::Schema::Result::FormsConstraint;
our $VERSION = '33';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::FormsConstraint

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

=head1 TABLE: C<forms_constraints>

=cut

__PACKAGE__->table("forms_constraints");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'forms_constraints_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 type

  data_type: 'text'
  default_value: 'Required'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 value

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
    sequence          => "forms_constraints_id_seq",
  },
  "name",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "type",
  {
    data_type     => "text",
    default_value => "Required",
    is_nullable   => 0,
    original      => { data_type => "varchar" },
  },
  "value",
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

=head2 forms_fields_constraints

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::FormsFieldsConstraint>

=cut

__PACKAGE__->has_many(
  "forms_fields_constraints",
  "OpusVL::CMS::Schema::Result::FormsFieldsConstraint",
  { "foreign.constraint_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-12-27 12:28:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sZZ3Ju1KzEQ6wLXZJ9wuqA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
