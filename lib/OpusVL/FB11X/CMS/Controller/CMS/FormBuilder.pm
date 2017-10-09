package OpusVL::FB11X::CMS::Controller::CMS::FormBuilder;

use Moose;
use namespace::autoclean;
use HTML::FormHandler::Params;
use List::Gather;
use List::UtilsBy qw/sort_by/;

BEGIN { 
    extends 'Catalyst::Controller'; 
}
with 'OpusVL::FB11::RolesFor::Controller::GUI';
 
has_forms (
    _new_form_form => 'FormBuilder::NewForm',
);

sub new_form_form {
    my $self = shift;

    my %params = @_;
    my $form = $self->_new_form_form(%params);
    $form->field('redirect')->options([ 
        map { +{
            value => $_->id, 
            label => $_->url . " (" . $_->title . ")" 
        } }
        sort_by { $_->url }
        $params{ctx}->stash->{site}->pages
    ]);
    return $form;
};

__PACKAGE__->config(
    fb11_name                 => 'Form Builder',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_shared_module        => 'CMS',
    fb11_css                  => ['/static/css/cms.css'],
 );

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{section} = 'Pages';
    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Form Builder',
        url     => $c->uri_for( $c->controller->action_for('index'))
    };

    1;
}

sub _load_form
    : Chained('/modules/cms/sites/_load_site')
    : PathPart('form')
    : CaptureArgs(1)
    : FB11Feature('Forms - Read Access') 
{
    my ($self, $c, $form_id) = @_;

    my $form = $c->model('CMS::Form')->find({ site => $c->stash->{site}->id, id => $form_id });

    unless ($form) {
        $c->flash(error_msg => "No such form");
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $c->stash->{site}->id ]));
        $c->detach;
    }
    
    $c->stash( form => $form );
}

sub index
    : Chained('/modules/cms/sites/_load_site')
    : PathPart('forms')
    : Args(0)
    : FB11Feature('Forms - Read Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};

    $c->stash->{forms} = [$site->forms->all];
}

sub edit_form
    : Chained('_load_form')
    : PathPart('')
    : Args(0)
    : FB11Feature('Forms - Write Access') {
    my ($self, $c) = @_;
    my $site       = $c->stash->{site};

    my $form = $self->new_form_form(ctx => $c);
    
    my $item = $c->stash->{form};

    my $params = $c->req->body_params;
    $params = $self->_tidy_unused_fields($params);

    $form->process(
        item => $item,
        params => $params,
        posted => ($c->req->method eq 'POST'),
    );
    
    $c->stash->{new_form} = $form;
    $c->stash->{title} = "Edit Form";
    $c->stash->{template} = 'modules/cms/formbuilder/new_form.tt';
    if ($form->validated) {
        $c->res->redirect($c->req->uri);
    }
}

sub new_form
    : Chained('/modules/cms/sites/_load_site')
    : PathPart('add-form')
    : Args(0)
    : FB11Feature('Forms - Write Access')
{
    my ($self, $c) = @_;
    my $site       = $c->stash->{site};

    my $form = $self->new_form_form(ctx => $c);
    
    my $item = $site->new_related('forms', {
        owner_id => $c->user->id
    });

    my $params = $c->req->body_params;
    $params = $self->_tidy_unused_fields($params);

    $form->process(
        item => $item,
        params => $params,
        posted => ($c->req->method eq 'POST'), 
    );
    $c->stash->{new_form} = $form;
    $c->stash->{title} = "New Form";

    if ($form->validated) {
        $c->res->redirect($c->uri_for($self->action_for('edit_form'), [ $site->id, $item->id ]));
    }
}

sub submitted_forms
    : PortletName('Submitted Forms')
    : FB11Feature('Portlets')
{

    my ($self, $c) = @_;

    my $forms = $c->model('CMS::Form')->search({
        owner_id => $c->user->id,
    }, { rows => 5, order_by => { -desc => 'id' }});

    my @fields;
    my $min = DateTime->now->subtract(days => 5);

    if ($forms->count > 0) {
        for my $form ($forms->all) {
            if (my $submit = $form->forms_submit_fields->
                search(undef, { order_by => { -asc => 'submitted' } })->first) {

                if (my $submitted = $submit->submitted) {
                    if ($submitted > $min) {
                        push @fields, {
                            form      => $form->name,
                            submitted => $submitted,
                        };
                    }
                }
            }
        }

        $c->stash(fields => \@fields);
    }
}

sub delete_form
    : Chained('_load_form')
    : PathPart('delete')
    : Args(0)
    : FB11Feature('Forms - Write Access')
{

    my ($self, $c) = @_;
    my $site       = $c->stash->{site};
    my $form       = $c->stash->{form};

    if ($c->req->body_params) {
        if ($c->req->body_params->{submit_yes}) {
            $form->forms_submit_fields->delete;
            for my $field ($form->forms_fields->all) {
                if ($field->content)    { $field->content->delete; }
                if ($field->constraint) { $field->constraint->delete; }
            }
            $form->forms_fields->delete;
            $form->delete;
            $c->flash(status_msg => 'Removed form ' . $form->name);
            $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
            $c->detach;
        }
        elsif ($c->req->body_params->{submit_no}) {
            $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
            $c->detach;
        }
    }
    
}

sub _tidy_unused_fields {
    my $self = shift;
    my $params = shift;

    return {} unless %$params;

    my $params_hr = HTML::FormHandler::Params->new->expand_hash($params);

    for my $field (@{ $params_hr->{forms_fields} }) {
        if (my $options = $field->{options}) {
            @$options = grep { /\S/ } @$options;
        }
    }
    
    my @filled_fields = gather {
        for my $field (@{ $params_hr->{forms_fields} }) {
            # Let validation reject invalid ones; we only remove ones that
            # weren't filled in at all.
            if ($field->{to_delete}) { 
                next;
            }
            if ($field->{label}) {
                take $field; next;
            }
            if ($field->{constraint}) {
                take $field; next;
            }
            if ($field->{options} and @{$field->{options}}) {
                take $field; next;
            }
        }
    };

    $params_hr->{forms_fields} = \@filled_fields;

    for my $i (0 .. $#{ $params_hr->{forms_fields} }) {
        my $field =  $params_hr->{forms_fields}->[$i];
        $field->{name} = lc( $field->{label} =~ s/\s+/_/gr );
        $field->{priority} = $i;
    }

    $params_hr->{submit_field}->{priority} = @{ $params_hr->{forms_fields} };

    return $params_hr;
}

1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::FormBuilder

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 base

=head2 forms

=head2 index

=head2 edit_form

=head2 new_form

=head2 submitted_forms

=head2 delete_form

=head2 new_form_form

=head1 ATTRIBUTES


=cut
