package OpusVL::FB11X::CMS::Controller::CMS::Pages;

use 5.010;
use Moose;
use Scalar::Util qw<blessed looks_like_number>;
use namespace::autoclean;
use Switch::Plain;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';
with 'OpusVL::FB11X::CMSView::Roles::CMSStash';
 
__PACKAGE__->config
(
    fb11_name                 => 'Pages',
    fb11_icon                 => '/static/modules/cms/cms-icon-small.png',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_css                  => [qw<
        /static/css/cms.css
        /static/js/codemirror/codemirror.css  
        /static/summernote/summernote.css>],
    fb11_js                   => [qw<
        /static/js/cms.js 
        /static/js/codemirror/codemirror.js 
        /static/js/codemirror/addon/selection/selection-pointer.js 
        /static/js/codemirror/mode/xml/xml.js 
        /static/js/codemirror/mode/javascript/javascript.js 
        /static/js/codemirror/mode/css/css.js 
        /static/js/codemirror/mode/vbscript/vbscript.js 
        /static/js/codemirror/mode/htmlmixed/htmlmixed.js 
        /static/summernote/summernote.js>],
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_shared_module        => 'CMS',
);

 
#-------------------------------------------------------------------------------

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{section} = 'Pages';
    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Pages',
        url     => $c->uri_for( $c->controller->action_for('index'))
    };

    1;
}

sub _load_page
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('page')
    :CaptureArgs(1)
    :FB11Feature('Pages - Read Access')
{
    my ($self, $c, $page_id) = @_;
    my $page = $c->model('CMS::Page')->find({ site => $c->stash->{site}->id, id => $page_id });

    unless ($page) {
        $c->flash(error_msg => "No such page");
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $c->stash->{site}->id ]));
        $c->detach;
    }
    
    $c->stash( 
        page => $page,
        page_content => $page->content,
        # Overwrite the list we got from site. This is inefficient, but it's the CMS.
        attachments  => [ $page->attachments->all ],
    );
}

sub index
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('pages')
    :Args(0)
    :FB11Feature('Pages - Read Access') 
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};

    my $pages = [ $c->model('CMS::Page')
        ->search({
            site => $site->id,
            status => 'published',
            blog   => 0,
            parent_id => undef,
        }, { order_by => { '-asc' => 'url' }})->all ];

    $c->stash( pages => $pages );

    if ($c->req->body_params->{edit_page}) {
        if (my $page = $site->pages->search({ -and => [ status => 'published', url => $c->req->body_params->{edit_page} ] })->first) {
            $c->res->redirect($c->uri_for($self->action_for('edit_page'), [ $site->id, $page->id ]));
            $c->detach;
        }
    }
}

# I think this is deprecated
sub page_list
    :Chained('_load_page')
    :PathPart('children')
    :Args(0)
    :FB11Feature('Pages - Read Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};
    my $page = $c->stash->{page};

    $c->stash( kids => [ $page->children()->all ] || [] );
}

#-------------------------------------------------------------------------------

sub orphan_pages
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('orphaned-pages')
    :Args(0)
    :FB11Feature('Pages - Read Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};

    my @orphans;
    my $non_published_pages = $site->pages->search({ -or => [ { status => 'deleted' }, { id => { -ident => 'parent_id' } }] });
    if ($non_published_pages->count > 0) {
        for my $page ($non_published_pages->all) {
            my $alive_children = $page->children()->search({ status => 'published' });
            for my $child ($alive_children->all) {
                unshift @orphans, $child;
            }
        }

        if (scalar(@orphans) > 0) { $c->stash(orphans => \@orphans); }
    }
}

sub blogs
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('blogs')
    :Args(0)
    :FB11Feature('Blogs')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};
    $c->stash(blogs => [ $c->model('CMS::Page')->search({ status => 'published', site => $site->id, blog => 1 })->all ]);
}

