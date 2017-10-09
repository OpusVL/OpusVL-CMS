package OpusVL::FB11X::CMS::Controller::CMS::Sites;

use 5.010;
use Moose;
use namespace::autoclean;
use experimental 'smartmatch';
use IO::Socket::INET;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';
 
__PACKAGE__->config
(
    fb11_name                 => 'Sites',
    fb11_icon                 => '/static/modules/cms/cms-icon-small.png',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_shared_module        => 'CMS',
    fb11_css                  => ['/static/css/cms.css'],
);

 
#-------------------------------------------------------------------------------

sub auto :Private {
    my ($self, $c) = @_;
 
    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Sites',
        url     => $c->uri_for( $c->controller->action_for('index'))
    };
}


#-------------------------------------------------------------------------------

sub index :Path :Args(0) :NavigationName('Sites') :FB11Feature('Site - Read Access') {
    my ($self, $c) = @_;

    my @sites;
    my @profiles;
    if($c->can_access($self->action_for('access_all_sites')))
    {
        @sites = $c->model('CMS::Site')->real_sites->sort_by_name->active->all;
        @profiles = $c->model('CMS::Site')->profile_sites->sort_by_name->active->all;
    }
    else
    {
        @sites = $c->model('CMS::SitesUser')->real_sites($c->user->id)->sort_by_name->active->all;
        @profiles = $c->model('CMS::SitesUser')->profile_sites($c->user->id)->sort_by_name->active->all;
    }
    $c->stash->{sites} = \@sites;
    $c->stash->{profiles} = \@profiles;
}

sub _profiles
{
    my ($self, $c) = @_;
    if($c->can_access($self->action_for('access_all_sites')))
    {
        return $c->model('CMS::Site')->profile_sites->sort_by_name->active;
    }
    return $c->model('CMS::SitesUser')->profile_sites($c->user->id)->sort_by_name->active;
}
#-------------------------------------------------------------------------------

sub add {
    my ($self, $c, $is_profile) = @_;
    my $form       = $c->stash->{form};
    my $users      = [ $c->model('CMS::User')->all ];
    my %user_list  = map { $_->username => $_->id } @{$users};
    $self->add_final_crumb($c, "Add Site");
    
    $form->get_all_element ({ name => 'user_list' })->options([
        map {[ $_->id => $_->username ]} @{$users}
    ]);
    
    if ($form->submitted_and_valid) {
        my $sites_users = $c->model('CMS::SitesUser');
        my $sites       = $c->model('CMS::Site');
        my $data = { 
            name => $form->param('name'),
           ($is_profile ? () : profile_site => $form->param('site_profile')),
            template => $is_profile,
        };
        my $site        = $sites->create($data);
        if ($site) {
            $site->discard_changes;

            my $users_to_add = $c->req->body_params->{user_list};
            $users_to_add = [ $users_to_add ]
                if ref($users_to_add) ne 'ARRAY';

            for my $user_id (@{$users_to_add}) {
                $sites_users->create({
                    site_id => $site->id,
                    user_id => $user_id,
                });
            }

            my $many = scalar(@{$users_to_add}) > 1 ? 'users' : 'user'; 
            $c->flash->{status_msg} = "Successfully added ${many} to site " . $form->param('name');

            if ($form->param('clone_pages')) {
                for my $page ($site->profile->pages) {
                    my %clone = $page->get_columns;
                    delete $clone{id};
                    delete $clone{site};
                    my $new_page = $site->add_to_pages(\%clone);

                    # Don't care about the original's history
                    $new_page->set_content($page->content);
                }
            }

            $c->res->redirect($c->uri_for($self->action_for('index')));
            $c->detach;
        }
        else {
            $c->flash->{error_msg} = "There was a problem adding the site to the database";
            $c->res->redirect($c->uri_for($self->action_for('add')));
            $c->detach;
        }
    }
    
    $c->stash->{template} = 'modules/cms/sites/add.tt';
    $c->stash->{type} = $is_profile ? 'Profile' : 'Site';
}

sub add_site 
    :Local
    :Args(0)
    :FB11Form
    :FB11Feature('Site - Write Access')
{
    my ($self, $c) = @_;
    my $form = $c->stash->{form};
    $form->get_all_element('site_profile')->options($self->_profiles($c)->as_formfu_options);
    $self->add($c, 0);
}

sub add_profile
    :Local
    :Args(0)
    :FB11Form
    :FB11Feature('Site - Write Access')
{
    my ($self, $c) = @_;
    $self->add($c, 1);
}
sub access_all_sites
    : Action
    : FB11Feature('Access All Sites') { }

