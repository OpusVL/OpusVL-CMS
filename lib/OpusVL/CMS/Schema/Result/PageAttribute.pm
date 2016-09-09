use utf8;
package OpusVL::CMS::Schema::Result::PageAttribute;

=head1 NAME

OpusVL::CMS::Schema::Result::PageAttribute

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
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");
=head1 TABLE: C<page_attributes>

=cut

__PACKAGE__->table("page_attributes");
__PACKAGE__->result_source_instance->view_definition('
    select field.code, vals.value, field.site_id, page_id
    from page_attribute_data vals
    inner join page_attribute_details field
    on field.id = vals.field_id
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
  "code",
  { data_type => "text", is_nullable => 1 },
  "value",
  { data_type => "text", is_nullable => 1 },
  "site_id",
  { data_type => "integer", is_nullable => 1 },
  "page_id",
  { data_type => "integer", is_nullable => 1 },
);


1;
