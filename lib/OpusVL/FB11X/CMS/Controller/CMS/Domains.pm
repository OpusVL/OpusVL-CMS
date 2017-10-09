package OpusVL::FB11X::CMS::Controller::CMS::Domains;

use Moose;
use namespace::autoclean;

use URI;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';
 
__PACKAGE__->config
(
    fb11_name                 => 'Domains',
    fb11_icon                 => '/static/modules/cms/cms-icon-small.png',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_js                     => ['/static/js/cms.js', '/static/js/nicEdit.js', '/static/js/src/addElement/addElement.js'],
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_shared_module        => 'CMS',
    fb11_css                  => ['/static/css/cms.css'],
);

sub _load_domain
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('domain')
    :CaptureArgs(1) 
{
    my ($self, $c, $domain) = @_;

    my $site = $c->stash->{site};
    $domain = $c->model('CMS::MasterDomain')
        ->find({ id => $domain, site => $site->id });


    unless ($domain) {
        $c->flash->{error_msg} = "No such domain";
        $c->res->redirect($c->uri_for($c->controller('Modules::CMS::Domains')->action_for('index'), [ $site->id ]));
        $c->detach;
    }

    $c->stash(
        domain => $domain,
        site   => $site,
    );
}

sub index
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('domains')
    :Args(0)
    :FB11Feature('Domains - Read Access')
{
    my ($self, $c) = @_;
    my $site       = $c->stash->{site};
    my $domains    = $site->master_domains;

    if ($domains->count > 0) {
        $c->stash->{master_domains} = [ $domains->all ];
    }
}

sub edit 
    :Chained('_load_domain')
    :Args(0)
    :PathPart('edit')
    :FB11Form
    :FB11Feature('Domains - Write Access')
{
    my ($self, $c) = @_;
    my $form       = $c->stash->{form};
    my $site       = $c->stash->{site};
    my $domain     = $c->stash->{domain};

    my $redirect_domain   = $domain->redirect_domains->first ?
        $domain->redirect_domains->first->domain : undef;

    my $alternate_domains;
    if ($domain->alternate_domains->count > 0) {
        for my $adom ($domain->alternate_domains->all) {
            my $prot = $adom->secure ? "https://" : "http://";
            $alternate_domains .= $prot . $adom->domain . "\n";
        }
    }

    $form->default_values({
        master_domain     => $domain->domain,
        redirect_domain   => $redirect_domain,
        alternate_domains => $alternate_domains,
    });

    if ($form->submitted_and_valid) {
        $domain->update({ domain => $form->param('master_domain') });

        # update the redirect?
        if ($c->req->body_params->{redirect_domain}) {
            $domain->redirect_domains->find_or_create({
                domain          => $form->param('redirect_domain'),
                master_domain   => $domain->id,
                status          => 'active',
            });
        }
        else {
            $domain->redirect_domains->delete;
        }

        # now the alternate domains
        my @adom_errors;
        if ($c->req->body_params->{alternate_domains}) {
            $domain->alternate_domains->delete;
            if ($form->param('alternate_domains') !~ /^\s*?$/) {
                my @adomains = split("\n", $form->param('alternate_domains'));
                for my $adom (@adomains) {
                    # without the protocol on the uri, the URI module 
                    # will spaz out and not be able to get the host and port
                    if ($adom !~ /http(s)?:\/\//) {
                        push @adom_errors, $adom;
                        next;
                    }
                    $adom = URI->new($adom);
                    my ($host, $port) = ($adom->host, $adom->port);
                    my $secure        = $adom->secure;

                    $domain->alternate_domains->create({
                        domain          => $host,
                        master_domain   => $domain->id,
                        port            => $port,
                        secure          => $secure||0,
                    });
                }
            }
        }
        else {
            $domain->alternate_domains->delete;
        }

        if (scalar(@adom_errors) > 0) {
            $c->flash->{error_msg} = "Alternate domains not added because http(s):// is missing: " .
                join(', ', @adom_errors);
        }

        $c->flash->{status_msg} = "Successfully updated domain";
        $c->res->redirect($c->uri_for($self->action_for('edit'), [ $site->id, $domain->id ]));
        $c->detach;
    }

    if ($c->req->body_params->{cancel}) {
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
        $c->detach;
    }
}

sub add_master
    :Chained('/modules/cms/sites/_load_site')
    :Args(0)
    :PathPart('add-domain')
    :FB11Form
    :FB11Feature('Domains - Write Access')
{
    my ($self, $c)  = @_;
    my $form        = $c->stash->{form};
    my $site        = $c->stash->{site};
    my $domain_rs   = $c->model('CMS::MasterDomain');

    if ($form->submitted_and_valid) {
        my $exists = $domain_rs->find({ domain => $form->param('master_domain') });
        if ($exists) {
            $c->flash->{error_msg} = "The domain " . $form->param('master_domain') . " already exists";
            $c->res->redirect($c->req->uri);
            $c->detach;
        }
        else {
            my $domain = $domain_rs->create({
                site   => $site->id,
                domain => $form->param('master_domain'),
            });

            $c->flash->{status_msg} = "Successfully added master domain for " . $site->name;
            $c->res->redirect($c->uri_for($self->action_for('edit'), [ $site->id, $domain->id ]));
            $c->detach;
        }
    }

    if ($c->req->body_params->{cancel}) {
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
        $c->detach;
    }
}

sub delete_domain
    :Chained('_load_domain')
    :PathPart('delete')
    :Args(0)
    :FB11Feature('Domains - Write Access')
{
    my ($self, $c) = @_;
    my $domain = $c->stash->{domain};
    my $site   = $c->stash->{site};

    $c->flash(status_msg => "Removed " . $domain->domain);
    $domain->delete;
    $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
    $c->detach;
}

1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::Domains

=head1 DESCRIPTION

=head1 METHODS

=head2 domains

=head2 index

=head2 edit

=head2 add_master

=head2 delete_domain

=head1 ATTRIBUTES


=cut
