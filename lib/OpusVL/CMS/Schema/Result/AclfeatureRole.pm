use utf8;
package OpusVL::CMS::Schema::Result::AclfeatureRole;
our $VERSION = '68';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::AclfeatureRole

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

=head1 TABLE: C<aclfeature_role>

=cut

__PACKAGE__->table("aclfeature_role");

=head1 ACCESSORS

=head2 aclfeature_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "aclfeature_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</aclfeature_id>

=item * L</role_id>

=back

=cut

__PACKAGE__->set_primary_key("aclfeature_id", "role_id");

=head1 RELATIONS

=head2 aclfeature

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Aclfeature>

=cut

__PACKAGE__->belongs_to(
  "aclfeature",
  "OpusVL::CMS::Schema::Result::Aclfeature",
  { id => "aclfeature_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 role

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "OpusVL::CMS::Schema::Result::Role",
  { id => "role_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZGC7jRv8eE2wCZ0ww8XYIQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
