package OpusVL::CMS::Schema::Result::Assets;

=head1 NAME

OpusVL::CMS::Schema::Result::Assets -

=head1 DESCRIPTION

Schema configuration of the Assets in the SimpleCMS

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

OpusVL - JJ

=head1 COPYRIGHT & LICENSE

Copyright 2012 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut

###########################################################################################


use DBIx::Class;
use Moose;
extends 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("assets");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
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
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
    'asset_data',
    'OpusVL::CMS::Schema::Result::AssetData',
    { 'foreign.asset_id', 'self.id' },
    { cascade_copy => 1, cascade_delete => 1 },
);

sub content {
    my $self = shift;
    
    return $self->search_related( 'asset_data', {}, { order_by => { -desc => 'created' } } )->first->data;
}

sub set_content {
    my ($self, $content) = @_;
    
    $self->create_related('asset_data', {data => $content});
}

sub publish {
    my $self = shift;
    
    $self->update({status => 'published'});
}

sub remove {
    my $self = shift;
    
    $self->update({status => 'deleted'});
}

##
1;
