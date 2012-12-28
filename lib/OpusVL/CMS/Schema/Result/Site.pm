use utf8;
package OpusVL::CMS::Schema::Result::Site;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Site

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

=head1 TABLE: C<sites>

=cut

__PACKAGE__->table("sites");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'sites_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 140

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "sites_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 140 },
  "status",
  {
    data_type     => "text",
    default_value => "active",
    is_nullable   => 0,
    original      => { data_type => "varchar" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 assets

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Asset>

=cut

__PACKAGE__->has_many(
  "assets",
  "OpusVL::CMS::Schema::Result::Asset",
  { "foreign.site" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 elements

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Element>

=cut

__PACKAGE__->has_many(
  "elements",
  "OpusVL::CMS::Schema::Result::Element",
  { "foreign.site" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 master_domains

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::MasterDomain>

=cut

=head2 forms

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Form>

=cut

__PACKAGE__->has_many(
  "forms",
  "OpusVL::CMS::Schema::Result::Form",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->has_many(
  "master_domains",
  "OpusVL::CMS::Schema::Result::MasterDomain",
  { "foreign.site" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sites_users

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::SitesUser>

=cut

__PACKAGE__->has_many(
  "sites_users",
  "OpusVL::CMS::Schema::Result::SitesUser",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 templates

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Template>

=cut

__PACKAGE__->has_many(
  "templates",
  "OpusVL::CMS::Schema::Result::Template",
  { "foreign.site" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 site_attributes

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::SiteAttribute>

=cut

__PACKAGE__->has_many(
  "site_attributes",
  "OpusVL::CMS::Schema::Result::SiteAttribute",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pages

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Page>

=cut

__PACKAGE__->has_many(
  "pages",
  "OpusVL::CMS::Schema::Result::Page",
  { "foreign.site" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cFs5vMHOaxkMtvUEiz51dQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
