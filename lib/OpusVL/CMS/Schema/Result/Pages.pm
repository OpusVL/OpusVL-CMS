package OpusVL::CMS::Schema::Result::Pages;

=head1 NAME

OpusVL::CMS::Schema::Result::Page -

=head1 DESCRIPTION

Schema configuration of the Pages in the SimpleCMS

=head1 METHODS

tree            -
head            - 
body            -
cascaded_tags   - 
page_tags       -
tags            - 

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

__PACKAGE__->load_components("Tree::AdjacencyList", "InflateColumn::DateTime", "Core");
__PACKAGE__->table("pages");
__PACKAGE__->add_columns(
    "id" => {
        data_type   => "serial",
        is_nullable => 0,
    },
    "url" => {
        data_type => "text",
        is_nullable => 0,
    },
    "status" => {
        data_type     => "text",
        is_nullable   => 0,
        default_value => 'published',
    },
    "parent_id" => {
        data_type   => "integer",
        is_nullable => 1,
    },
    "template_id" => {
        data_type   => "integer",
        is_nullable => 1,
    },
    "h1" => {
        data_type   => "text",
        is_nullable => 1,
    },
    "breadcrumb" => {
        data_type   => "text",
        is_nullable => 0,
    },
    "title" => {
        data_type   => "text",
        is_nullable => 0,
    },
    "description" => {
        data_type   => "text",
        is_nullable => 1,
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

__PACKAGE__->has_many(
    "attachments",
    "OpusVL::CMS::Schema::Result::Attachments",
    { "foreign.page_id" => "self.id" },
);

__PACKAGE__->has_many(
    "contents",
    "OpusVL::CMS::Schema::Result::PageContents",
    { "foreign.page_id" => "self.id" },
);

__PACKAGE__->has_many(
    'attribute_values',
    'OpusVL::CMS::Schema::Result::PageAttributeData',
    {'foreign.page_id' => 'self.id'},
    {cascade_delete => 0}
);

__PACKAGE__->has_many(
    "aliases",
    "OpusVL::CMS::Schema::Result::Aliases",
    { "foreign.page_id" => "self.id" },
);

__PACKAGE__->belongs_to(
    "template",
    "OpusVL::CMS::Schema::Result::Templates",
    { "foreign.id" => "self.template_id" },
);

__PACKAGE__->parent_column('parent_id');


__PACKAGE__->add_unique_constraint([ qw/url/ ]);
####################################################################################
# Accessors - 
####################################################################################

=head2 tree

=cut

sub tree
{
	my @tree = shift;

	while ( my $parent = $tree[0]->parent )
	{
		unshift @tree,$parent;
	}

	return @tree;
}

=head2 head

=cut

sub head
{
	my $self = shift;
	my @tree = $self->tree;
	return $tree[0];
}

=head2 decendants

=cut

sub decendants
{
    my $self = shift;
    
    if (my @kids = $self->children) {
        return $self, map {$_->decendants} @kids;
    } else {
        return $self;
    }
}

=head2 content

=cut

sub content
{
	my $self = shift;

	return $self->search_related( 'contents', { status => 'Published' }, { order_by => { -desc => 'created' }, rows => 1 } )->first->body;
}

=head2 set_content

=cut

sub set_content
{
    my ($self, $content) = @_;
    
    $self->create_related('contents', {body => $content});
    $self->update({updated => DateTime->now()});
}

=head2 publish

=cut

sub publish
{
    my $self = shift;
    
    $self->update({status => 'published'});
    
    # FIXME: publish all attachments as well
}

=head2 remove

=cut

sub remove
{
    my $self = shift;
    
    $self->update({status => 'deleted'});
    
    # FIXME: remove all attachments as well
}

=head2 children

=cut

around 'children' => sub {
    my ($orig, $self, $query, $options) = @_;

    return $self->$orig()->published->attribute_search($query, $options);
};

=head2 attachments

=cut

around 'attachments' => sub {
    my ($orig, $self, $query, $options) = @_;

    return $self->$orig()->published->attribute_search($query, $options);
};

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

=head2 attribute

=cut

sub page_attribute
{
    my ($self, $field) = @_;
    
    unless (ref $field) {
        $field = $self->result_source->schema->resultset('PageAttributeDetails')->find({code => $field});
    }

    my $current_value = $self->find_related('attribute_values', { field_id => $field->id });
    return undef unless $current_value;
    return $current_value->date_value if($field->type eq 'date');
    return $current_value->value;
}

sub cascaded_attribute
{
    my ($self, $field) = @_;
    
    unless (ref $field) {
        $field = $self->result_source->schema->resultset('PageAttributeDetails')->find({code => $field});
    }
    
    if ($field->cascade) {
        foreach my $page (reverse $self->tree) {
            if (my $value = $page->page_attribute($field)) {
                return $value;
            }
        }
    }
    
    return undef;
}

sub attribute
{
    my ($self, $field) = @_;
    
    return $self->page_attribute($field) || $self->cascaded_attribute($field);
}

##
1;
