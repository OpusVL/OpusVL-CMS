use utf8;
package OpusVL::CMS::Schema::Result::Aclrule;
our $VERSION = '31';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Aclrule

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

=head1 TABLE: C<aclrule>

=cut

__PACKAGE__->table("aclrule");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'aclrule_id_seq'

=head2 actionpath

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "aclrule_id_seq",
  },
  "actionpath",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 aclrule_roles

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AclruleRole>

=cut

__PACKAGE__->has_many(
  "aclrule_roles",
  "OpusVL::CMS::Schema::Result::AclruleRole",
  { "foreign.aclrule_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</aclrule_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "aclrule_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3hqEvTGdKwN4mnPntr1fUA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
