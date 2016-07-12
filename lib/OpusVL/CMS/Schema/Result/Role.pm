use utf8;
package OpusVL::CMS::Schema::Result::Role;
our $VERSION="1";

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Role

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

=head1 TABLE: C<role>

=cut

__PACKAGE__->table("role");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'role_id_seq'

=head2 role

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "role_id_seq",
  },
  "role",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 aclfeature_roles

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AclfeatureRole>

=cut

__PACKAGE__->has_many(
  "aclfeature_roles",
  "OpusVL::CMS::Schema::Result::AclfeatureRole",
  { "foreign.role_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 aclrule_roles

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AclruleRole>

=cut

__PACKAGE__->has_many(
  "aclrule_roles",
  "OpusVL::CMS::Schema::Result::AclruleRole",
  { "foreign.role_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role_admin

Type: might_have

Related object: L<OpusVL::CMS::Schema::Result::RoleAdmin>

=cut

__PACKAGE__->might_have(
  "role_admin",
  "OpusVL::CMS::Schema::Result::RoleAdmin",
  { "foreign.role_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles_allowed_roles

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::RoleAllowed>

=cut

__PACKAGE__->has_many(
  "roles_allowed_roles",
  "OpusVL::CMS::Schema::Result::RoleAllowed",
  { "foreign.role" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles_allowed_roles_allowed

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::RoleAllowed>

=cut

__PACKAGE__->has_many(
  "roles_allowed_roles_allowed",
  "OpusVL::CMS::Schema::Result::RoleAllowed",
  { "foreign.role_allowed" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_roles

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::UsersRole>

=cut

__PACKAGE__->has_many(
  "users_roles",
  "OpusVL::CMS::Schema::Result::UsersRole",
  { "foreign.role_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 aclfeatures

Type: many_to_many

Composing rels: L</aclfeature_roles> -> aclfeature

=cut

__PACKAGE__->many_to_many("aclfeatures", "aclfeature_roles", "aclfeature");

=head2 aclrules

Type: many_to_many

Composing rels: L</aclrule_roles> -> aclrule

=cut

__PACKAGE__->many_to_many("aclrules", "aclrule_roles", "aclrule");

=head2 roles

Type: many_to_many

Composing rels: L</roles_allowed_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "roles_allowed_roles", "role");

=head2 roles_allowed

Type: many_to_many

Composing rels: L</roles_allowed_roles> -> role_allowed

=cut

__PACKAGE__->many_to_many("roles_allowed", "roles_allowed_roles", "role_allowed");

=head2 users

Type: many_to_many

Composing rels: L</users_roles> -> user

=cut

__PACKAGE__->many_to_many("users", "users_roles", "user");


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ogRRHk1c3X35k68az0WK4Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
