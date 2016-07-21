use utf8;
package OpusVL::CMS::Schema::Result::PageAttributeDetail;
our $VERSION = '17';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::PageAttributeDetail

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

=head1 TABLE: C<page_attribute_details>

=cut

__PACKAGE__->table("page_attribute_details");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'page_attribute_details_id_seq'

=head2 code

  data_type: 'text'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 cascade

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "page_attribute_details_id_seq",
  },
  "code",
  { data_type => "text", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "cascade",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "site_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },

);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 page_attribute_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageAttributeData>

=cut

__PACKAGE__->has_many(
  "values",
  "OpusVL::CMS::Schema::Result::PageAttributeData",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 page_attribute_values

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageAttributeValue>

=cut

__PACKAGE__->has_many(
  "field_values",
  "OpusVL::CMS::Schema::Result::PageAttributeValue",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 site

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AfWP+iCIWZWJN5TLhXXwug


sub form_options
{
    my $self = shift;
    my @all = map { [ $_->value, $_->value ] } $self->field_values->all;
    return \@all;
}

sub valid_option
{
    my $self = shift;
    my $value = shift;
    return $self->field_values->find({ value => $value });
}

sub active
{
    my $self = shift;
    return $self->search({ active => 1 });
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
