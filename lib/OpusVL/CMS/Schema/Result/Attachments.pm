package OpusVL::CMS::Schema::Result::Attachments;

=head1 NAME

OpusVL::CMS::Schema::Result::Attachments -

=head1 DESCRIPTION

Schema configuration of the Attachments in the SimpleCMS

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

OpusVL - Nuria

=head1 COPYRIGHT & LICENSE

Copyright 2009 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut

###########################################################################################


use DBIx::Class;
use DateTime;
use Moose;
extends 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("attachments");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "page_id" => {
        data_type   => "integer",
        is_nullable => 0,
    },
    "status" => {
        data_type     => "text",
        is_nullable   => 0,
        default_value => 'published',
    },
    "filename" => {
        data_type   => "text",
        is_nullable => 0,
    },
    "description" => {
        data_type   => "text",
        is_nullable => 1,
    },
    "mime_type" => {
        data_type   => "text",
        is_nullable => 0,
    },
    "priority" => {
        data_type     => "integer",
        default_value => 50,
        is_nullable   => 0,
    },
    "created" => {
        data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
    "updated" => {
        data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    "page",
    "OpusVL::CMS::Schema::Result::Pages",
    { 'foreign.id' => 'self.page_id' },
    { cascade_delete => 0 },
);

__PACKAGE__->has_many(
    'attribute_values',
    'OpusVL::CMS::Schema::Result::AttachmentAttributeData',
    {'foreign.attachment_id' => 'self.id'},
    {cascade_delete => 0}
);

__PACKAGE__->has_many(
    'att_data',
    'OpusVL::CMS::Schema::Result::AttachmentData',
    { 'foreign.att_id', 'self.id' },
    { cascade_copy => 1, cascade_delete => 1 },
);

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
    
    unless (ref $field) {
        $field = $self->result_source->schema->resultset('AttachmentAttributeDetails')->find({code => $field});
    }

    my $current_value = $self->find_related('attribute_values', { field_id => $field->id });
    return undef unless $current_value;
    return $current_value->date_value if($field->type eq 'date');
    return $current_value->value;
}

=head2 update_attribute

=cut

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

1;
