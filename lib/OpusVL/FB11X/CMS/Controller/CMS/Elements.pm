package OpusVL::FB11X::CMS::Controller::CMS::Elements;

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';

__PACKAGE__->config
(
    fb11_name                 => 'Elements',
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

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{section} = 'Elements';

    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Elements',
        url     => $c->uri_for( $c->controller->action_for('index'))
    };
}

sub _load_element 
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('element')
    :CaptureArgs(1)
    :FB11Feature('Elements - Read Access')
{
    my ($self, $c, $element_id) = @_;

    my $element = $c->model('CMS::Element')->find({ site => $c->stash->{site}->id, id => $element_id });

    unless ($element) {
        $c->flash(error_msg => "No such element");
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $c->stash->{site}->id ]));
        $c->detach;
    }

    $c->stash( element => $element );
}

sub index
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('elements')
    :Args(0)
    :FB11Feature('Elements - Read Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};

    $c->stash->{elements} = [$site->elements->published->all];
}

sub new_element
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('new-element')
    :Args(0)
    :FB11Form
    :FB11Feature('Elements - Write Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};

    $self->add_final_crumb($c, "New element");

    my $form = $c->stash->{form};
    if ($form->submitted_and_valid) {
        my $element = $c->model('CMS::Element')->create({
            name   => $form->param_value('name'),
            slug   => $form->param_value('slug')||'',
            site   => $site->id,
        });

        if ($element->slug eq '') { $element->update({ slug => $element->id }); }
        $element->set_content($form->param_value('content_edit'));

        $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $site->id ]));
    }
}

sub edit_element
    :Chained('_load_element')
    :PathPart('')
    :Args(0)
    :FB11Form
    :FB11Feature('Elements - Write Access')
{
    my ($self, $c) = @_;
    my $element = $c->stash->{element};
    my $site    = $c->stash->{site};

    if (! $c->can_access($c->controller('Modules::CMS::Pages')->action_for('no_page_restriction'))
    and ! $c->model('CMS::ElementUser')->find({ element_id => $element->id, user_id => $c->user->id })) {
        $c->detach('/access_denied');
    }

    $self->add_final_crumb($c, "Edit element");

    my $form    = $c->stash->{form};
    $c->stash( attributes => [ $element->element_attributes->all ] );

    $form->default_values({
        name    => $element->name,
        content_edit => $element->content,
        slug    => $element->slug,
    });

    $form->process;

    if ($form->submitted_and_valid) {
        $element->update({name => $form->param_value('name')});

        my $saved = $form->param_value('content_edit');
        if ($saved ne $element->content) {
            $element->set_content($saved);
        }

        $c->flash(status_msg => "Updated element " . $element->name);
        $c->res->redirect($c->req->uri);
        $c->detach;
    }

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
        $c->detach;
    }

    # if a new attribute was specified
    if (my $attr = $c->req->body_params->{attr_name}) {
        $attr = lc $attr;           # make the attribute name lowercase
        $attr =~ s/\s/_/g;          # replace whitespace with underscores
        $attr =~ s/[^\w\d\s]//g;  # remove any punctuation
        $element->create_related('element_attributes', { code => $attr })
            if not $element->element_attributes->find({ code => $attr });

        $c->flash( status_msg => "Created attribute $attr" );
        $c->res->redirect($c->req->uri . "#element-attributes");
        $c->detach;
    }
}

sub delete_element
    :Chained('_load_element')
    :PathPart('delete')
    :Args(0)
    :FB11Form
    :FB11Feature('Elements - Write Access')
{
    my ($self, $c) = @_;
    my $element = $c->stash->{element};
    my $site    = $c->stash->{site};

    $self->add_final_crumb($c, "Delete element");

    my $form    = $c->stash->{form};

    if ($form->submitted_and_valid) {
        $element->remove;

        $c->flash(status_msg => "Element deleted");
        $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $site->id ]));
        $c->detach;
    }
}

sub _load_attribute
    :Chained('_load_element')
    :PathPart('attribute')
    :CaptureArgs(1)
{
    my ($self, $c, $attr_id) = @_;
    my $element = $c->stash->{element};

    if (my $attr = $element->element_attributes->find( $attr_id )) {
        $c->stash->{attr} = $attr;
    }
    else {
        $c->flash(error_msg => "No such element");
        $c->res->redirect($c->uri_for($self->action_for('edit_element'), [ $c->stash->{site}->id, $c->stash->{element}->id ]));
        $c->detach;
    }
}

sub delete_element_attribute
    :Chained('_load_element')
    :PathPart('attribute')
    :Args(1)
    :FB11Feature('Elements - Write Access') {
    my ($self, $c, $attr_id) = @_;
    my $element = $c->stash->{element};
    my $site    = $c->stash->{site};

    $c->stash->{attr}->delete;
    $c->flash(status_msg => "Successfully deleted attribute");
    $c->res->redirect($c->uri_for($self->action_for('edit_element'), [ $site->id, $element->id ]));
    $c->detach;
}

sub revert_content
    :Chained('_load_element')
    :PathPart('revert_content')
    :Args(1)
    :FB11Feature('Elements - Write Access')
    :FB11Form
{
    my ($self, $c, $content_id) = @_;
    my $element = $c->stash->{element};
    my $site    = $c->stash->{site};

    my $content = $element->history->find($content_id)
        or $c->detach('/not_found');

    if ($c->stash->{form}->submitted_and_valid) {
        $element->set_content($content->data);

        $c->flash->{status_msg} = "Successfully reverted content.";
        $c->res->redirect($c->uri_for($self->action_for('edit_element'), [ $site->id, $element->id ]));
        $c->detach;
    }

    $c->stash->{historical_content} = $content;
}

1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::Elements

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 base

=head2 elements

=head2 index

=head2 new_element

=head2 edit_element

=head2 delete_element

=head2 delete_element_attribute

=head2 revert_content


=head1 ATTRIBUTES


=cut
