package OpusVL::CMS::Schema::Result::Elements;

=head1 NAME

OpusVL::CMS::Schema::Result::Elements -

=head1 DESCRIPTION

Schema configuration of the Elements in the SimpleCMS

=head1 METHODS

tree            -
head            - 
body            -
cascaded_tags   - 
page_tags       -
tags            - 

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
__PACKAGE__->table("elements");
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
    "name" => {
        data_type   => "text",
        is_nullable => 0,
    },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
    "element_contents",
    "OpusVL::CMS::Schema::Result::ElementContents",
    { "foreign.element_id" => "self.id" },
    { cascade_delete => 1 }
);

sub content {
    my $self = shift;

    return $self->search_related( 'element_contents', { }, { order_by => { -desc => 'created' }, rows => 1 } )->first->data;
}

sub set_content {
    my ($self, $content) = @_;
    
    $self->create_related('element_contents', {data => $content});
}

sub publish {
    my $self = shift;
    
    $self->update({status => 'published'});
}

sub remove {
    my $self = shift;
    
    $self->update({status => 'deleted'});
    
    # FIXME: remove all page / template links to the element as well
}

##
1;
