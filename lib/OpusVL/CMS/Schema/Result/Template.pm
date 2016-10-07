use utf8;
package OpusVL::CMS::Schema::Result::Template;
our $VERSION = '33';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Template

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

=head1 TABLE: C<templates>

=cut

__PACKAGE__->table("templates");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'templates_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 site

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
    sequence          => "templates_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "site",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 pages

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Page>

=cut

__PACKAGE__->has_many(
  "pages",
  "OpusVL::CMS::Schema::Result::Page",
  { "foreign.template_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 site

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 template_contents

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::TemplateContent>

=cut

__PACKAGE__->has_many(
  "template_contents",
  "OpusVL::CMS::Schema::Result::TemplateContent",
  { "foreign.template_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

__PACKAGE__->add_unique_constraint([ 'name', 'site' ]);

sub content {
    my $self = shift;

    return $self->search_related( 'template_contents', { }, { order_by => { -desc => 'created' }, rows => 1 } )->first->data;
}

sub set_content {
    my ($self, $content) = @_;

    $self->create_related('template_contents', {data => $content});
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
