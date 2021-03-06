use utf8;
package OpusVL::CMS::Schema::Result::Page;
our $VERSION = '68';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Page

=cut

use DBIx::Class;
use Hash::Merge qw/merge/;
use DateTime;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class';

__PACKAGE__->load_components("Tree::AdjacencyList", "InflateColumn::DateTime", "Core");

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

=head1 TABLE: C<pages>

=cut

__PACKAGE__->table("pages");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'pages_id_seq'

=head2 markup_type

  data_type: 'text'
  is_nullable: 0
  default_value: Standard

=head2 url

  data_type: 'text'
  is_nullable: 0

=head2 status

  data_type: 'text'
  default_value: 'published'
  is_nullable: 0

=head2 parent_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 template_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 h1

  data_type: 'text'
  is_nullable: 1

=head2 breadcrumb

  data_type: 'text'
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

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
    sequence          => "pages_id_seq",
  },
  "url",
  { data_type => "text", is_nullable => 0 },
  "status",
  { data_type => "text", default_value => "published", is_nullable => 0 },
  "parent_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "template_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "h1",
  { data_type => "text", is_nullable => 1 },
  "breadcrumb",
  { data_type => "text", is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "priority",
  { data_type => "integer", default_value => 50, is_nullable => 0 },
  "content_type",
  { data_type => "text", default_value => "text/html", is_nullable => 0 },
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
  "site",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "created_by",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "blog",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "note_changes",
  { data_type => "text", is_nullable => 1 },
  "markup_type",
  { data_type => "text", is_nullable => 1, original => { default_value => "Standard" } },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 page_users

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageUser>

=cut

__PACKAGE__->has_many(
  "page_users",
  "OpusVL::CMS::Schema::Result::PageUser",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

__PACKAGE__->has_many(
  "forms_submit_fields",
  "OpusVL::CMS::Schema::Result::FormsSubmitField",
  { "foreign.redirect" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 aliases

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Alias>

=cut

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

__PACKAGE__->has_many(
  "aliases",
  "OpusVL::CMS::Schema::Result::Alias",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 attachments

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Attachment>

=cut

__PACKAGE__->has_many(
  "attachments",
  "OpusVL::CMS::Schema::Result::Attachment",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 created_by

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "created_by",
  "OpusVL::CMS::Schema::Result::User",
  { id => "created_by" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 page_attribute_datas

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageAttributeData>

=cut

__PACKAGE__->has_many(
  #"page_attribute_datas",
  "attribute_values",
  "OpusVL::CMS::Schema::Result::PageAttributeData",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 page_contents

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageContent>

=cut

__PACKAGE__->has_many(
  "page_contents",
  "OpusVL::CMS::Schema::Result::PageContent",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

__PACKAGE__->has_many(
    our_attributes => 'OpusVL::CMS::Schema::Result::PageAttribute',
    { "foreign.page_id" => "self.id" },
    { cascade_copy => 0 }
);

__PACKAGE__->has_many(
    _our_attributes => 'OpusVL::CMS::Schema::Result::PageAttribute',
    sub {
        my $args = shift;
        return { 
            "$args->{foreign_alias}.site_id" => { '=' => \"?"},
            "$args->{foreign_alias}.page_id" => { -ident => "$args->{self_alias}.id" }, 
            "$args->{foreign_alias}.code" => { '=' => \"?"},
        },
    },
    { cascade_copy => 0 }
);



=head2 page_drafts

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageDraft>

=cut

__PACKAGE__->has_many(
  "page_drafts",
  "OpusVL::CMS::Schema::Result::PageDraft",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 page_tags

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageTag>

=cut

__PACKAGE__->has_many(
  "page_tags",
  "OpusVL::CMS::Schema::Result::PageTag",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 pages

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Page>

=cut

__PACKAGE__->has_many(
  "pages",
  "OpusVL::CMS::Schema::Result::Page",
  { "foreign.parent_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


=head2 parent

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Page>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "OpusVL::CMS::Schema::Result::Page",
  { id => "parent_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 template

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Template>

=cut

__PACKAGE__->belongs_to(
  "template",
  "OpusVL::CMS::Schema::Result::Template",
  { id => "template_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

__PACKAGE__->parent_column('parent_id');

__PACKAGE__->has_many(
  "children",
  "OpusVL::CMS::Schema::Result::Page",
  { "foreign.parent_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->add_unique_constraint([ 'url', 'site' ]);
# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6YoYkiRXCQN+clv2uac/Wg


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

sub get_parents {
    my $self = shift;
    
    my $page = $self;
    my @parents = ( $page );
    while( my $parent = $page->parent ) {
        push @parents, $parent;
        $page = $parent;
    }

    @parents = reverse @parents;
    return \@parents;
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

    return $self->search_related( 'page_contents', { status => 'Published' }, { order_by => { -desc => 'created' }, rows => 1 } )->first->body;
}

sub get_page_content {
    my $self = shift;
    return $self->search_related( 'page_contents', { status => 'Published' }, { order_by => { -desc => 'created' }, rows => 1 } )->first;
}

=head2 set_content

=cut

sub set_content
{
    my ($self, $content) = @_;
    
    $self->create_related('page_contents', {body => $content, status => 'Published'});
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
    return $self->$orig()->published->attribute_search($self->site, $query, $options);
};

around 'children_rs' => sub {
    my ($orig, $self, $query, $options) = @_;
    $options //= {};
    $options->{rs_only} = 1;
    return $self->$orig()->published->attribute_search($self->site, $query, $options);
};

=head2 attachments

=cut

around 'attachments_rs' => sub {
    my ($orig, $self, $query, $options) = @_;
    $options //= {};
    $options->{rs_only} = 1;
    return $self->$orig()->published->attribute_search($self->site, $query, $options);
};

around 'attachments' => sub {
    my ($orig, $self, $query, $options) = @_;

    return $self->$orig()->published->attribute_search($self->site, $query, $options);
};

sub assets {
    my ($self, $query, $options) = @_;
    return $self->site->all_assets->published->attribute_search($self->site, $query, $options);
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

=head2 attribute

=cut

sub page_attribute
{
    my ($self, $field) = @_;
    my $column_name = "attribute_$field" =~ s/\W/_/gr;
    if($self->has_column_loaded($column_name))
    {
        my $val = $self->get_column($column_name);
        my $type = $self->get_column($column_name . '_type');
        if($type && $type eq 'date')
        {
            # inflate the date.
            my $dtf = $self->result_source->schema->storage->datetime_parser;
            $val = $dtf->parse_date($val);
        }
        return $val;
    }
    my $search = {};
    my $args = { prefetch => ['field'] };
    if (ref $field) {
        $search->{field_id} = $field->id;
    } else {
        $search->{'field.code'} = $field;
    }

    my $site = $self->site->profile_site ? $self->site->profile : $self->site;
    my $current_value = $self->search_related('attribute_values', $search, $args)
        ->search( 
            { 
                'field.active' => '1',
                'site.id' => $site->id,
            },
            { join => { 'field' => 'site' } },
        )
        ->first;
    return undef unless $current_value;
    return $current_value->date_value if $current_value->field->type eq 'date';
    return $current_value->value;
}

sub cascaded_attribute
{
    my ($self, $field) = @_;

    my $column_name = "attribute_${field}_cascade" =~ s/\W/_/gr;
    if($self->has_column_loaded($column_name))
    {
        # see if we've pre-loaded the cascade field
        # if we have, and the field isn't cascaded we can short
        # circuit all this.
        # I'm still leaving the cascaded fields un-optimised for now.
        return undef unless $self->get_column($column_name);
    }

    my $site = $self->site;
    unless (ref $field) {
        $field = $site->page_attribute_details->search({code => $field})->first;
    }
    
    if ($field) {
      if ($field->cascade) {
          foreach my $page (reverse $self->tree) {
              if (my $value = $page->page_attribute($field)) {
                  return $value;
              }
          }
      }
    }

    return;
}

has _attribute_cache => (is => 'rw', default => sub { {} });

sub attribute
{
    my ($self, $field) = @_;
    unless($self->_attribute_cache)
    {
        $self->_attribute_cache({});
    }
    if(exists $self->_attribute_cache->{$field})
    {
        return $self->_attribute_cache->{$field};
    }
    
    my $value = $self->page_attribute($field) || $self->cascaded_attribute($field);
    $self->_attribute_cache->{$field} = $value;
    return $value;
}

sub get_last_draft {
    my $self = shift;
    return $self->search_related('page_drafts', {}, {
        rows => 1,
        order_by => { -desc => 'id' }
    })->first;
}

sub allows_user {
    my ($self, $user_id) = @_;
    if ($self->page_users->find({ user_id => $user_id })) { return 1; }
    
    return 0;
}

sub attachment {
    my ($self) = shift;
    my $attachment = $self->attachments->published->first;

    if ($attachment) {
        return "/_attachment/"
            . $attachment->id
            . "/"
            . $attachment->filename;
    }
}

sub get_attachments {
    my ($self, $options) = @_;

    my $attribute_query = delete $options->{query} // {};

    # FIXME: come back to this.
    return [ $self->attachments($attribute_query, $options)->all ];
}

sub date {
    my ($self, %opts) = @_;
    %opts = () if not %opts;
    return DateTime->now(%opts);
}

sub blog_image {
    my ($self, $type) = @_;
    my $query = { 'attachments.status' => 'published' };
    $query->{description} = (defined $type and $type eq 'thumb') ?
        { '=', 'thumb' } : { '!=', 'thumb' };
 
    my $attachment = $self->search_related(
        'attachments',
        $query,
        { rows => 1 }
    )->first;
    
    if ($attachment) {
        return "/_attachment/"
            . $attachment->id
            . "/"
            . $attachment->filename;
    }

}

sub blog_featured {
    my ($self, $align) = @_;
    $align //= 'center';

    $align = $align eq 'center' ? 'text-align: center' : "float: ${align}";

    # first make sure we have a blog
    if ($self->parent->blog) {
        # are we using a youtube video first of all?
        if (my $youtube_id = $self->attribute('blog_featured_video')) {
            return qq{
                <div style="$align">
                <a href="//www.youtube.com/watch?v=$youtube_id" rel="prettyPhoto">
                    <img class="responsive-img" src="//img.youtube.com/vi/$youtube_id/default.jpg">
                </a>
                </div>
            };
        }
        else {
            my $atts = $self->attachments({ blog_featured_image => { '!=' => undef } });
            if ($atts->count > 0) {
                my $imgsrc = $atts->first->slug;
                return qq{
                    <div style="$align">
                        <img style="max-width:100%" class="responsive-img" src="/_attachment/$imgsrc/$imgsrc">
                    </div>
                };
            }
        }
    }
}

##

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
