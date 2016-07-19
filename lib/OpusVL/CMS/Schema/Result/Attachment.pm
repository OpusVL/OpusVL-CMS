use utf8;
package OpusVL::CMS::Schema::Result::Attachment;
our $VERSION = '12';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Attachment

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

=head1 TABLE: C<attachments>

=cut

__PACKAGE__->table("attachments");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'attachments_id_seq'

=head2 page_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

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

=head2 priority

  data_type: 'integer'
  default_value: 50
  is_nullable: 0

=head2 created

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 updated

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
    sequence          => "attachments_id_seq",
  },
  "page_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "status",
  { data_type => "text", default_value => "published", is_nullable => 0 },
  "filename",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "mime_type",
  { data_type => "text", is_nullable => 0 },
  "priority",
  { data_type => "integer", default_value => 50, is_nullable => 0 },
  "created",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "updated",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
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

=head2 attachment_attribute_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AttachmentAttributeData>

=cut

__PACKAGE__->has_many(
  "attribute_values",
  "OpusVL::CMS::Schema::Result::AttachmentAttributeData",
  { "foreign.attachment_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 attachment_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AttachmentData>

=cut

__PACKAGE__->has_many(
  "att_data",
  "OpusVL::CMS::Schema::Result::AttachmentData",
  { "foreign.att_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 attachment_tags

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AttachmentTag>

=cut

__PACKAGE__->has_many(
  "attachment_tags",
  "OpusVL::CMS::Schema::Result::AttachmentTag",
  { "foreign.attachment_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 page

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Page>

=cut

__PACKAGE__->belongs_to(
  "page",
  "OpusVL::CMS::Schema::Result::Page",
  { id => "page_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Oth62DSimHUi4Wg5sBuF3g

sub content {
    my $self = shift;

    return $self->search_related( 'att_data', { }, { order_by => { -desc => 'created' }, rows => 1 } )->first->data;
}

sub set_content {
    my ($self, $data) = @_;

    $self->create_related('att_data', {data => $data});
    $self->update({updated => DateTime->now()});
}

sub publish
{
    my $self = shift;

    $self->update({status => 'published'});
}

sub remove
{
    my $self = shift;

    $self->update({status => 'deleted'});
}

=head2 attribute

=cut

sub attribute
{
    my ($self, $field) = @_;
    my $site = $self->page->site;
    unless (ref $field) {
        $field = $site->attachment_attribute_details->search({code => $field})->first;
    }

    my $current_value = $self->search_related('attribute_values', { field_id => $field->id })->first;
    return undef unless $current_value;
    return $current_value->date_value if($field->type eq 'date');
    return $current_value->value;
}

=head2 update_attribute

=cut

sub update_attribute
{
    my ($self, $site, $field, $value) = @_;

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

sub gallery_full_size_image {
    my $self = shift;
    if ($self->attribute('type') eq 'Gallery - Thumbnail') {
        return $self->find_related('attribute_values', {
            code => 'gallery_image_id',
            type => 'Gallery - Full size',
        });
    }
    
    return undef;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
