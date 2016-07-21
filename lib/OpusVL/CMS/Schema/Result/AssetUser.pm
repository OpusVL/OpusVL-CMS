use utf8;
package OpusVL::CMS::Schema::Result::AssetUser;
our $VERSION = '17';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::AssetUser

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

=head1 TABLE: C<asset_users>

=cut

__PACKAGE__->table("asset_users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'asset_users_id_seq'

=head2 asset_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

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
    sequence          => "asset_users_id_seq",
  },
  "asset_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 asset

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Asset>

=cut

__PACKAGE__->belongs_to(
  "asset",
  "OpusVL::CMS::Schema::Result::Asset",
  { id => "asset_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "OpusVL::CMS::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-10-24 15:04:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GE4tN7l8KMK7DkQ1s71IvQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