sub _load_blog
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('blog')
    :CaptureArgs(1)
    :FB11Feature('Blogs')
{
    my ($self, $c, $page_id) = @_;
    my $page = $c->model('CMS::Page')->find({ site => $c->stash->{site}->id, id => $page_id });

    unless ($page) {
        $c->flash(error_msg => "No such page");
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $c->stash->{site}->id ]));
        $c->detach;
    }
    
    $c->stash( 
        page => $page,
        attachments  => [ $page->attachments->all ],
    );
}

sub blog_posts
    :Chained('_load_blog')
    :PathPart('posts')
    :Args(0)
    :FB11Feature('Blogs')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};
    my $blog = $c->stash->{page};

    $c->stash(posts => [ $blog->children()->all ]);
}

#-------------------------------------------------------------------------------

sub new_page
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('new-page')
    :Args(0)
    :FB11Form
    :FB11Feature('Pages - Write Access')
{
    my ($self, $c) = @_;
    my $site       = $c->stash->{site};

    my $templates = $site->all_templates;
    if ($templates->count < 1) {
        $c->flash->{error_msg} = "You may want to setup a template before you create a page";
        $c->res->redirect($c->uri_for($c->controller('Modules::CMS::Templates')->action_for('new_template'), [ $site->id ]));
        $c->detach;
    }

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $site->id ]));
        $c->detach;
    }
    
    $c->stash->{element_rs} = $c->model('CMS::Element');
    $self->add_final_crumb($c, "New page");

    my $form = $c->stash->{form};
    
    $form->get_all_element({name=>'template'})->options(
        [map {[$_->id, $_->name . " (" . $_->site->name . ")"]} $templates->all]
    );
    $form->get_all_element({name=>'parent'})->options(
        [map {[$_->id, $_->breadcrumb . " - " . $_->url]} $c->model('CMS::Page')->search({ site => $site->id })->published->all]
    );
    $form->get_all_element({ name => 'markup_type' })->options(
        [['Standard', 'Standard'], ['Markdown', 'Markdown']]
    );

    $form->default_values({
        site => $site->id,
        content_type => 'text/html',
    });
    # This part was throwing out undefined value as a HASH reference errors
    # before validating the $c->req->body_params
    if ($c->req->query_params->{parent_id}) {
        my $parent_id = $c->req->param('parent_id');
        if (my $parent = $c->model('CMS::Page')->find($parent_id)) {
            $form->default_values({
                parent => $parent_id,
                url    => $parent->url eq '/' ? '/' : $parent->url . "/",
            });

            $c->stash->{is_a_post} = 1 if $parent->blog;
        }
    }

    if ($c->req->query_params and $c->req->query_params->{type} eq 'blog') {
        $c->stash->{type} = 'Blog';
        $form->default_values({
            content => q{
[% page = cms.param('page') %]
[% UNLESS page %][% page = 1 %][% END %]
[% articles = me.children({},{'sort' = 'newest', 'rows' = 5, 'page' = page, 'rs_only' = 1}) %]

[% WHILE (article = articles.next) %]
    <div style="padding-bottom:20px;" class="">
        <h3>[% article.title %]</h3>
        <strong>[% article.description %]</strong>
        <p>[% article.content.substr(0, 300).replace('\<div\>', '').replace('\<\/div\>', '') | none %]...</p>

        <a style="font-weight:bold" href="[% article.url %]">Read more</a>
    </div>
[% END %]

<div id="pager">
[% pager = articles.pager %]
[% IF pager.previous_page %]
    <div id="pager_prev">
        <a href="[% me.url %]?page=[% pager.previous_page %]">&laquo; Previous page</a>
    </div>
[% END %]
[% IF pager.next_page %]
    <div id="pager_next">
        <a href="[% me.url %]?page=[% pager.next_page %]">Next page &raquo;</a>
   </div>
[% END %]
</div>
            },
        });
    }

    $form->get_all_element({ name => 'url' })->get_constraint({ type => 'Callback' })->callback(sub {
        my $res = $c->model('CMS::Page')
            ->search({
                site => $site->id,
                url => $c->req->body_params->{url},
                status => 'published' });
            
        return 1 unless $res->count; 
        return 0;
    });
   
    $form->process;

    if ($form->submitted_and_valid) {
        my $page_url = $form->param_value('url');
        unless ($page_url =~ m!^/!) {$page_url = "/$page_url"}

        my $status = $c->req->body_params->{preview} ?
            'preview' : 'published';

        my $page = $c->model('CMS::Page')->create({
            url         => $page_url,
            description => $form->param_value('description'),
            title       => $form->param_value('title'),
            h1          => $form->param_value('h1'),
            priority    => $form->param_value('priority') || undef,
            breadcrumb  => $form->param_value('breadcrumb'),
            template_id => $form->param_value('template') || undef,
            parent_id   => $form->param_value('parent') || undef,
            markup_type => $form->param_value('markup_type') || 'Standard',
            site        => $site->id,
            status      => $status,
            blog        => $c->req->query_params && $c->req->param('type') eq 'blog' ? 1 : 0,
            content_type => $form->param_value('content_type') || 'text/html',
            created_by  => $c->user->id,
        });
        
        $page->set_content($form->param_value('content'));

        if ($status eq 'preview') {
            $c->res->redirect($c->uri_for($c->controller->action_for('preview'), [$site->id, $page->id]) . "?panel=1");
            $c->detach;
        }

        if (my $parent = $form->param_value('parent')) {
            if (my $blog = $c->model('CMS::Page')->search({ id => $parent, blog => 1 })->first) {
                $c->res->redirect($c->uri_for($self->action_for('blog_posts'), [ $site->id, $blog->id ]));
                $c->detach;
            }
        }

        $c->res->redirect($c->uri_for($c->controller->action_for('edit_page'), [ $site->id, $page->id ]));
    }
}

