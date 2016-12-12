use utf8;
package OpusVL::CMS::Schema::Result::PageAttribute;

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 NAME

OpusVL::CMS::Schema::Result::PageAttribute

=head1 DESCRIPTION

This is a view that combines page_attribute_data and page_attribute details to
produce a single resultset of all available page attributes and their values per
page, if set.

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<page_attributes>

=cut

__PACKAGE__->table("page_attributes");
__PACKAGE__->result_source_instance->view_definition('
    select field.id as field_id, field.code, vals.value, page_id, field.site_id
    from page_attribute_data vals
    left join page_attribute_details field
    on field.id = vals.field_id
    left join page_attribute_values opts
    on field.id = opts.field_id
    where field.active
');


=head1 ACCESSORS

=head2 code

  data_type: 'text'
  is_nullable: 1

=head2 value

  data_type: 'text'
  is_nullable: 1

=head2 site_id

  data_type: 'integer'
  is_nullable: 1

=head2 page_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "field_id",
  { data_type => "integer" },
  "code",
  { data_type => "text" },
  "value",
  { data_type => "text", is_nullable => 1 },
  "site_id",
  { data_type => "integer", is_nullable => 1 },
  "page_id",
  { data_type => "integer", is_nullable => 1 },
);

__PACKAGE__->belongs_to( site => 'OpusVL::CMS::Schema::Result::Site', 'site_id' );

__PACKAGE__->has_many( options => 'OpusVL::CMS::Schema::Result:PageAttributeValue',
    { 'foreign.field_id' => 'self.field_id' }
);

1;
