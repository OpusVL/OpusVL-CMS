use utf8;
package OpusVL::CMS::Schema::Result::Tag;
our $VERSION = '64';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Tag

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

=head1 TABLE: C<tags>

=cut

__PACKAGE__->table("tags");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'tags_id_seq'

=head2 group_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "tags_id_seq",
  },
  "group_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 attachment_tags

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AttachmentTag>

=cut

__PACKAGE__->has_many(
  "attachment_tags",
  "OpusVL::CMS::Schema::Result::AttachmentTag",
  { "foreign.tag_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 group

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::TagGroup>

=cut

__PACKAGE__->belongs_to(
  "group",
  "OpusVL::CMS::Schema::Result::TagGroup",
  { id => "group_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 page_tags

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageTag>

=cut

__PACKAGE__->has_many(
  "page_tags",
  "OpusVL::CMS::Schema::Result::PageTag",
  { "foreign.tag_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d5yhvnNwjWzoFQhMGlOwQw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
