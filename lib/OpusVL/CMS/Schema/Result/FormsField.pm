use utf8;
package OpusVL::CMS::Schema::Result::FormsField;
our $VERSION = '34';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::FormsField

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

=head1 TABLE: C<forms_fields>

=cut

__PACKAGE__->table("forms_fields");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'forms_fields_id_seq'

=head2 form_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 label

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 priority

  data_type: 'integer'
  default_value: 10
  is_nullable: 0

=head2 type

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
    sequence          => "forms_fields_id_seq",
  },
  "form_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "label",
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
  "priority",
  { data_type => "integer", default_value => 10, is_nullable => 0 },
  "type",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "fields",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 form

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Form>

=cut

__PACKAGE__->belongs_to(
  "form",
  "OpusVL::CMS::Schema::Result::Form",
  { id => "form_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 forms_contents

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::FormsContent>

=cut

__PACKAGE__->has_many(
  "forms_contents",
  "OpusVL::CMS::Schema::Result::FormsContent",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 type

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::FormsFieldType>

=cut

__PACKAGE__->belongs_to(
  "type",
  "OpusVL::CMS::Schema::Result::FormsFieldType",
  { id => "type" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 forms_fields_constraints

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::FormsFieldsConstraint>

=cut

__PACKAGE__->has_many(
  "forms_fields_constraints",
  "OpusVL::CMS::Schema::Result::FormsFieldsConstraint",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-12-19 14:22:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GdE9MI60Nx5X+GGMB6yE/w

=head2 content

Convenience method to get the content of a field

=cut

sub content {
    my $self = shift;
    return $self->forms_contents->first;
}

sub constraint {
    my $self = shift;
    return $self->forms_fields_constraints->first;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