sub clone_page
    :Chained('_load_page')
    :PathPart('clone')
    :Args(0)
    :FB11Feature('Pages - Write Access')
{
    my ($self, $c) = @_;
    my $page = $c->stash->{page};
    my $site = $c->stash->{site};

    if (my $new_page = $page->copy({ status => 'preview', url => $page->url . "_clone" })) {
        my $page_users = $c->model('CMS::PageUser');
        $new_page->set_content($page->content);
        $page_users->find_or_create({
            page_id => $new_page->id,
            user_id => $c->user->id,
        });

        $c->flash(status_msg => "You are now viewing the clone of " . $page->title);
        $c->res->redirect($c->uri_for($self->action_for('edit_page'), [ $site->id, $new_page->id ]));
        $c->detach;
    }
}
sub no_page_restriction :Action :FB11Feature('Unrestricted Access to Individual Items') {}

sub edit_page
    :Chained('_load_page')
    :PathPart('')
    :Args(0)
    :FB11Form
    :FB11Feature('Pages - Write Access')
{
    my ($self, $c) = @_;
    my $page = $c->stash->{page};
    my $site = $c->stash->{site};

    if (! $c->can_access($self->action_for('no_page_restriction'))
    and ! $c->model('CMS::PageUser')->find({ page_id => $page->id, user_id => $c->user->id }))
    {
        $c->detach('/access_denied');
    }

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $site->id ]));
        $c->detach;
    }
    
    $self->add_final_crumb($c, "Edit page");

    #FIXME: my $page_users = [ $site->page_users->page_us ];
    my $site_users = [ $site->sites_users->all ];
    my $form = $c->stash->{form};
    
    $c->stash(
        site_users => $site_users,
        page_users => [ $page->page_users->all ],
    );

    my $templates = $site->all_templates;
    
    $form->get_all_element({name=>'template'})->options(
        [map {[$_->id, $_->name . " (" . $_->site->name . ")"]} $templates->all ]
    );
    $form->get_all_element({name=>'parent'})->options(
        [map {[$_->id, $_->breadcrumb . " - " . $_->url]} $site->pages->published->all ]
    );
    
    $form->get_all_element({ name => 'markup_type' })->options(
        [['Standard', 'Standard'], ['Markdown', 'Markdown']]
    );

    my $aliases_fieldset = $form->get_all_element({name=>'page_aliases'});
    if (my @aliases = $page->search_related('aliases')) {
        foreach my $alias (@aliases) {
            $aliases_fieldset->element({
                type     => 'Multi',
                label    => 'URL',
                elements => [
                    {
                        type  => 'Text',
                        name  => 'alias_url_' . $alias->id,
                        value => $alias->url,
                    },
                    {
                        type  => 'Checkbox',
                        name  => 'delete_alias_' . $alias->id,
                        label => 'Delete',
                    },
                ]
            });
        }
    } else {
        $aliases_fieldset->element({
            type    => 'Block',
            tag     => 'p',
            content => 'No aliases have been created for this page',
        });
    }
    
    my $defaults = {
        url         => $page->url,
        description => $page->description,
        title       => $page->title,
        h1          => $page->h1,
        breadcrumb  => $page->breadcrumb,
        template    => $page->template_id,
        parent      => $page->parent_id,
        content     => $page->content,
        priority    => $page->priority,
        note_changes => $page->note_changes,
        site         => $site->id,
        content_type => $page->content_type,
        markup_type  => $page->markup_type,
    };
 
    $self->construct_attribute_form($c, { type => 'page', site_id => $site->id });

    my @fields = $site->page_attributes->active->all;
    for my $field (@fields)
    {
        my $value = $page->page_attribute($field);
        $defaults->{'global_fields_' . $field->code} = $value;
    }
    
    $form->default_values($defaults);
    $form->process;

    if ($form->submitted_and_valid) {
        my $page_url = $form->param_value('url');
        unless ($page_url =~ m!^/!) {$page_url = "/$page_url"}

        if ($c->req->body_params->{preview}) {
            if ($page->content ne $form->param_value('content')) {
                my $copy = $page->get_page_content->copy({ status => 'preview', body => $form->param_value('content'), created => DateTime->now() });
                if ($copy) {
                    $c->res->redirect($c->uri_for($self->action_for('preview'), [ $site->id, $page->id ]) . "?panel=1&content=" . $copy->id);
                    $c->detach;
                }
            }
            else {
                $c->res->redirect($c->uri_for($self->action_for('preview'), [ $site->id, $page->id ]) . "?panel=1");
                $c->detach;
            }
        }

        my $new_content = $page->create_related('page_contents', {
            body => $form->param_value('content'),
            created_by => $c->user->id,
        });
        #die $form->param_value('description');
        $page->update({
            url         => $page_url,
            description => $form->param_value('description'),
            title       => $form->param_value('title'),
            h1          => $form->param_value('h1'),
            priority    => $form->param_value('priority') || undef,
            breadcrumb  => $form->param_value('breadcrumb'),
            template_id => $form->param_value('template') || undef,
            parent_id   => $form->param_value('parent') || undef,
            content_type => $form->param_value('content_type') || 'text/html',
            site        => $site->id,
            note_changes => $form->param_value('note_changes'),
            status      => 'published',
            markup_type => $form->param_value('markup_type') 
        });
        
        if (my $file  = $c->req->upload('new_att_file')) {
            my $attachment = $page->create_related('attachments', {
                slug        => $form->param_value('slug')||'',
                filename    => $file->basename,
                mime_type   => $file->type,
                description => $form->param_value('new_att_desc'),
                priority    => $form->param_value('new_att_priority') || undef,
            });
            
            if ($attachment->slug eq '') { $attachment->update({ slug => $attachment->id }); }
            $attachment->set_content($file->slurp);
        }
        
        PARAM: foreach my $param (keys %{$c->req->params}) {
            if ($param =~ /delete_alias_(\d+)/) {
                if (my $alias = $page->find_related('aliases', {id => $1})) {
                    $alias->delete;
                }
            }

            if ($param =~ /alias_url_(\d+)/) {
                if (my $alias = $page->find_related('aliases', {id => $1})) {
                    my $alias_url = $form->param_value($param);
                    unless ($alias_url =~ m!^/!) {$alias_url = "/$alias_url"}
                    if ($alias_url ne $alias->url) {
                        $page->create_related('aliases', {url => $alias_url});
                    }
                }
            }
        }
        
        if (my $alias_url = $form->param_value('new_alias_url')) {
            unless ($alias_url =~ m!^/!) {$alias_url = "/$alias_url"}
            $page->create_related('aliases', {url => $alias_url});
        }

        $self->update_page_attributes($c, $page, $site);

        if ($c->req->body_params->{allow_users}) {
            my $user_rs = $c->model('CMS::User');
            my $users = $c->req->body_params->{allow_users};
            $users    = [ $users ] if ref($users) ne 'ARRAY';
            for my $user (@$users) {
                $user = $user_rs->find($user);
                if ($user) {
                    $page->page_users->find_or_create({
                        page_id => $page->id,
                        user_id => $user->id,
                    });
                }
            }
        }

        $c->flash->{status_msg} = "Your changes have been saved";
        $c->res->redirect($c->uri_for($self->action_for('edit_page'), [ $site->id, $page->id ]));
        $c->detach;
    }
    
    $c->stash(
        page => $page,
    );
}

