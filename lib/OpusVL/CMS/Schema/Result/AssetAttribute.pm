use utf8;
package OpusVL::CMS::Schema::Result::AssetAttribute;

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 DESCRIPTION

This is a view that combines asset_attribute_data and asset_attribute details to
produce a single resultset of all available asset attributes and their values per
asset, if set.

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<asset_attributes>

=cut

__PACKAGE__->table("asset_attributes");
__PACKAGE__->result_source_instance->view_definition("
    select field.id as field_id, field.code as code, 
        case when type = 'date' then vals.date_value::varchar else vals.value end as value, 
            asset_id as asset_id, field.site_id as site_id, type
    from asset_attribute_details field
    left outer join asset_attribute_data vals
    on field.id = vals.field_id
    where field.active = true
");


=head1 ACCESSORS

=head2 field_id

  data_type: 'integer'
  is_nullable: 1

=head2 code

  data_type: 'text'
  is_nullable: 1

=head2 value

  data_type: 'text'
  is_nullable: 1

=head2 site_id

  data_type: 'integer'
  is_nullable: 1

=head2 asset_id

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
  "asset_id",
  { data_type => "integer", is_nullable => 1 },
  "site_id",
  { data_type => "integer", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
);

__PACKAGE__->belongs_to( site => 'OpusVL::CMS::Schema::Result::Site', 'site_id' );

__PACKAGE__->has_many( options => 'OpusVL::CMS::Schema::Result:AssetAttributeValue',
    { 'foreign.field_id' => 'self.field_id' }
);

1;
