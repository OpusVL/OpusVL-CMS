use utf8;
package OpusVL::CMS::Schema::Result::Page;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Page

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

=head1 TABLE: C<pages>

=cut

__PACKAGE__->table("pages");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'pages_id_seq'

=head2 url

  data_type: 'text'
  is_nullable: 0

=head2 status

  data_type: 'text'
  default_value: 'published'
  is_nullable: 0

=head2 parent_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 template_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 h1

  data_type: 'text'
  is_nullable: 1

=head2 breadcrumb

  data_type: 'text'
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 priority

  data_type: 'integer'
  default_value: 50
  is_nullable: 0

=head2 created

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 updated

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "pages_id_seq",
  },
  "url",
  { data_type => "text", is_nullable => 0 },
  "status",
  { data_type => "text", default_value => "published", is_nullable => 0 },
  "parent_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "template_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "h1",
  { data_type => "text", is_nullable => 1 },
  "breadcrumb",
  { data_type => "text", is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "priority",
  { data_type => "integer", default_value => 50, is_nullable => 0 },
  "created",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "updated",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 aliases

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Alias>

=cut

__PACKAGE__->has_many(
  "aliases",
  "OpusVL::CMS::Schema::Result::Alias",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 attachments

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Attachment>

=cut

__PACKAGE__->has_many(
  "attachments",
  "OpusVL::CMS::Schema::Result::Attachment",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 page_attribute_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageAttributeData>

=cut

__PACKAGE__->has_many(
  "page_attribute_datas",
  "OpusVL::CMS::Schema::Result::PageAttributeData",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 page_contents

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageContent>

=cut

__PACKAGE__->has_many(
  "page_contents",
  "OpusVL::CMS::Schema::Result::PageContent",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 page_tags

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageTag>

=cut

__PACKAGE__->has_many(
  "page_tags",
  "OpusVL::CMS::Schema::Result::PageTag",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pages

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Page>

=cut

__PACKAGE__->has_many(
  "pages",
  "OpusVL::CMS::Schema::Result::Page",
  { "foreign.parent_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Page>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "OpusVL::CMS::Schema::Result::Page",
  { id => "parent_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 template

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Template>

=cut

__PACKAGE__->belongs_to(
  "template",
  "OpusVL::CMS::Schema::Result::Template",
  { id => "template_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6YoYkiRXCQN+clv2uac/Wg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