sub delete_page
    :Chained('_load_page')
    :PathPart('delete')
    :Args(0)
    :FB11Form
    :FB11Feature('Pages - Write Access')
{
    my ($self, $c) = @_;

    my $page = $c->stash->{page};
    my $site = $c->stash->{site};
    my $form = $c->stash->{form};
    
    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $site->id ]));
        $c->detach;
    }
    
    $self->add_final_crumb($c, "Delete page");
    
    if ($form->submitted_and_valid) {
        my $parent = $page->parent;
        if ($parent && $parent->blog) {
            my $parent = $page->parent;
            if (my $blog = $c->model('CMS::Page')->find({ id => $parent->id, type => 'blog' })) {
                $page->remove;
                $c->res->redirect($c->uri_for($self->action_for('blog_posts'), [ $site->id, $blog->id ]));
                $c->detach;
            }
        }
        my $action = $page->blog ? 'blogs' : 'index';
        $page->remove;
        
        $c->flash->{status_msg} = "Page deleted";
        $c->res->redirect($c->uri_for($c->controller->action_for($action), [ $site->id ]));
        $c->detach;
    }
}

sub save_preview
    :Chained('_load_page')
    :Args(0)
    :FB11Feature('Pages - Write Access')
{
    my ($self, $c)   = @_;
    my $site         = $c->stash->{site};
    my $page         = $c->stash->{page};
    # There's a bug where if you save a preview of an edited page
    # you end up with duplicate published versions.. let's try to patch that 
    # up briefly here, for now
    #if (my $is_page = $c->model('CMS::Page')->find({ url => $page->url, status => 'published' })) {
    #    $is_page->update({ status => 'draft' });
    #}
    
    #if ($page->status eq 'preview') {
        $page->get_page_content->update({ status => 'Published' });
        $page->update({ status => 'published' });

        if ($c->req->query_params && $c->req->query_params->{content} ne '') {
            if (my $new_content = $c->model('CMS::PageContent')->find( $c->req->param('content'))) {
                $page->get_page_content->update({ status => 'draft' });
                $new_content->update({ status => 'Published' });
            }
        }
        $c->flash(status_msg => "Successfully saved your page");
        $c->res->redirect($c->uri_for($self->action_for('edit_page'), [ $site->id, $page->id ]));
        $c->detach;
    #}
}

