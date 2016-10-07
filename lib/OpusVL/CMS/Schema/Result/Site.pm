use utf8;
package OpusVL::CMS::Schema::Result::Site;
our $VERSION = '35';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Site

=cut

use strict;
use warnings;

use Moose;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<sites>

=cut

__PACKAGE__->table("sites");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'sites_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 140

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "sites_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 140 },
  "status",
  {
    data_type     => "text",
    default_value => "active",
    is_nullable   => 0,
    original      => { data_type => "varchar" },
  },
  "template",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "profile_site",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=cut

__PACKAGE__->has_many(
  "asset_attributes",
  "OpusVL::CMS::Schema::Result::AssetAttributeDetail",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 assets

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Asset>

=cut

__PACKAGE__->has_many(
  "assets",
  "OpusVL::CMS::Schema::Result::Asset",
  { "foreign.site" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 elements

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Element>

=cut

__PACKAGE__->has_many(
  "elements",
  "OpusVL::CMS::Schema::Result::Element",
  { "foreign.site" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 master_domains

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::MasterDomain>

=cut

=head2 forms

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Form>

=cut

__PACKAGE__->has_many(
  "forms",
  "OpusVL::CMS::Schema::Result::Form",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 master_domains

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::MasterDomain>

Does not C<cascade_copy> because a cloned site will never have the same domains
as the original.

=cut

__PACKAGE__->has_many(
  "master_domains",
  "OpusVL::CMS::Schema::Result::MasterDomain",
  { "foreign.site" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sites_users

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::SitesUser>

=cut

__PACKAGE__->has_many(
  "sites_users",
  "OpusVL::CMS::Schema::Result::SitesUser",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 templates

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Template>

=cut

__PACKAGE__->has_many(
  "templates",
  "OpusVL::CMS::Schema::Result::Template",
  { "foreign.site" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 site_attributes

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::SiteAttribute>

=cut

__PACKAGE__->has_many(
  "site_attributes",
  "OpusVL::CMS::Schema::Result::SiteAttribute",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 pages

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::Page>

Does not C<cascade_copy> because a page's template must be set up correctly. (Is
this true? Can we not set it afterwards?)

=cut

__PACKAGE__->has_many(
  "pages",
  "OpusVL::CMS::Schema::Result::Page",
  { "foreign.site" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 page_attribute_details

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::PageAttributeDetail>

=cut

__PACKAGE__->has_many(
  "page_attribute_details",
  "OpusVL::CMS::Schema::Result::PageAttributeDetail",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 attachment_attribute_details

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::AttachmentAttributeDetail>

=cut

__PACKAGE__->has_many(
  "attachment_attribute_details",
  "OpusVL::CMS::Schema::Result::AttachmentAttributeDetail",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 profile

Site I<may> belong to another site; this site is its profile. Otherwise, this is
undef.

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
    'profile' => 'OpusVL::CMS::Schema::Result::Site',
    { id => 'profile_site' },
    {
        is_deferrable => 1,
        join_type     => "LEFT",
    },
);
has _all_elements_rs_cache => (is => 'rw');
has _all_pages_rs_cache => (is => 'rw');
has _all_site_attributes_rs_cache => (is => 'rw');
has _all_page_attribute_details_rs_cache => (is => 'rw');
has _all_attachment_attribute_details_rs_cache => (is => 'rw');
has _all_attachments_rs_cache => (is => 'rw');
has _all_assets_rs_cache => (is => 'rw');
has _all_attributes_rs_cache => (is => 'rw');
has _all_templates_rs_cache => (is => 'rw');

sub all_pages
{
    my $self = shift;
    
    return $self->_all_pages_rs_cache if $self->_all_pages_rs_cache;
    my $rs = $self->search_related('pages');
    if($self->profile_site)
    {
        my $profile_pages = $self->profile->search_related('pages');
        my $joined = $rs->union($profile_pages);
        $rs = $joined->search(undef, {
            join => 'site',
            order_by => [ 'site.profile_site' ],
        });
    }
    $self->_all_pages_rs_cache($rs);
    return $rs;
}

sub _build_rs_cache
{
    return {};
}

sub all_elements
{
    my $self = shift;
    
    return $self->_all_elements_rs_cache if $self->_all_elements_rs_cache;
    my $rs = $self->search_related('elements');
    if($self->profile_site)
    {
        my $profile_items = $self->profile->search_related('elements');
        my $joined = $rs->union($profile_items);
        $rs = $joined->search(undef, {
            join => 'site',
            order_by => [ 'site.profile_site' ],
        });
    }
    $self->_all_elements_rs_cache($rs);
    return $rs;
}

sub all_templates
{
    my $self = shift;
    
    return $self->_all_templates_rs_cache if $self->_all_templates_rs_cache;
    my $rs = $self->search_related('templates');
    if($self->profile_site)
    {
        my $profile_items = $self->profile->search_related('templates');
        my $joined = $rs->union($profile_items);
        $rs = $joined->search(undef, {
            join => 'site',
            order_by => [ 'site.profile_site' ],
        });
    }
    $self->_all_templates_rs_cache($rs);
    return $rs;
}

sub all_assets
{
    my $self = shift;
    
    return $self->_all_assets_rs_cache if $self->_all_assets_rs_cache;
    my $rs = $self->search_related('assets');
    if($self->profile_site)
    {
        my $profile_items = $self->profile->search_related('assets');
        my $joined = $rs->union($profile_items);
        $rs = $joined->search(undef, {
            join => 'site',
            order_by => [ 'site.profile_site' ],
        });
    }
    $self->_all_assets_rs_cache($rs);
    return $rs;
}

sub all_attributes
{
    my $self = shift;
    
    return $self->_all_attributes_rs_cache if $self->_all_attributes_rs_cache;
    my $rs = $self->search_related('attributes');
    if($self->profile_site)
    {
        my $profile_items = $self->profile->search_related('attributes');
        my $joined = $rs->union($profile_items);
        $rs = $joined->search(undef, {
            join => 'site',
            order_by => [ 'site.profile_site' ],
        });
    }
    $self->_all_attributes_rs_cache($rs);
    return $rs;
}

sub all_site_attributes
{
    my $self = shift;
    
    return $self->_all_site_attributes_rs_cache if $self->_all_site_attributes_rs_cache;
    my $rs = $self->search_related('site_attributes');
    if($self->profile_site)
    {
        my $profile_items = $self->profile->search_related('site_attributes');
        # limit the attributes we pull down to just those specified
        # in the profile.
        $rs = $rs->search({ code => { -in => $profile_items->get_column('code')->as_query }});
        my $joined = $rs->union($profile_items);
        $rs = $joined->search(undef, {
            join => 'site',
            order_by => [ 'site.profile_site' ],
        });
    }
    $self->_all_site_attributes_rs_cache($rs);
    return $rs;
}

sub all_attachments
{
    my $self = shift;
    
    return $self->_all_attachments_rs_cache if $self->_all_attachments_rs_cache;
    my $rs = $self->attachments;
    if($self->profile_site)
    {
        my $profile_items = $self->profile->attachments;
        my $joined = $rs->union($profile_items);
        $rs = $joined->search(undef, {
            join => { page => 'site' },
            order_by => [ 'site.profile_site' ],
        });
    }
    $self->_all_attachments_rs_cache($rs);
    return $rs;
}

sub all_attachment_attribute_details
{
    my $self = shift;
    
    return $self->_all_attachment_attribute_details_rs_cache if $self->_all_attachment_attribute_details_rs_cache;
    my $rs = $self->search_related('attachment_attribute_details');
    if($self->profile_site)
    {
        my $profile_items = $self->profile->search_related('attachment_attribute_details');
        my $joined = $rs->union($profile_items);
        $rs = $joined->search(undef, {
            join => 'site',
            order_by => [ { -desc => 'site.profile_site' } ],
        });
    }
    $self->_all_attachment_attribute_details_rs_cache($rs);
    return $rs;
}


sub all_page_attribute_details
{
    my $self = shift;
    
    return $self->_all_page_attribute_details_rs_cache if $self->_all_page_attribute_details_rs_cache;
    my $rs = $self->search_related('page_attribute_details');
    if($self->profile_site)
    {
        my $profile_items = $self->profile->search_related('page_attribute_details');
        my $joined = $rs->union($profile_items);
        $rs = $joined->search(undef, {
            join => 'site',
            order_by => [ { -desc => 'site.profile_site' } ],
        });
    }
    $self->_all_page_attribute_details_rs_cache($rs);
    return $rs;
}


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-09-24 16:18:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cFs5vMHOaxkMtvUEiz51dQ

sub master_domain {
    my $self = shift;
    return $self->master_domains->first;
}

sub _recurse_children {
    my ($self, $site, $kid, $copy_kid) = @_;
    my $template;
    for my $child ($kid->children->all) {
        if ($child->template->site->id == $self->id) {
            $template = $child->template->copy({ site => $site->id });
        }
        else {
            $template = $child->template;
        }
        my $cloned_child = $child->copy({
            template_id => $template->id,
            parent_id => $copy_kid->id,
            site => $site->id
        });
        $site->_recurse_children($site, $child, $cloned_child)
            if $child->children->count > 0;
    }
}

=head2 find_or_clone_template

=over

=item C<$page> - L<OpusVL::CMS::Schema::Result::Page>

=item C<$site> - L<OpusVL::CMS::Schema::Result::Site>

=back

Given a different site, C<$site>, and a page, C<$page>, that is part of
C<$self>, finds the template in the other site that corresponds to this page's
template. If there is no such template, it clones one from C<$self> and returns
that.

Searching is done by name.

If C<$page> does not belong to C<$self>, the page's current template is
returned.

=cut

sub find_or_clone_template {
    my ($self, $page, $site) = @_;
    my $template;
    if ($page->template->site->id != $self->id) {
        return $page->template;
    }

    if ($template = $site->templates->search({ name => $page->template->name })->first) {
        return $template;
    }
    else {
        $template = $page->template->copy({ site => $site->id });
        return $template;
    }
}

has _attribute_cache => (is => 'rw', default => sub { {} });

sub attribute {
    my ($self, $code) = @_;
    # this tends to get hit for a bunch of different attributes.
    # rather than get each one with a separate query, grab them
    # all at once and store them to give back.
    # this makes a significant performance boost.
    unless($self->_attribute_cache)
    {
        my @attributes = $self->all_site_attributes->filter_by_code;
        my %attributes = map { $_->code => $_->value } @attributes;
        $self->_attribute_cache(\%attributes);
    }
    return $self->_attribute_cache->{$code};
}

sub clone {
    my $self = shift;

    my $new_site = $self->copy({ name => $self->name . " (Clone)" });
    if ($new_site) {
        # When we clone the pages, we have to make sure the template they
        # reference is the equivalent one from the new site - or create it.
        # That's why we can't use cascade_copy on pages.
        for my $page ($self->pages->toplevel->all) {
            my $template = $self->find_or_clone_template($page, $new_site);

            my $new_page = $page->copy({
                site => $new_site->id,
                template_id => $template->id,
            });

            if ($page->children->count > 0) {
                for my $child ($page->children->all) {
                    $template = $self->find_or_clone_template($child, $new_site);

                    my $cloned_child = $child->copy({
                        template_id => $template->id, 
                        parent_id => $new_page->id,
                        site => $new_site->id,
                    });
                    $self->_recurse_children($new_site, $child, $cloned_child)
                    if $child->children->count > 0;
                }
            }
        }
        return $new_site;
    }
}

sub attachments {
    my ($self) = @_;
    return $self->search_related('pages')->published->search_related('attachments')
}
#
# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
