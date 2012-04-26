package OpusVL::CMS::Schema::Result::Tags;

=head1 NAME

OpusVL::CMS::Schema::Result::Tags -

=head1 DESCRIPTION

Schema configuration of the Tags in the SimpleCMS

=head1 METHODS

  tags - 

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
use Hash::Merge qw/merge/;
use Moose;
extends 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("tags");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "group_id" => {
        data_type   => "integer",
        is_nullable => 0,
    },
    "name" => {
        data_type   => "text",
        is_nullable => 0,
    },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
    "page_tags",
    "OpusVL::CMS::Schema::Result::PageTags",
    { "foreign.tag_id" => "self.id" },
);

__PACKAGE__->belongs_to(
    "group",
    "OpusVL::CMS::Schema::Result::TagGroups",
    { "foreign.id" => "self.group_id" },
);


###########################################################################################
# Accessors - 
###########################################################################################

sub pages {
    my $self = shift;
    
    if ($self->group->cascade) {
        return map {$_->page, $_->page->all_children} $self->page_tags->all;
    } else {
        return map {$_->page} $self->page_tags->all;
    }
}

##
1;
