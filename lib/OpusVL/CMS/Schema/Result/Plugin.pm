use utf8;
package OpusVL::CMS::Schema::Result::Plugin;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Plugin

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

=head1 TABLE: C<plugins>

=cut

__PACKAGE__->table("plugins");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'plugins_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 action

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 code

  data_type: 'text'
  is_nullable: 0

=head2 author

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 description

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 status

  data_type: 'text'
  default_value: 'disabled'
  is_nullable: 0
  original: {data_type => "varchar"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "plugins_id_seq",
  },
  "name",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "action",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "code",
  { data_type => "text", is_nullable => 0 },
  "author",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "description",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "status",
  {
    data_type     => "text",
    default_value => "disabled",
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


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-11-27 12:22:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tmx7KIafXKZIOHxftOneCA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
