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
    "tag_links",
    "OpusVL::CMS::Schema::Result::AttachmentTags",
    { "foreign.attachment_id" => "self.id" },
);

__PACKAGE__->has_many(
    'att_data',
    'OpusVL::CMS::Schema::Result::AttachmentData',
    { 'foreign.att_id', 'self.id' },
    { cascade_copy => 1, cascade_delete => 1 },
);

sub content {
    my $self = shift;
    
    return $self->search_related( 'att_data', { }, { order_by => { -desc => 'created' } } )->first->data;
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

sub tags
{
    my $self = shift;
    
    my %att_tags;
    foreach my $att_tag ($self->search_related('tag_links')) {
        my $tag   = $att_tag->tag;
        my $group = $tag->group;
        
        if ( $group->multiple ) {
            push @{$att_tags{$group->name}}, $tag->name;
        }
        else {
            $att_tags{$group->name} = $tag->name;
        }
    }

    return \%att_tags;
}


1;
