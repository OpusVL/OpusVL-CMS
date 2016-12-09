use utf8;
package OpusVL::CMS::Schema::Result::AlternateDomain;
our $VERSION = '47';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::AlternateDomain

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

=head1 TABLE: C<alternate_domains>

=cut

__PACKAGE__->table("alternate_domains");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'alternate_domains_id_seq'

=head2 port

  data_type: 'integer'
  default_value: 80
  is_nullable: 0

=head2 secure

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 domain

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
    sequence          => "alternate_domains_id_seq",
  },
  "port",
  { data_type => "integer", default_value => 80, is_nullable => 0 },
  "secure",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "master_domain",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "domain",
  { data_type => "varchar", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 domain

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::MasterDomain>

=cut

__PACKAGE__->belongs_to(
  "master_domain",
  "OpusVL::CMS::Schema::Result::MasterDomain",
  { id => "master_domain" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lgkqF/+4LJKVtNmHmzbQrg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
