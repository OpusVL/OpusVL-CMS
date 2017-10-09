package OpusVL::FB11X::CMS::Controller::CMS::PageAttributes;

use 5.14.0;
use Moose;
use namespace::autoclean;
use experimental 'switch';
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';
 
__PACKAGE__->config
(
    fb11_name                 => 'Page Attributes',
    fb11_icon                 => '/static/modules/cms/cms-icon-small.png',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_shared_module        => 'CMS',
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_css                  => ['/static/css/cms.css'],
);

sub auto :Private {
    my ($self, $c) = @_;
    
    $c->stash->{section} = 'Attributes';
}

sub index 
    : Chained('/modules/cms/sites/_load_site')
    : PathPart('attributes')
    : Args(0)
    : FB11Form
    : FB11Feature('Attributes - Read Access')
{
    my($self, $c) = @_;
    my $site      = $c->stash->{site};
    $self->add_breadcrumb($c, {
        name    => 'Attributes',
        url     => $c->uri_for( $c->controller->action_for('index'), [ $site->id ]),
    });

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->req->uri);
        $c->detach;
    }

    my %cached_attributes = (
        page => [ $site->page_attributes->active->filter_by_code ],
        attachment => [ $site->attachment_attributes->active->filter_by_code ],
        asset => [ $site->asset_attributes->active->filter_by_code ],
    );

    my $form    = $c->stash->{form};
    foreach my $object_type (qw/page attachment asset/) {
        my $fieldset = $form->get_all_element('current_' . $object_type . '_attributes');
        my $repeater = $form->get_all_element($object_type . '_rep');
        my $count    = $form->param_value($object_type . '_element_count');

        my @types = @{ $cached_attributes{ $object_type } };
        unless($count)
        {
            $count = scalar @types;
            $repeater->repeat($count);
        }

        unless(@types)
        {
            $fieldset->element({
                type    => 'Block',
                tag     => 'p',
                content => 'No attributes have been defined.',
            });
        }
    }

    if($form->submitted_and_valid)
    {
        foreach my $object_type (qw/page attachment asset/) {
            # FIXME: this will go hinky
            my $type_rs = $site->${\ ($object_type . '_attributes')};

            my @types = @{ $cached_attributes{ $object_type } };
            my $count   = @types;
            my $name    = $form->param_value($object_type.'_name');
            my $code    = $form->param_value($object_type.'_code');
            my $type    = $form->param_value($object_type.'_type');
            
            if($name && $code)
            {
                my $source = { 
                    name    => $name,
                    code    => $code,
                    type    => $type,
                    site_id => $site->id,
                };
                
                if ($object_type eq 'path') {
                    $source->{cascade} = $form->param_value($object_type.'_cascade') || 0;
                }
                
                $type_rs->create($source);
            }
            
            for(my $i = 1; $i <= $count; $i++)
            {
                my $id          = $form->param_value($object_type."_id_$i");
                my $delete_flag = $form->param_value($object_type."_delete_$i");
                my $source      = $type_rs->find({ id => $id });

                if($source->site->id == $site->id)
                {
                    if ($delete_flag)
                    {
                        $source->update({ active => 0 });
                    }
                    else
                    {
                        # only name editable
                        $source->name($form->param_value($object_type."_name_$i"));
                        $source->cascade($form->param_value($object_type."_cascade_$i") || 0) if ($object_type eq 'path');
                        $source->update;
                    }
                } else {
                    # delete is a no-op for a profile attribute.
                    unless($delete_flag)
                    {
                        # clone the attribute.
                        my $data = {
                            name => $form->param_value($object_type."_name_$i"),
                            code => $source->code,
                            type => $source->type,
                            site_id => $site->id,
                        };
                        if($object_type eq 'path')
                        {
                            $data->{cascade} = $object_type."_cascade_$i" || 0;
                        }
                        $type_rs->create($data);
                    }
                }
            }
        }
        
        $c->flash->{status_msg} = 'Saved';
        $c->res->redirect($c->req->uri);
        $c->detach;
    }
    else
    {
        my $defaults;
        
        foreach my $object_type (qw/page attachment asset/) {
            my @types = @{ $cached_attributes{ $object_type } };
            my $count   = scalar @types;
            my $i       = 1;
                              
            for my $type (@types)
            {
                unless($type->site->id == $site->id)
                {
                    my $e = $form->get_all_element($object_type."_delete_$i");
                    $e->parent->remove_element($e);
                }
                $defaults->{$object_type."_id_$i"}   = $type->id;
                $defaults->{$object_type."_name_$i"} = $type->name;
                $defaults->{$object_type."_type_$i"} = $type->type;
                $form->get_all_element({name => $object_type."_name_$i"})->attributes->{title} = $type->code;
                
                if ($object_type eq 'page') {
                    $defaults->{"page_cascade_$i"} = $type->cascade;
                }
                
                my $l = $form->get_all_element($object_type."_link_$i");
                if($type->type && $type->type eq 'select')
                {
                    $l->attributes->{href} = $self->value_link($c, $site->id, $object_type, $type);
                    # FIXME: this could probably go into the defaults.
                    my $text  = $l->value();
                    $defaults->{$object_type."_type_$i"} = $type->type;
                    my $count = $type->field_values->for_site($site)->count;
                    $l->value($text . " ($count)");
                }
                else
                {
                    $l->parent->remove_element($l);
                }
                $i++;
            }
            $defaults->{$object_type. '_element_count'} = $count;
        }

        $defaults->{site_id} = $site->id;
        $form->default_values($defaults);
    }
}

