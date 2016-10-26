use utf8;
package OpusVL::CMS::Schema::Result::ParameterDefault;
our $VERSION = '42';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::ParameterDefault

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

=head1 TABLE: C<parameter_defaults>

=cut

__PACKAGE__->table("parameter_defaults");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'parameter_defaults_id_seq'

=head2 parameter_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 data

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "parameter_defaults_id_seq",
  },
  "parameter_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "data",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 parameter

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Parameter>

=cut

__PACKAGE__->belongs_to(
  "parameter",
  "OpusVL::CMS::Schema::Result::Parameter",
  { id => "parameter_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZHCw7e8K4YPekmPlXvW6+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
