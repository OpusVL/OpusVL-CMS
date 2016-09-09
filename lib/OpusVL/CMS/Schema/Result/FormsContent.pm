use utf8;
package OpusVL::CMS::Schema::Result::FormsContent;
our $VERSION = '27';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::FormsContent

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

=head1 TABLE: C<forms_content>

=cut

__PACKAGE__->table("forms_content");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'forms_content_id_seq'

=head2 content

  data_type: 'text'
  is_nullable: 0

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
    sequence          => "forms_content_id_seq",
  },
  "content",
  { data_type => "text", is_nullable => 0 },
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

Related object: L<OpusVL::CMS::Schema::Result::FormsField>

=cut

__PACKAGE__->belongs_to(
  "field",
  "OpusVL::CMS::Schema::Result::FormsField",
  { id => "field_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-12-19 11:14:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nrQsD5y495/tAvX4OUwMew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
