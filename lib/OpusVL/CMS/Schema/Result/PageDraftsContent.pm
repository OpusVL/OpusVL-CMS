use utf8;
package OpusVL::CMS::Schema::Result::PageDraftsContent;
our $VERSION = '31';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::PageDraftsContent

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

=head1 TABLE: C<page_drafts_content>

=cut

__PACKAGE__->table("page_drafts_content");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'page_drafts_content_id_seq'

=head2 draft_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 body

  data_type: 'text'
  is_nullable: 1

=head2 created

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
    sequence          => "page_drafts_content_id_seq",
  },
  "draft_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "body",
  { data_type => "text", is_nullable => 1 },
  "created",
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

=head2 draft

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::PageDraft>

=cut

__PACKAGE__->belongs_to(
  "draft",
  "OpusVL::CMS::Schema::Result::PageDraft",
  { id => "draft_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-10-09 16:08:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cVQ3/jqGxEucgDz2rjXFjg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
