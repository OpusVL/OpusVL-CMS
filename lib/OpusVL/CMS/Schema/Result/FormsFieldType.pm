use utf8;
package OpusVL::CMS::Schema::Result::FormsFieldType;
our $VERSION = '47';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::FormsFieldType

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

=head1 TABLE: C<forms_field_type>

=cut

__PACKAGE__->table("forms_field_type");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'forms_field_type_id_seq'

=head2 type

  data_type: 'enum'
  default_value: 'Text'
  extra: {custom_type_name => "field_type",list => ["Text","Textarea","Select","Checkbox","Submit"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "forms_field_type_id_seq",
  },
  "type",
  {
    data_type => "enum",
    default_value => "Text",
    extra => {
      custom_type_name => "field_type",
      list => ["Text", "Textarea", "Select", "Checkbox", "Submit"],
    },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 forms_fields

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::FormsField>

=cut

__PACKAGE__->has_many(
  "forms_fields",
  "OpusVL::CMS::Schema::Result::FormsField",
  { "foreign.type" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-12-19 15:05:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ksUosTIfH2AWwKydXNygOw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