sub cancel_preview 
    :Chained('_load_page')
    :Args(0)
    :FB11Feature('Pages - Read Access')
{
    my ($self, $c, $page_id) = @_;

    my $site = $c->stash->{site};
    my $page = $c->stash->{page};

    if ($page->status eq 'preview') {
        $c->flash(status_msg => "Cancelled preview");
        $c->res->redirect($c->uri_for($self->action_for('edit_page'), [ $site->id, $page->id ]));
        $c->detach;
    }
}

sub delete_attachment
    :Local
    :Args(1)
    :FB11Form
    :FB11Feature('Pages - Write Access')
{
    my ($self, $c, $attachment_id) = @_;
    
    $self->add_final_crumb($c, 'Delete attachment');
    
    my $attachment = $c->model('CMS::Attachment')->find({id => $attachment_id});
    my $form       = $c->stash->{form};
    my $page = $c->model('CMS::Page')->find($attachment->page_id);

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($c->controller->action_for('edit_page'), [ $page->site->id, $attachment->page_id ]));
        $c->detach;
    }
    
    if ($form->submitted_and_valid) {
        $attachment->remove;
        
        $c->flash->{status_msg} = "Attachment deleted";
        $c->res->redirect($c->uri_for($c->controller->action_for('edit_page'), [ $page->site->id, $attachment->page_id ]));
        $c->detach;
    }
    
    $c->stash->{attachment} = $attachment;
}

