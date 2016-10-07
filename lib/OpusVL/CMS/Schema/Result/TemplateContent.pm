use utf8;
package OpusVL::CMS::Schema::Result::TemplateContent;
our $VERSION = '33';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::TemplateContent

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

=head1 TABLE: C<template_contents>

=cut

__PACKAGE__->table("template_contents");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'template_contents_id_seq'

=head2 template_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 data

  data_type: 'text'
  is_nullable: 0

=head2 created

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "template_contents_id_seq",
  },
  "template_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "data",
  { data_type => "text", is_nullable => 0 },
  "created",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 template

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Template>

=cut

__PACKAGE__->belongs_to(
  "template",
  "OpusVL::CMS::Schema::Result::Template",
  { id => "template_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qx02nXUr9n5kEi9FwN5gOg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
