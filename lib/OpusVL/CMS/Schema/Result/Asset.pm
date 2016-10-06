use utf8;
package OpusVL::CMS::Schema::Result::Asset;
our $VERSION = '32';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Asset

=cut

use strict;
use warnings;
use HTML::Element;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<assets>

=cut

__PACKAGE__->table("assets");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'assets_id_seq'

=head2 status

  data_type: 'text'
  default_value: 'published'
  is_nullable: 0

=head2 filename

  data_type: 'text'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 mime_type

  data_type: 'text'
  is_nullable: 0

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
    sequence          => "assets_id_seq",
  },
  "status",
  { data_type => "text", default_value => "published", is_nullable => 0 },
  "filename",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "mime_type",
  { data_type => "text", is_nullable => 0 },
  "site",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "priority",
  { data_type => "integer", default_value => 10, is_nullable => 1 },
  "slug",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=cut

=head2 asset_attribute_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AssetAttributeData>

=cut

__PACKAGE__->has_many(
  "attribute_values",
  "OpusVL::CMS::Schema::Result::AssetAttributeData",
  { "foreign.asset_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

sub attribute
{
    my ($self, $field) = @_;

    my $search = {};
    my $args = { prefetch => ['field'] };
    if (ref $field) {
        $search->{field_id} = $field->id
    }
    else
    {
        $search->{'field.code'} = $field;
    }

    my $current_value = $self->search_related('attribute_values', $search, $args)->first;
    return undef unless $current_value;
    return $current_value->date_value if($current_value->field->type eq 'date');
    return $current_value->value;
}


=head2 asset_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AssetData>

=cut

__PACKAGE__->has_many(
  "asset_datas",
  "OpusVL::CMS::Schema::Result::AssetData",
  { "foreign.asset_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 asset_users

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AssetUser>

=cut

__PACKAGE__->has_many(
  "asset_users",
  "OpusVL::CMS::Schema::Result::AssetUser",
  { "foreign.asset_id" => "self.id" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:civfYlahwBqBDSi3bGCXdg

sub content {
    my $self = shift;

    my $asset_data = $self->history->first;

    return $asset_data ? $asset_data->data : "";
}

sub history {
    my $self = shift;

    return $self->search_related( 'asset_datas', {}, { 
        order_by => { -desc => 'created' },
    } );
}

sub set_content {
    my ($self, $content) = @_;

    if ($content) {
        $self->create_related('asset_datas', {data => $content});
    }
}

sub publish {
    my $self = shift;

    $self->update({status => 'published'});
}

sub remove {
    my $self = shift;

    $self->update({status => 'deleted'});
}

sub update_attribute
{
    my ($self, $field, $value) = @_;

    my $current_value = $self->find_related('attribute_values', { field_id => $field->id });
    my $data = {};
    if($field->type eq 'date')
    {
        $data->{date_value} = $value;
    }
    else
    {
        $data->{value} = $value;
    }
    if($current_value)
    {
        $current_value->update($data);
    }
    else
    {
        $data->{field_id} = $field->id;
        $self->create_related('attribute_values', $data);
    }
}

=head2 as_html

=over

=item $url

The model cannot know the URL of the asset, so you have to provide it if you want it to make sense.

=item $inline

A boolean that causes the method to output the asset's content if possible

=back

Returns an L<HTML::Element> object that represents this asset as HTML.

By default, a link will be created, with this asset's URL in situ. With a true
value as the first parameter, the asset's data will be rendered inline, when it
makes sense to do so (i.e. when it's textual data)

=cut

sub as_html {
    my $self = shift;
    my $url = shift;
    my $inline = shift && $self->mime_type =~ /text|javascript/;

    my $lol;
    if ($inline) {
        $lol = [
            pre => $self->content
        ];
    }
    else {
        if ($self->mime_type =~ /css/) {
            die "URL required to render asset ${\$self->id} as HTML." unless $url;
            $lol = [
                link => {
                    rel => 'stylesheet',
                    href => $url
                }
            ]
        }
        elsif ($self->mime_type =~ /image/) {
            die "URL required to render asset ${\$self->id} as HTML." unless $url;
            $lol = [
                img => {
                    src => $url,
                    alt => $self->attribute('alt_text'),
                }
            ]
        }
        elsif ($self->mime_type =~ /javascript/) {
            die "URL required to render asset ${\$self->id} as HTML." unless $url;
            $lol = [
                script => {
                    src => $url,
                    type => 'application/javascript'
                }
            ]
        }
        else {
            die "Don't know how to sensibly render ${\$self->mime_type}";
        }
    }

    return HTML::Element->new_from_lol($lol);
}
# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