sub value_link
{
    my ($self, $c, $site_id, $object_type, $type) = @_;
    return $c->uri_for($self->action_for('edit_values'), [ $site_id, $object_type, $type->code ]);
}

sub value_chain
    : Chained('/modules/cms/sites/_load_site')
    : PathPart('field-values')
    : CaptureArgs(2)
    : FB11Feature('Attributes - Read Access')
{
    my ($self, $c, $object_type, $code) = @_;
    my $site = $c->stash->{site};
    $self->add_breadcrumb($c, {
        name    => 'Page Attributes',
        url     => $c->uri_for( $c->controller->action_for('index'), [ $site->id ]),
    });
    $c->log->debug("**** $object_type **** $code");
    $c->detach('/not_found') unless $code;
    my $meth = $object_type . '_attributes';
    $c->detach('/not_found') unless $site->can($meth);;
    
    my $value = $site->$meth->active->find({ code => $code });
    $c->detach('/not_found') unless $value;
    
    $c->stash->{value} = $value;

}
    
sub edit_values
    : Chained('value_chain')
    : PathPart('')
    : FB11Form
    : FB11Feature('Attributes - Write Access')
{
    my ($self, $c) = @_;
    my $site       = $c->stash->{site};
    my $prev_link = $c->uri_for($self->action_for('index'), [ $site->id ]);
    if ($c->req->param('cancel')) {
        $c->res->redirect($prev_link);
        $c->detach;
    }
    my $value = $c->stash->{value};

    $self->add_final_crumb($c, $value->code);

    my $type_rs = $value->field_values->for_site($site);
    my @types = $type_rs->all;
    my $form = $c->stash->{form};

    my $fieldset = $form->get_all_element('current_values');
    my $repeater = $form->get_all_element('rep');
    my $count = $form->param_value('element_count');
    unless($count)
    {
        $count = scalar @types;
        $repeater->repeat($count);
        $form->process;
    }
    unless(@types)
    {
        $fieldset->element({
            type    => 'Block',
            tag     => 'p',
            content => 'No values have been setup.',
        });
    }

    if ($c->req->param('cancel')) {
        #$c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $site->id ]));
        $c->detach;
    }

    if($form->submitted_and_valid)
    {
        my $value = $form->param_value('value');
        if($value)
        {
            my $create = {
                value => $value,
                site_id => $site->id
            };
            if (my $pri = $form->param_value("priority")) {
                $create->{priority} = $pri;
            }
            my $source = $type_rs->create($create);
        }
        for(my $i = 1; $i <= $count; $i++)
        {
            my $id = $form->param_value("id_$i");
            my $delete_flag = $form->param_value("delete_$i");
            my $source = $type_rs->find({ id => $id });
            if($delete_flag)
            {
                $source->delete;
            }
            else
            {
                my $value = $form->param_value("value_$i");
                my $pri   = $form->param_value("priority_$i");
                my $update = { value => $value };
                if ($pri) { $update->{priority} = $pri; }
                $source->update($update);
            }
        }

        $c->flash->{status_msg} = 'Saved';
        $c->res->redirect($c->req->uri);
        $c->detach;
    }
    else
    {
        my $defaults;
        my $i = 1;
        for my $type (@types)
        {
            unless($type->site_id == $site->id)
            {
                my $e = $form->get_all_element("delete_$i");
                $e->parent->remove_element($e);

                $form->get_all_element("value_$i")->attributes({readonly => 'readonly'});
                #$form->get_all_element("priority_$i")->attributes({readonly => 'readonly'});
            }
            $defaults->{"id_$i"} = $type->id;
            $defaults->{"value_$i"} = $type->value;
            if ($type->can('priority')) { $defaults->{"priority_${i}"} = $type->priority }
            $i++;
        }
        $form->default_values($defaults);
    }
}

1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::PageAttributes

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 index

=head2 value_link

=head2 value_chain

=head2 edit_values

=head1 ATTRIBUTES


=cut
