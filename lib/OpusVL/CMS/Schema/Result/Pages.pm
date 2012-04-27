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
    "pagetags",
    "OpusVL::CMS::Schema::Result::PageTags",
    { "foreign.page_id" => "self.id" },
);

__PACKAGE__->belongs_to(
    "template",
    "OpusVL::CMS::Schema::Result::Templates",
    { "foreign.id" => "self.template_id" },
);

__PACKAGE__->parent_column('parent_id');


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
    
    if (my @kids = $self->children->all) {
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

	return $self->search_related( 'contents', { status => 'Published' }, { order_by => { -desc => 'created' } } )->first->body;
}

=head2 set_content

=cut

sub set_content
{
    my ($self, $content) = @_;
    
    $self->create_related('contents', {body => $content});
    $self->update({updated => DateTime->now()});
}

=head2 cascaded_tags

=cut

sub cascaded_tags
{
	my $self = shift;
	my @tree = $self->tree;
	pop @tree;

	my %tags;
	foreach my $page (@tree)
	{
		#foreach my $page_tag ($page->pagetags)
		foreach my $page_tag ($page->search_related('pagetags'))
		{
			my $tag   = $page_tag->tag;
			my $group = $tag->group;
			if ( $group->cascade )
			{
				if ( $group->multiple )
				{
					push @{$tags{$group->name}}, $tag->name;
				}
				else
				{
					$tags{$group->name} = $tag->name;
				}
			}
		}
	}

	return \%tags;
}

=head2 page_tags

=cut

sub page_tags
{
	my $self = shift;

	#my %page_tags = $self->search_related( 'pagetags' );
    
    my %page_tags;
    foreach my $page_tag ($self->search_related('pagetags')) {
        my $tag   = $page_tag->tag;
        my $group = $tag->group;
        
        if ( $group->multiple ) {
            push @{$page_tags{$group->name}}, $tag->name;
        }
        else {
            $page_tags{$group->name} = $tag->name;
        }
    }

	return \%page_tags;
}

=head2 tags

=cut

sub tags
{
	my $self = shift;

	my $tags = merge( $self->page_tags, $self->cascaded_tags );

	return $tags;
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
    my $orig = shift;
    my $self = shift;
    
    return sort {$b->priority <=> $a->priority} $self->$orig(@_);
};

##
1;
