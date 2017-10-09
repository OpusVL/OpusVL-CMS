package OpusVL::FB11X::CMS::Controller::CMS::Templates;

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';

__PACKAGE__->config
(
    fb11_name                 => 'Templates',
    fb11_icon                 => '/static/modules/cms/cms-icon-small.png',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_shared_module        => 'CMS',
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
);

sub auto :Private {
    my ($self, $c) = @_;

    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Templates',
        url     => $c->uri_for( $c->controller->action_for('index'))
    };
}

sub _load_template
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('template')
    :CaptureArgs(1)
    :FB11Feature('Templates - Read Access')
{
    my ($self, $c, $template_id)  = @_;

    my $site = $c->stash->{site};
    my $template    = $c->model('CMS::Template')->find({ site => $site->id, id => $template_id });

    unless ($template) {
        $c->flash(error_msg => "No such template");
        $c->res->redirect($c->uri_for($self->action_for('index'), $site->id));
        $c->detach;
    }

    $c->stash(
        _template => $template,
        site     => $site,
    );
}

sub index
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('templates')
    :Args(0)
    :FB11Feature('Templates - Read Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};
    if ($site) {
        my $templates = $site->templates;
        $c->stash(
            templates => [$templates->all],
            site      => $site,
        );
    }
}

#-------------------------------------------------------------------------------

sub new_template
    :Chained('/modules/cms/sites/_load_site')
    :Args(0)
    :PathPart('new-template')
    :FB11Form
    :FB11Feature('Templates - Write Access')
{
    my ($self, $c) = @_;

    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'New template',
        url     => $c->req->uri,
    };

    my $form = $c->stash->{form};
    if ($form->submitted_and_valid) {
        my $template = $c->model('CMS::Template')->create({
            name   => $form->param_value('name'),
            site   => $c->stash->{site}->id,
        });

        $template->set_content($form->param_value('content'));

        $c->flash( status_msg => 'Created new template' );
        $c->res->redirect($c->req->uri);
    }

    if ($c->req->param('cancel')) {
       $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $c->stash->{site}->id ]));
       $c->detach;
    }
}

sub edit_template
    :Chained('_load_template')
    :PathPart('')
    :Args(0)
    :FB11Form
    :FB11Feature('Templates - Write Access')
{
    my ($self, $c) = @_;

    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Edit template',
        url     => $c->req->uri,
    };

    my $form     = $c->stash->{form};
    my $template = $c->stash->{_template};
    my $site     = $c->stash->{site};

    $form->default_values({
        name    => $template->name,
        content => $template->content,
    });

    $form->process;

    if ($form->submitted_and_valid) {
        $template->update({
            name => $form->param_value('name'),
        });

        if ($form->param_value('content') ne $template->content) {
            $template->set_content($form->param_value('content'));
        }

        $c->flash(status_msg => 'Successfully updated template');
        $c->res->redirect($c->req->uri);
        $c->detach;
    }

    if ($c->req->param('cancel')) {
       $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $c->stash->{site}->id ]));
       $c->detach;
    }
}

1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::Templates

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 base

=head2 templates

=head2 index

=head2 new_template

=head2 edit_template

=head1 ATTRIBUTES


=cut
