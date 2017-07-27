use utf8;
package OpusVL::CMS::Schema::Result::User;
our $VERSION = '65';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::User

=cut

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'users_id_seq'

=head2 username

  data_type: 'text'
  is_nullable: 0

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 email

  data_type: 'text'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 tel

  data_type: 'text'
  is_nullable: 0

=head2 status

  data_type: 'text'
  default_value: 'active'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "users_id_seq",
  },
  "username",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "email",
  { data_type => "text", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "tel",
  { data_type => "text", is_nullable => 1 },
  "status",
  { data_type => "text", default_value => "active", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<user_index>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("user_index", ["username"]);

=head1 RELATIONS

=head2 asset_users

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AssetUser>

=cut

__PACKAGE__->has_many(
  "asset_users",
  "OpusVL::CMS::Schema::Result::AssetUser",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 page_users

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageUser>

=cut

__PACKAGE__->has_many(
  "page_users",
  "OpusVL::CMS::Schema::Result::PageUser",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 element_users

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::ElementUser>

=cut

__PACKAGE__->has_many(
  "element_users",
  "OpusVL::CMS::Schema::Result::ElementUser",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 page_drafts

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageDraft>

=cut

__PACKAGE__->has_many(
  "page_drafts",
  "OpusVL::CMS::Schema::Result::PageDraft",
  { "foreign.created_by" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sites_users

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::SitesUser>

=cut

__PACKAGE__->has_many(
  "sites_users",
  "OpusVL::CMS::Schema::Result::SitesUser",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::UsersData>

=cut

__PACKAGE__->has_many(
  "users_datas",
  "OpusVL::CMS::Schema::Result::UsersData",
  { "foreign.users_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_parameters

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::UsersParameter>

=cut

__PACKAGE__->has_many(
  "users_parameters",
  "OpusVL::CMS::Schema::Result::UsersParameter",
  { "foreign.users_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_roles

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::UsersRole>

=cut

__PACKAGE__->has_many(
  "users_roles",
  "OpusVL::CMS::Schema::Result::UsersRole",
  { "foreign.users_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</users_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "users_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pNhqdR//Ryae51urmuwbZw

sub sites {
    my $self   = shift;
    my $schema = $self->result_source->schema;

    my $sites  = $self->sites_users;
}

sub can_edit_page {
    my ($self, $page_id) = @_;
    return 1;
    my $schema = $self->result_source->schema;
    my $page_users = $schema->resultset('PageUser');
    #die "Searching for " . $self->id . " and $page_id in page_users";
    if (my $userpage = $page_users->find({ user_id => $self->id, page_id => $page_id })) {
        return 1;
    }

    return 0;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
