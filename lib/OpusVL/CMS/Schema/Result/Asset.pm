use utf8;
package OpusVL::CMS::Schema::Result::Asset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Asset

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

=head1 TABLE: C<assets>

=cut

__PACKAGE__->table("assets");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'assets_id_seq'

=head2 status

  data_type: 'text'
  default_value: 'published'
  is_nullable: 0

=head2 filename

  data_type: 'text'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 mime_type

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
    sequence          => "assets_id_seq",
  },
  "status",
  { data_type => "text", default_value => "published", is_nullable => 0 },
  "filename",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "mime_type",
  { data_type => "text", is_nullable => 0 },
  "site",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "global",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 asset_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AssetData>

=cut

__PACKAGE__->has_many(
  "asset_datas",
  "OpusVL::CMS::Schema::Result::AssetData",
  { "foreign.asset_id" => "self.id" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:civfYlahwBqBDSi3bGCXdg

sub content {
    my $self = shift;

    return $self->search_related( 'asset_datas', {}, { order_by => { -desc => 'created' } } )->first->data;
}

sub available {
    my $self = shift;
    return $self->search({
        -or => [
            status => 'published',
            global => 1,
        ],
    });
}

sub set_content {
    my ($self, $content) = @_;

    if ($content) {
        $self->create_related('asset_datas', {data => $content});
    }
}

sub publish {
    my $self = shift;

    $self->update({status => 'published'});
}

sub remove {
    my $self = shift;

    $self->update({status => 'deleted'});
}


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