sub _load_site
    : Chained('/')
    : PathPart('site')
    : CaptureArgs(1)
{
    my ($self, $c, $site_id) = @_;
    my $site = $c->model('CMS::Site')->search({ id => $site_id, status => 'active' })->first;
    unless ($site) {
        $c->flash->{error_msg} = "Could not locate site";
        $c->res->redirect($c->uri_for($self->action_for('index')));
        $c->detach;
    }

    if (! $c->model('CMS::SitesUser')->find({ site_id => $site_id, user_id => $c->user->id })) {
        unless($c->can_access($self->action_for('access_all_sites')))
        {
            $c->flash(error_msg => "Sorry, but you don't have access to this site");
            $c->res->redirect($c->uri_for($self->action_for('index')));
            $c->detach;
        }
    }

    # This goes here because for some reason preprocess.tt exists 
    $c->stash(
        site        => $site,
        elements    => [ $site->all_elements->filter_by_slug ],
        assets      => [ $site->all_assets->filter_by_slug ],
        site_attributes  => [ $site->all_site_attributes->filter_by_code ],
        pages       => [ $site->all_pages->published->filter_by_url ],
        attachments => [ $site->all_pages->search_related('attachments', { 'attachments.status' => 'published' })->all ],
    );
}

sub base
    :Chained('_load_site') 
    :PathPart('')
    :FB11Feature('Site - Read Access')
    :CaptureArgs(0)
{
    my ($self, $c) = @_;

    my $site = $c->stash->{site};
}

#-------------------------------------------------------------------------------

sub delete_site :Local Chained('base') :FB11Feature('Site - Write Access') {
    my ($self, $c) = @_;

    my $site = $c->stash->{site};
    
    if(uc $c->req->method eq 'POST') {
        $site->update({ status => 'deleted' });
        $site->master_domains->delete;

        $c->flash->{status_msg} = 'Successfully removed ' . $site->name;
        $c->res->redirect($c->uri_for($self->action_for('index')));
    }
}

#-------------------------------------------------------------------------------

sub edit :Chained('base') :PathPart('edit') :Args(0) :FB11Form :FB11Feature('Site - Write Access') {
    my ($self, $c)  = @_;
    my $form        = $c->stash->{form};
    my $site        = $c->stash->{site};
    my $sites_users = [ $site->sites_users->all ];

    $c->stash->{sites_users} = $sites_users;

    # populate default values

    $form->get_all_element('site_profile')->options($self->_profiles($c)->as_formfu_options);
    $form->default_values({
        name => $site->name,
        site_profile => $site->profile_site,
    });
    $form->get_all_element ({ name => 'user_list' })->options([
        map {[ $_->id => $_->username ]} $c->model('CMS::User')->all
    ]);
    $form->default_values({ user_list => [ map { $_->user_id } $site->sites_users->all ] });

    if ($form->submitted_and_valid) {
        my $sites_users_rs = $c->model('CMS::SitesUser');
        my $site_users = $sites_users_rs
            ->search({ site_id => $site->id });

        $site_users->delete();

        my $users_to_add = $c->req->body_params->{user_list};
        $users_to_add = [ $users_to_add ]
            if ref($users_to_add) ne 'ARRAY';

        for my $user_id (@{$users_to_add}) {
            $sites_users_rs->create({
                site_id => $site->id,
                user_id => $user_id,
            });
        }

        $site->update({ 
            name => $form->param('name'), 
            profile_site => $form->param('site_profile')||undef 
        });

        my $many = scalar(@{$users_to_add}) > 1 ? 'users' : 'user'; 
        $c->flash->{status_msg} = "Successfully updated ${many} to site " . $form->param('name');
        $c->res->redirect($c->req->uri);
        $c->detach;

    }

    if ($c->req->body_params->{site_cache_clear}) {
        $site->clear_cache;
        $c->flash(status_msg => 'Doughnut cache cleared');
        $c->detach;
    }
    if ($c->req->body_params->{site_clone}) {
        if (my $new_site = $site->clone) {
            $c->flash(status_msg => 'Successfully cloned site');
            $c->res->redirect($c->uri_for($self->action_for('edit'), [ $new_site->id ]));
            $c->detach;
        }
        else {
            $c->flash(error_msg => 'Ouch. Something went wrong while trying to clone the site');
            $c->res->redirect($c->req->uri);
            $c->detach;
        }
    }

    if ($c->req->body_params->{cancel}) {
        $c->res->redirect($c->uri_for($self->action_for('index')));
        $c->detach;
    }
}

