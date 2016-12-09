use utf8;
package OpusVL::CMS::Schema::Result::PageContent;
our $VERSION = '47';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::PageContent

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

=head1 TABLE: C<page_contents>

=cut

__PACKAGE__->table("page_contents");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'page_contents_id_seq'

=head2 page_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 status

  data_type: 'text'
  default_value: 'Published'
  is_nullable: 0

=head2 body

  data_type: 'text'
  is_nullable: 0

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
    sequence          => "page_contents_id_seq",
  },
  "page_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "status",
  { data_type => "text", default_value => "Published", is_nullable => 0 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "created",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
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


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:j1EPkcO0pfZAT7j7UCMxgQ

sub title {
    my $self = shift;
    return $self->page->title;
}

sub set_title {
    my ($self, $title) = shift;
    my $row = $self->first;
    $row->update({ title => $title });
}

sub url {
    my $self = shift;
    return $self->page->url;
}

sub set_url {
    my ($self, $url) = shift;
    my $row = $self->first;
    $row->update({ url => $url });
}

sub breadcrumb {
    my $self = shift;
    return $self->page->breadcrumb;
}

sub set_breadcrumb {
    my ($self, $breadcrumb) = shift;
    my $row = $self->first;
    $row->update({ breadcrumb => $breadcrumb });
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