sub edit_attachment
    :Local
    :Args(1)
    :FB11Form
    :FB11Feature('Pages - Write Access')
{
    my ($self, $c, $attachment_id) = @_;
    
    $self->add_final_crumb($c, 'Delete attachment');
    
    my $attachment = $c->model('CMS::Attachment')->find({id => $attachment_id});
    my $form       = $c->stash->{form};
    my $page       = $c->model('CMS::Page')->find( $attachment->page_id );
    my $defaults = {
        slug        => $attachment->slug,
        description => $attachment->description,
        priority    => $attachment->priority,
    };
    
    $c->stash(
        attachment => $attachment,
        site       => $page->site,
    );

    $self->construct_attribute_form($c, { type => 'attachment', site_id => $page->site->id });

    my @fields = $page->site->attachment_attributes->active->all;
    for my $field (@fields)
    {
        my $value = $attachment->attribute($field);
        $defaults->{'global_fields_' . $field->code} = $value;
    }
    
    $form->default_values($defaults);    
    $form->process;

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($c->controller->action_for('edit_page'), [ $page->site->id, $attachment->page_id ]) . '#tab_attachments');
        $c->detach;
    }
    
    if ($form->submitted_and_valid) {
        $attachment->update({
            description => $form->param_value('description'),
            priority    => $form->param_value('priority'),
        });

        if (my $file = $c->req->upload('file')) {
            $attachment->set_content($file->slurp);
            $attachment->update({
                filename  => $file->basename,
                mime_type => $file->type,
            });
        }
        
        $self->update_attachment_attributes($c, $attachment, $page->site);

        $c->res->redirect($c->uri_for($c->controller->action_for('edit_page'), [ $page->site->id, $attachment->page_id ]) . '#tab_attachments');
        $c->detach;        
    }

}

sub revisions
    :Chained('_load_page')
    :Args(0)
    :FB11Feature('Pages - Read Access')
{
    my ($self, $c) = @_;
    my $page = $c->stash->{page};

    $c->stash->{pages}  = [$page->search_related('page_contents', undef, {
        select => [qw/created_by.name created_by.username created id/],
        as => [qw/author_name author_username created id/],
        join => ['created_by'],
        order_by => { -desc => 'created' }
    })->all];
    
}

sub restore
    :Chained('_load_page')
    :PathPart('restore')
    :Args(0)
    :FB11Feature('Pages - Write Access')
{
    my ($self, $c) = @_;
    my $site         = $c->stash->{site};
    my $page         = $c->stash->{page};
    my $page_content = $page->get_page_content;

    if ($c->req->query_params && $c->req->query_params->{content} ne '') {
        if (my $con = $c->model('CMS::PageContent')->find({ page_id => $page->id, id => $c->req->param('content') })) {
            $page_content->update({ status => 'draft' });
            $page_content = $con;
        }
    }

    $c->flash(status_msg => "Successfully restored revision from " . $page_content->created->dmy . ' ' . $page_content->created->hms);
    $page_content->update({ status => 'Published' }) if $page_content->status ne 'Published';
    $page_content->update({ created => DateTime->now() });
    $c->res->redirect($c->uri_for($self->action_for('revisions'), [ $site->id, $page_content->page->id ]));
}

#-------------------------------------------------------------------------------

