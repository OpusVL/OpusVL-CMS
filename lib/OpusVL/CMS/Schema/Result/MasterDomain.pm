use utf8;
package OpusVL::CMS::Schema::Result::MasterDomain;
our $VERSION = '54';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::MasterDomain

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

=head1 TABLE: C<master_domains>

=cut

__PACKAGE__->table("master_domains");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'master_domains_id_seq'

=head2 domain

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 site

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
    sequence          => "master_domains_id_seq",
  },
  "domain",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "site",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 alternate_domains

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AlternateDomain>

=cut

__PACKAGE__->has_many(
  "alternate_domains",
  "OpusVL::CMS::Schema::Result::AlternateDomain",
  { "foreign.master_domain" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 redirect_domains

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::RedirectDomain>

=cut

__PACKAGE__->has_many(
  "redirect_domains",
  "OpusVL::CMS::Schema::Result::RedirectDomain",
  { "foreign.master_domain" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 site

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:n6U50BZml/R3+h32rpVQiQ

sub alternates {
    my $self   = shift;
    my $schema = $self->result_source->schema;
    return $schema->resultset('AlternateDomain')
        ->search_rs({ master_domain => $self->id });
}

sub redirect {
    my $self   = shift;
    my $schema = $self->result_source->schema;
    my $redirects = $schema->resultset('RedirectDomain')
        ->search({ master_domain => $self->id });
    
    return $redirects->count > 0 ? $redirects->first : 0;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
