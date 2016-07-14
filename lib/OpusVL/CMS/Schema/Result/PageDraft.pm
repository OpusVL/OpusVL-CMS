use utf8;
package OpusVL::CMS::Schema::Result::PageDraft;
our $VERSION = '3';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::PageDraft

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

=head1 TABLE: C<page_drafts>

=cut

__PACKAGE__->table("page_drafts");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'page_drafts_id_seq'

=head2 page_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 status

  data_type: 'text'
  default_value: 'draft'
  is_nullable: 0
  original: {data_type => "varchar"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "page_drafts_id_seq",
  },
  "page_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "status",
  {
    data_type     => "text",
    default_value => "draft",
    is_nullable   => 0,
    original      => { data_type => "varchar" },
  },
  "created_by",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 created_by

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "created_by",
  "OpusVL::CMS::Schema::Result::User",
  { id => "created_by" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 page

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Page>

=cut

__PACKAGE__->belongs_to(
  "page",
  "OpusVL::CMS::Schema::Result::Page",
  { id => "page_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 page_drafts_contents

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageDraftsContent>

=cut

__PACKAGE__->has_many(
  "page_drafts_contents",
  "OpusVL::CMS::Schema::Result::PageDraftsContent",
  { "foreign.draft_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-10-09 16:08:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3NJbvnIkW3AAxRDlAIfM/w

sub create_draft {
    my ($self, $content) = @_;
    
    $self->create_related('page_drafts_contents', {
        draft_id => $self->id,
        body     => $content
    });
}

sub content {
    my $self = shift;
 
   return $self->search_related( 'page_drafts_contents', {}, { order_by => { -desc => 'created' }, rows => 1 } )->first->body;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