sub construct_attribute_form
{
    my ($self, $c, $args) = @_;
    my $site = $c->stash->{site};
    my $fields_rs = $args->{type} eq 'page' ?
        $site->page_attributes
      : $site->attachment_attributes;

    my @fields = $fields_rs->search({}, { order_by => { -asc => 'code' } });

    # Argh, I need to fix this in the schema!
    my $form = $c->stash->{form};
    if(@fields)
    {
        my $global_fields = $form->get_all_element('global_fields');
        my $no_fields = $form->get_all_element('no_fields');
        for my $field (@fields)
        {
            my $details;
            $details = {
                type => 'Text',
                label => $field->name,
                name => "global_fields_".$field->code,
                container_attributes => { class => 'form-group' },
                attributes => { class => 'form-control' },
            };

            sswitch($field->type || '')
            {
                case 'html': {
                    $details->{type} = 'Textarea';
                    $details->{attributes} = {
                        class => 'wysiwyg form-control',
                    };
                }
                case 'number': {
                    $details->{constraints} = { type => 'Number' };
                    $details->{type} = 'number';
                }
                case 'boolean': {
                    $details->{type} = 'Checkbox';
                    $details->{container_attributes}->{class} = 'checkbox';
                    delete $details->{attributes}->{class};
                    $details->{layout} = [ { label => ['field', 'label_text'] }, 'comment', 'errors', 'javascript'];
                }
                case 'date': {
                    $details->{attributes} = {
                        autocomplete => 'off',
                        class => 'date_picker form-control',
                    };
                    $details->{size} = 12;
                    $details->{inflators} = {
                        type => 'DateTime',
                        strptime => '%Y-%m-%d 00:00:00',
                        parser => {
                            strptime => '%d/%m/%Y',
                        }
                    };
                    $details->{deflator} = {
                        type => 'Strftime',
                        strftime => '%d/%m/%Y',
                    };
                }
                case 'integer': {
                    $details->{constraints} = { type => 'Integer' };
                    $details->{type} = 'number';
                    $details->{attributes}->{step} = 1;
                }
                case 'select': {
                    $details->{type} = 'Select';
                    $details->{empty_first} = 1;
                    $details->{options} = $field->form_options($site);
                }
            }
            my $element = $global_fields->element($details);
        }
        $global_fields->remove_element($no_fields);
    }
}


#-------------------------------------------------------------------------------

sub update_page_attributes
{
    my ($self, $c, $page, $site) = @_;

    my $form = $c->stash->{form};
    my @fields = $site->page_attributes->active->all;
    for my $field (@fields)
    {
        my $value = $form->param_value('global_fields_' . $field->code);
        $page->update_attribute($site->id, $field, $value);
    }

}


#-------------------------------------------------------------------------------

sub update_attachment_attributes
{
    my ($self, $c, $attachment, $site) = @_;

    my $form = $c->stash->{form};
    my @fields = $site->attachment_attributes->active->all;
    for my $field (@fields)
    {
        my $value = $form->param_value('global_fields_' . $field->code);
        $attachment->update_attribute($site->id, $field, $value);
    }

}

#-------------------------------------------------------------------------------

sub draft_delete :Local :Path('draft/delete') :Args(1) :FB11Feature('Pages - Write Access') {
    my ($self, $c, $draft_id) = @_;
    my $draft = $c->model('CMS::PageDraft')->find($draft_id);
    my $page;
    if ($draft) {
        $page = $draft->page;
        $draft->page_drafts_contents->delete;
        $draft->delete;
        $c->flash->{status_msg} = "Successfully removed draft";
    }
    else {
        $c->flash->{error_msg} = "Could not find page draft with that id";
        $c->res->redirect($c->uri_for($self->action_for('index')));
        $c->detach;
    }

    $c->res->redirect($c->uri_for($self->action_for('revisions'), $page->id));
    $c->detach;
}

#-------------------------------------------------------------------------------

