use utf8;
package OpusVL::CMS::Schema::Result::Parameter;
our $VERSION = '66';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Parameter

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

=head1 TABLE: C<parameter>

=cut

__PACKAGE__->table("parameter");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'parameter_id_seq'

=head2 data_type

  data_type: 'text'
  is_nullable: 0

=head2 parameter

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "parameter_id_seq",
  },
  "data_type",
  { data_type => "text", is_nullable => 0 },
  "parameter",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 parameter_defaults

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::ParameterDefault>

=cut

__PACKAGE__->has_many(
  "parameter_defaults",
  "OpusVL::CMS::Schema::Result::ParameterDefault",
  { "foreign.parameter_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_parameters

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::UsersParameter>

=cut

__PACKAGE__->has_many(
  "users_parameters",
  "OpusVL::CMS::Schema::Result::UsersParameter",
  { "foreign.parameter_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:B85SGXBJyUv+TsuYx0o4Yg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
