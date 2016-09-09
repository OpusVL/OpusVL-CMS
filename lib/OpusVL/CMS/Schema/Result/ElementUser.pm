use utf8;
package OpusVL::CMS::Schema::Result::ElementUser;
our $VERSION = '27';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::ElementUser

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

=head1 TABLE: C<element_users>

=cut

__PACKAGE__->table("element_users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'element_users_id_seq'

=head2 element_idid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 user_idid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "element_users_id_seq",
  },
  "element_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 element_idid

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Element>

=cut

__PACKAGE__->belongs_to(
  "element",
  "OpusVL::CMS::Schema::Result::Element",
  { id => "element_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 user_idid

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "OpusVL::CMS::Schema::Result::User",
  { id => "user_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-10-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lrbMt4Rog95rg2wHWINr6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