sub preview
    :Chained('_load_page')
    :Args(0)
    :FB11Feature('Pages - Read Access')
{
    my ($self, $c)   = @_;
    my $site         = $c->stash->{site};
    my $page_content = $c->stash->{page_content};
    my $page         = $c->stash->{page};

    if ($c->req->query_params && $c->req->query_params->{content}) {
        if (my $con = $c->model('CMS::PageContent')->find( $c->req->param('content') )) {
            $page_content = $con->body;
        }
    }

    if ($c->req->body_params->{cancel}) {
        my $page = $c->model('CMS::Page')->find($c->req->body_params->{page_id});
        my $site = $c->model('CMS::SitesUser')->find({ site_id => $page->site->id, user_id => $c->user->id });
        if ($site) {
            $page->delete;
            $c->flash->{status_msg} = 'Successfully cancelled and removed preview';
            $c->res->redirect($c->uri_for($c->controller('CMS::Pages')->action_for('index'), [ $site->id ]));
            $c->detach;
        }
        else {
            $c->flash->{error_msg} = 'Unable to delete page. Do you have access to it?';
            $c->flash->{status_msg} = 'Successfully published page';
            $c->res->redirect($c->uri_for($c->controller('CMS::Pages')->action_for('index'), [ $site->id ]));
            $c->detach;
        }
    }

    if ($c->req->body_params->{publish}) {
        # This seems silly but I've not received a bug report
        my $page = $c->model('CMS::PageContent')->find($c->req->body_params->{page_id});
        if ($page) {
            $page->update({ status => 'published' });
            $c->flash->{status_msg} = 'Successfully published page';
            $c->res->redirect($c->uri_for($c->controller('CMS::Pages')->action_for('index'), [ $site->id ]));
            $c->detach;
        }
        else {
            $c->flash->{error_msg} = 'Unable to publish page. Do you have access to it?';
            $c->flash->{status_msg} = 'Successfully published page';
            $c->res->redirect($c->uri_for($c->controller('CMS::Pages')->action_for('index'), [ $site->id ]));
            $c->detach;
        }
    }

    my $asset_rs   = $c->model('CMS::Asset');
    my $element_rs = $c->model('CMS::Element');
    $c->stash->{me}  = $page;
    $self->setup_cms_stash($c, $site, { preview => 1 });

    if (my $template = $page->template->content) {
        my $panel = '';
        if ($c->req->query_params->{panel}) {
            $c->stash->{template} = 'modules/cms/ajax/preview_panel.tt';
            $c->stash->{no_wrapper} = 1;
            $c->forward('View::FB11TT');
            $panel = $c->res->body;
        }
        my $content_block;
        if($page->markup_type eq 'Markdown')
        {
            $content_block = '[% BLOCK content %][% USE MultiMarkdown -%][% FILTER multimarkdown %]' 
                . $page_content
                . $panel
                . '[% END %][% END %]';
        }
        else
        {
            $content_block = '[% BLOCK content %]' . $page_content . $panel . '[% END %]';
        }
        $template = $content_block . $template;
        $c->stash->{template}   = \$template;
        $c->stash->{no_wrapper} = 1;
    }
    
    $c->forward('View::CMS::Preview');
}

sub _asset :Local :Args(3) {
    my ($self, $c, $site_id, $asset_id, $filename) = @_;
    my $site = $c->model('CMS::Site')->find({ id => $site_id });
    $self->__asset($c, $site, $asset_id, $filename);
}

sub _attachment :Path('/_attachment') :Args(3) {
    my ($self, $c, $site_id, $attachment_id, $filename) = @_;

    my $site = $c->model('CMS::Site')->find({ id => $site_id });
    $self->__attachment($c, $site, $attachment_id, $filename);
}

sub _thumbnail :Path('/_thumbnail') :Args(3) {
    my ($self, $c, $site_id, $type, $id) = @_;
    
    my $site = $c->model('CMS::Site')->find({ id => $site_id });
    $self->__thumbnail($c, $site, $type, $id);
}

1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::Pages

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 base

=head2 pages

=head2 page_contents

=head2 index

=head2 page_list

=head2 orphan_pages

=head2 blogs

=head2 blog_posts

=head2 new_page

=head2 clone_page

=head2 no_page_restriction

=head2 edit_page

=head2 delete_page

=head2 save_preview

=head2 cancel_preview

=head2 delete_attachment

=head2 edit_attachment

=head2 revisions

=head2 restore

=head2 construct_attribute_form

=head2 update_page_attributes

=head2 update_attachment_attributes

=head2 draft_delete

=head2 preview

=head2 restrict_pages

=head1 ATTRIBUTES


=cut
