use utf8;
package OpusVL::CMS::Schema::Result::RoleAdmin;
our $VERSION = '68';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::RoleAdmin

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

=head1 TABLE: C<role_admin>

=cut

__PACKAGE__->table("role_admin");

=head1 ACCESSORS

=head2 role_id

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0
  sequence: 'role_admin_role_id_seq'

=cut

__PACKAGE__->add_columns(
  "role_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
    sequence          => "role_admin_role_id_seq",
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_id>

=back

=cut

__PACKAGE__->set_primary_key("role_id");

=head1 RELATIONS

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TGKg/OCXSAaJIIj/h5PORg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