#-------------------------------------------------------------------------------

sub manage_attributes :Chained('base') :PathPart('attributes/manage') :Args(0) :FB11Form :FB11Feature('Site - Write Access') {
    my ($self, $c) = @_;
    my $site = $c->stash->{site};
    my $form = $c->stash->{form};
    $site    = $c->model('CMS::Site')->find($site->id);
    my @attribute = $site->all_site_attributes->filter_by_code;
    if (@attribute) {
        $c->stash->{site_attributes} = \@attribute;
    }

    if ($c->req->body_params->{save_attributes}) {
        foreach my $attr (@attribute) {
            my $description = $c->req->body_params->{'attribute_description_' . $attr->id};
            my $value = $c->req->body_params->{'attribute_value_' . $attr->id};

            if ($attr->site_id != $site->id) {
                $site->create_related('site_attributes', {
                    name => $attr->name,
                    code => $attr->code,
                    description => $description,
                    value => $value,
                });
            }
            else {
                $attr->update({
                    description => $description,
                    value => $value,
                });
            }
        }

        $c->flash(status_msg => "Updated attributes");
        $c->res->redirect($c->req->uri);
        $c->detach;
    }

    if ($form->submitted_and_valid) {
        my ($attr_name, $attr_descr, $attr_value) = (
            $form->param_value('attr_name'),
            $form->param_value('attr_descr'),
            $form->param_value('attr_value'),
        );

        my $attr_code   = lc $attr_name;           # make the attribute name lowercase
        $attr_code      =~ s/\s/_/g;               # replace whitespace with underscores
        $attr_code      =~ s/[^\w\d\s]//g;         # remove any punctuation

        my $new_attr = $site->create_related('site_attributes', {
            name  => $attr_name,
            code  => $attr_code,
            description => $attr_descr,
            value => $attr_value,
        });

        if ($new_attr) {
            $c->flash(status_msg => "Successfully created new attribute $attr_name");
            $c->res->redirect($c->req->uri);
            $c->detach;
        }
    }
}

#-------------------------------------------------------------------------------

sub delete_attribute :Chained('base') :PathPart('attribute/delete') :Args(1) :FB11Feature('Site - Write Access') {
    my ($self, $c, $attr_id) = @_;
    my $site = $c->stash->{site};

    if (my $attr = $site->site_attributes->find($attr_id)) {
        $c->stash->{attribute} = $attr;

        if(uc $c->req->method eq 'POST') {
            my $attr_name = $attr->code;
            $attr->delete;
            $c->flash(status_msg => "Successfully removed attribute $attr_name");
            $c->res->redirect($c->uri_for($self->action_for('manage_attributes'), [ $site->id ]));
            $c->detach;
        }
    } else {
        $c->flash->{error_msg} = "Could not locate attribute - it may have already been deleted";
        $c->res->redirect($c->uri_for($self->action_for('manage_attributes'), [ $site->id ]));
        $c->detach;
    }
}

sub clear_cache
    : Local 
    : NavigationName('Clear Cache')
    : FB11Feature('Clear Cache')
    : FB11Form
{
    my ($self, $c) = @_;

    unless ($c->config->{cache_host} and $c->config->{cache_port}) {
        $c->stash->{error_msg} = "Cache is not correctly configured";
    }

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my ($host, $port) = (
            $c->config->{cache_host},
            $c->config->{cache_port}
        );

        $| = 1;
 
        my $socket = new IO::Socket::INET (
            PeerHost => $host,
            PeerPort => $port,
            Proto => 'tcp',
        );

        unless ($socket) {
            $c->res->body("Could not connect to cache server (${host}:${port})");
            $c->detach;
        }

        my $response = "";
        $socket->recv($response, 1024);
        chomp $response;
        if ($response eq 'OK') {
            $response = "The cache was successfully cleared";
        }
        elsif ($response eq 'ERROR') {
            $response = "There was a problem flushing the cache";
        }
        else {
            $response = "Received an unknown response: $response";
        }

        $c->stash->{status} = $response;
    }
}

1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::Sites

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 index

=head2 add

=head2 add_profile

=head2 add_site

=head2 access_all_sites

An action solely to allow a permission to be granted.

=head2 base

=head2 delete_site

=head2 edit

=head2 manage_attributes

=head2 delete_attribute

=head2 clear_cache

=head2 clear_cache_ajax

=head1 ATTRIBUTES


=cut
