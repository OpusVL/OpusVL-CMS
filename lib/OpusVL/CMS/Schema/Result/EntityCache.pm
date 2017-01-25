package OpusVL::CMS::Schema::Result::EntityCache;

use Moose;
extends 'DBIx::Class::Core';

__PACKAGE__->table("entity_cache");

__PACKAGE__->add_columns(
  hash =>
  {
      data_type => 'varchar',
      is_nullable => 0,
  },
  value => 
  {
      data_type => 'text',
      is_nullable => 0,
  },
  created => 
  {
      data_type => 'timestamp without time zone',
      default_value => \'now()',
      is_nullable => 0,
  },
  site_id => 
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

__PACKAGE__->set_primary_key("hash", "site_id");

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
