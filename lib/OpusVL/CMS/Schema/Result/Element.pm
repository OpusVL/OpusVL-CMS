use utf8;
package OpusVL::CMS::Schema::Result::Element;
our $VERSION = '5';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Element

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

=head1 TABLE: C<elements>

=cut

__PACKAGE__->table("elements");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'elements_id_seq'

=head2 status

  data_type: 'text'
  default_value: 'published'
  is_nullable: 0

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
    sequence          => "elements_id_seq",
  },
  "status",
  { data_type => "text", default_value => "published", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "site",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "slug",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::ElementUser>

=cut

__PACKAGE__->has_many(
  "element_users",
  "OpusVL::CMS::Schema::Result::ElementUser",
  { "foreign.element_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 element_attributes

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::ElementAttribute>

=cut

__PACKAGE__->has_many(
  "element_attributes",
  "OpusVL::CMS::Schema::Result::ElementAttribute",
  { "foreign.element_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 element_contents

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::ElementContent>

=cut

__PACKAGE__->has_many(
  "element_contents",
  "OpusVL::CMS::Schema::Result::ElementContent",
  { "foreign.element_id" => "self.id" },
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


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:B0+YPvqxW3nZfG02IyYOsg


sub content {
    my $self = shift;

    return $self->search_related( 'element_contents', { }, { 
        order_by => { -desc => 'created' },
        rows => 1,
    } )->first->data;
}

sub set_content {
    my ($self, $content) = @_;

    $self->create_related('element_contents', {data => $content});
}

sub publish {
    my $self = shift;

    $self->update({status => 'published'});
}

sub remove {
    my $self = shift;

    $self->update({status => 'deleted'});

    # FIXME: remove all page / template links to the element as well
}

sub tt_get_attributes {
    my $self = shift;
    return [ $self->element_attributes->all ];
}

sub allows_user {
    my ($self, $user_id) = @_;
    if ($self->element_users->find({ user_id => $user_id })) { return 1; }

    return 0;
}

sub is_slug_available {
    my ($self, $slug) = @_;
    return $self->find({ slug => $slug });
}
# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
