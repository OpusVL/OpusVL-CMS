package OpusVL::FB11X::CMS::Controller::CMS;

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller'; };
with 'OpusVL::FB11::RolesFor::Controller::UI';

__PACKAGE__->config
(
    fb11_name                 => 'CMS',
    # fb11_icon                 => 'static/images/flagA.jpg',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_js                     => ['/static/js/cms.js'],
    # fb11_method_group         => 'Extension A',
    # fb11_method_group_order   => 2,
    # fb11_shared_module        => 'ExtensionA',
);

sub auto :Private {
    my ($self, $c) = @_;
 
    if (! $c->user) {
        $c->res->redirect('/logout');
        $c->detach;
    }

    push @{$c->stash->{breadcrumbs}}, {
        name => 'CMS',
        url  => $c->uri_for($c->controller('Modules::CMS::Sites')->action_for('index')),
    };

    1;
}

sub home
    :Path
    :Args(0)
    :NavigationHome
    :FB11Feature('CMS Home')
{
    my ($self, $c) = @_;
}

sub portlet_recent_pages : PortletName('Most Recent Pages') :FB11Feature('Portlets') {
    my ($self, $c) = @_;
    my $sites = $c->model('CMS::SitesUser')->search({ user_id => $c->user->id });

    # FIXME: This is super inefficient. Learn how to properly join or prefetch the tables required.
    my $pages = $c->model('CMS::Page')->search({
        created => {
            -between => [
                DateTime->now->subtract(days => 5),
                DateTime->now(),
            ],
        },
        status => 'published',
    }, {
        rows     => 5,
        order_by => { -desc => [ 'created' ] },
    });

    my @user_pages;
    for my $page ($pages->all) {
        if ($page->site->sites_users->find({ user_id => $c->user->id  })) {
            push @user_pages, $page;
        }
    }

    $c->stash(cms_recent_pages => \@user_pages);
}

sub portlet_current_site : PortletName('Sites') :FB11Feature('Portlets') {
    my ($self, $c) = @_;
    my $sites      = $c->model('CMS::SitesUser')->search({ user_id => $c->user->id });
    
    if ($sites->count > 0) {
        my $active_sites = $sites->search_related('site', { status => 'active' });
        $c->stash(
            sites        => [ $sites->all ],
            active_sites => $active_sites->count,
        );
    }
}

sub redirect_url :Local :Args() :FB11Feature('Redirect URL') {
    my ($self, $c, $controller, $action, @args) = @_;
    $controller = ucfirst($controller);
    if (@args) {
        $c->res->redirect($c->uri_for($c->controller("Modules::CMS::${controller}")->action_for($action),
            @args));
        $c->detach;
    }
    else {
        $c->res->redirect($c->uri_for($c->controller("Modules::CMS::${controller}")->action_for($action)));
        $c->detach;
    }
}

sub site_validate :Action :Args(0) :FB11Feature('Validate Site') {
    my ($self, $c) = @_;
    my $site   = $c->stash->{site};
    if (! $site) {
        $c->flash->{error_msg} = "Please select a site before proceeding";
        $c->res->redirect($c->uri_for($c->controller('Sites')->action_for('index')));
        $c->detach;
    }

    1;
}


=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 home

=head2 portlet_recent_pages

=head2 portlet_current_site

=head2 redirect_url

=head2 site_validate

=head1 ATTRIBUTES


=cut
