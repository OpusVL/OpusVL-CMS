use utf8;
package OpusVL::CMS::Schema::Result::AttachmentTag;
our $VERSION = '6';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::AttachmentTag

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

=head1 TABLE: C<attachment_tags>

=cut

__PACKAGE__->table("attachment_tags");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'attachment_tags_id_seq'

=head2 attachment_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 tag_id

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
    sequence          => "attachment_tags_id_seq",
  },
  "attachment_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tag_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 attachment

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Attachment>

=cut

__PACKAGE__->belongs_to(
  "attachment",
  "OpusVL::CMS::Schema::Result::Attachment",
  { id => "attachment_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 tag

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Tag>

=cut

__PACKAGE__->belongs_to(
  "tag",
  "OpusVL::CMS::Schema::Result::Tag",
  { id => "tag_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ly2xB4QhdEAlTqFIMI4QGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
