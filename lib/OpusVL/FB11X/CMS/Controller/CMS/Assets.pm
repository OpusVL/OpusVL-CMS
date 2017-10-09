package OpusVL::FB11X::CMS::Controller::CMS::Assets;

use Switch::Plain;
use Moose;
use namespace::autoclean;
use experimental 'switch';
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';

__PACKAGE__->config
(
    fb11_name                 => 'Assets',
    fb11_icon                 => '/static/modules/cms/cms-icon-small.png',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_shared_module        => 'CMS',
    fb11_css                  => [qw<
        /static/css/cms.css
        /static/css/dropzone.css
        /static/js/codemirror/codemirror.css  
        /static/summernote/summernote.css>],
    fb11_js                   => [qw<
        /static/js/cms.js 
        /static/js/facebox.js
        /static/js/dropzone.js
        /static/js/codemirror/codemirror.js 
        /static/js/codemirror/addon/selection/selection-pointer.js 
        /static/js/codemirror/mode/xml/xml.js 
        /static/js/codemirror/mode/javascript/javascript.js 
        /static/js/codemirror/mode/css/css.js 
        /static/js/codemirror/mode/vbscript/vbscript.js 
        /static/js/codemirror/mode/htmlmixed/htmlmixed.js 
        /static/summernote/summernote.js>],
);

sub _load_asset
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('asset')
    :CaptureArgs(1)
    :FB11Feature('Assets - Read Access')
{
    my ($self, $c, $asset_id) = @_;

    my $asset = $c->model('CMS::Asset')->find({ site => $c->stash->{site}->id, id => $asset_id });

    unless ($asset) {
        $c->flash(error_msg => "No such asset");
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $c->stash->{site}->id ]));
        $c->detach;
    }

    $c->stash( asset => $asset );

}

sub index 
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('assets')
    :Args(0)
    :FB11Feature('Assets - Read Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};

    $c->stash->{assets} = [$site->assets->by_id_desc->published->all];
}

sub new_asset
    :Chained('/modules/cms/sites/_load_site')
    :PathPart('new-asset')
    :Args(0)
    :FB11Form
    :FB11Feature('Assets - Write Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};

    $self->add_final_crumb($c, "New asset");

    my $form = $c->stash->{form};
    if ($form->submitted_and_valid) {
        my $asset = $c->model('CMS::Asset')->create({
            description => $form->param_value('description'),
            mime_type   => $form->param_value('mime_type'),
            filename    => $form->param_value('filename'),
            site        => $site->id,
            priority    => 10,
            slug        => $form->param_value('slug')||'',
        });

        if ($asset->slug eq '') { $asset->update({ slug => $asset->id }); }

        $asset->set_content($form->param_value('content'));

        $c->flash->{status_msg} = 'New asset created';
        $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $site->id ]));
    }

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
        $c->detach;
    }
}

sub edit
    :Chained('_load_asset')
    :PathPart('')
    :Args(0)
    :FB11Form
    :FB11Feature('Assets - Write Access')
{
    my ($self, $c) = @_;
    my $site  = $c->stash->{site};
    my $asset = $c->stash->{asset};

    $self->add_final_crumb($c, "Edit asset");

    if (! $c->can_access($c->controller('Modules::CMS::Pages')->action_for('no_page_restriction'))

    and ! $c->model('CMS::AssetUser')->find({ asset_id => $asset->id, user_id => $c->user->id }))
    {
        $c->detach('/access_denied');
    }

    my $form  = $c->stash->{form};

    if ($asset->mime_type =~ /^text|javascript/) {
        # Add in-line edit control to form
        my $fieldset = $form->get_all_element({name => 'asset_details'});
        $fieldset->element({
            type  => 'Textarea',
            name  => 'content',
            attributes => {id => 'wysiwyg', class => 'code'},
        });

        $form->default_values({
            content => $asset->content,
            slug    => $asset->slug,
            priority => $asset->priority
        });
    }

    $self->construct_attribute_form($c, { type => 'asset', site_id => $site->id });

    my $defaults = {
        description => $asset->description,
        slug        => $asset->slug,
        priority    => $asset->priority,
    };

    my @fields = $c->model('CMS::AssetAttributeDetail')->active->all;
    for my $field (@fields)
    {
        my $value = $asset->attribute($field);
        $defaults->{'global_fields_' . $field->code} = $value;
    }

    $form->default_values($defaults);
    $form->process;

    if ($form->submitted_and_valid) {
        #if ($form->param_value('description') ne $asset->description) {
            $asset->update({
                description => $form->param_value('description'),
                priority => $form->param_value('priority'),
                slug => $form->param_value('slug'), 
            });
        #}

        if (my $file = $c->req->upload('file')) {
            $asset->set_content($file->slurp);

            $asset->update({
                filename  => $file->basename,
                mime_type => $file->type,
            });
        } else {
            if ($form->param_value('content') ne $asset->content) {
                $asset->set_content($form->param_value('content'));
            }
        }

        $self->update_asset_attributes($c, $asset);
        $c->res->redirect($c->req->uri);
    }

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
        $c->detach;
    }
}

sub upload_assets
    :Chained('/modules/cms/sites/_load_site')
    :Args(0)
    :PathPart('upload-assets')
    :FB11Feature('Assets - Write Access')
{
    my ($self, $c) = @_;
    my $site = $c->stash->{site};

    my $asset_rs = $c->model('CMS::Asset');
    if (my $file = $c->req->upload('file')) {
        my $slug = $file->basename;

        if (my $count = $asset_rs->search({ filename => $slug })->count) {
            $slug .= "_$count";
        }
        my $type = $file->type;
        my $asset = $asset_rs->create({ 
            filename    => $file->basename,
            site        => $site->id,
            mime_type   => $file->type,
            slug        => $slug,
            status      => 'published',
        });

        $asset->insert;

        $asset->set_content($file->slurp);
    }
}

sub delete_asset
    :Chained('_load_asset')
    :PathPart('delete')
    :Args(0)
    :FB11Form
    :FB11Feature('Assets - Write Access')
{
    my ($self, $c) = @_;
    my $site  = $c->stash->{site};
    my $asset = $c->stash->{asset};
    my $form  = $c->stash->{form};

    $self->add_final_crumb($c, "Delete asset");

    if ($form->submitted_and_valid) {
        $asset->remove;

        $c->flash->{status_msg} = "Asset deleted";
        $c->res->redirect($c->uri_for($c->controller->action_for('index'), [ $site->id ]));
        $c->detach;
    }

    if ($c->req->param('cancel')) {
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
        $c->detach;
    }
}

sub attributes
    : Chained('/modules/cms/sites/_load_site')
    : PathPart('asset-attributes')
    : Args(0)
    : FB11Form
    : FB11Feature('Assets - Write Access') {

    my ($self, $c) = @_;
    my $site       = $c->stash->{site};

    if ($c->req->body_params->{cancel}) {
        $c->res->redirect($c->uri_for($self->action_for('index'), [ $site->id ]));
        $c->detach;
    }

    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Assets',
        url     => $c->uri_for( $c->controller->action_for('index'), [ $site->id ]),
    };
    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Asset Attributes',
        url     => $c->req->uri,
    };

    my $form    = $c->stash->{form};
    my @attributes    = $c->model('CMS::AssetAttributeDetail')->active->all;
    my $fieldset = $form->get_all_element('current_asset_attributes');
    my $repeater = $form->get_all_element('asset_rep');
    my $count    = $form->param_value('asset_element_count');

    unless($count) {
        $count = scalar @attributes;
        $repeater->repeat($count);
        $form->process;
    }

    unless(@attributes) {
        $fieldset->element({
            type    => 'Block',
            tag     => 'p',
            content => 'No attributes have been defined.',
        });
    }

    if($form->submitted_and_valid) {
        my $type_rs = $c->model('CMS::AssetAttributeDetail');
        my $count   = $type_rs->active->count;
        my $name    = $form->param_value('asset_name');
        my $code    = $form->param_value('asset_code');
        my $type    = $form->param_value('asset_type');

        if($name && $code) {
            my $source = {
                name    => $name,
                code    => $code,
                type    => $type,
                site_id => $site->id,
            };

            $type_rs->create($source);
        }

        for(my $i = 1; $i <= $count; $i++) {
            my $id          = $form->param_value("asset_id_$i");
            my $delete_flag = $form->param_value("asset_delete_$i");
            my $source      = $type_rs->find({ id => $id });

            if ($delete_flag) {
                $source->update({ active => 0 });
            }
            else {
                # only name editable
                $source->name($form->param_value("asset_name_$i"));
                $source->update;
            }
        }

        $c->flash->{status_msg} = 'Saved';
        $c->res->redirect($c->req->uri);
        $c->detach;
    }
    else {
        my $defaults;

        my $type_rs = $c->model('CMS::AssetAttributeDetail');
        my @attributes   = $type_rs->active->all;
        my $count   = scalar @attributes;
        my $i       = 1;
        my %links   = map { $_->parent->repeatable_count => $_ }
                          @{$form->get_all_elements('asset_link')};

        for my $type (@attributes) {
            $defaults->{"asset_id_$i"}   = $type->id;
            $defaults->{"asset_name_$i"} = $type->name;
            $defaults->{"asset_type_$i"} = $type->type;
            $form->get_all_element({name => "asset_name_$i"})->attributes->{title} = $type->code;

            if($type->type eq 'select') {
                $links{$i}->attributes->{href} = $self->value_link($c, $site->id, 'asset', $type);
                my $text  = $links{$i}->content();
                my $count = $type->field_values->count;
                $links{$i}->content($text . " ($count)");
            }
            else {
                my $l = $links{$i};
                $l->parent->remove_element($l);
            }
            $i++;
        }
        $defaults->{'asset_element_count'} = $count;

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
    : PathPart('global-fields')
    : CaptureArgs(2)
    : FB11Feature('Assets - Read Access')
{
    my ($self, $c, $object_type, $code) = @_;
    my $site = $c->stash->{site};
    $self->add_breadcrumb($c, {
        name    => 'Asset Attributes',
        url     => $c->uri_for( $c->controller->action_for('attributes'), [ $site->id ]),
    });

    $c->detach('/not_found') unless $code;

    my $value = $c->model('CMS::AssetAttributeDetail')->active->find({ code => $code });
    $c->detach('/not_found') unless $value;
    $c->stash->{value} = $value;

}

sub edit_values
    : Chained('value_chain')
    : PathPart('edit')
    : FB11Form
    : FB11Feature('Assets - Write Access')
{
    my ($self, $c) = @_;
    my $site       = $c->stash->{site};
    my $prev_link = $c->uri_for($self->action_for('attributes'), [ $site->id ]);
    if ($c->req->param('cancel')) {
        $c->res->redirect($prev_link);
        $c->detach;
    }
    my $value = $c->stash->{value};

    $self->add_final_crumb($c, $value->code);
    my $type_rs = $value->field_values->search(undef, { order_by => { -asc => 'value' } });
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
            my $source = $type_rs->create({
                value => $value,
            });
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
                $source->update({
                    value => $value,
                });
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
            $defaults->{"id_$i"} = $type->id;
            $defaults->{"value_$i"} = $type->value;
            $i++;
        }
        $form->default_values($defaults);
    }
}

sub construct_attribute_form
{
    my ($self, $c, $args) = @_;
    my $model = $c->stash->{site}->asset_attributes;

    my $form = $c->stash->{form};
        my @fields = $model->active->all;
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
                };
                sswitch ($field->type)
                {
                    case 'html': {
                        $details->{type} = 'Textarea';
                        $details->{attributes} = {
                            class => 'wysiwyg',
                        };
                    }
                    case 'number': {
                        $details->{constraints} = { type => 'Number' };
                    }
                    case 'boolean': {
                        $details->{type} = 'Checkbox';
                    }
                    case 'date': {
                        $details->{attributes} = {
                            autocomplete => 'off',
                            class => 'date_picker',
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
                    }
                    case 'select': {
                        $details->{type} = 'Select';
                        $details->{empty_first} = 1;
                        $details->{options} = $field->form_options($c->stash->{site});
                    }
                }
                my $element = $global_fields->element($details);
            }
            $global_fields->remove_element($no_fields);
        }
}


sub update_asset_attributes
{
    my ($self, $c, $page) = @_;

    my $form = $c->stash->{form};
    my @fields = $c->model('CMS::AssetAttributeDetail')->active->all;
    for my $field (@fields)
    {
        my $value = $form->param_value('global_fields_' . $field->code);
        # FIXME: this is a place holder until brad decides to write the code.
        $page->update_attribute($field, $value);
    }

}

sub revert_content
    :Chained('_load_asset')
    :PathPart('revert_content')
    :Args(1)
    :FB11Feature('Assets - Write Access')
    :FB11Form
{
    my ($self, $c, $content_id) = @_;
    my $asset   = $c->stash->{asset};
    my $site    = $c->stash->{site};

    my $content = $asset->history->find($content_id)
        or $c->detach('/not_found');

    if ($c->stash->{form}->submitted_and_valid) {
        $asset->set_content($content->data);

        $c->flash->{status_msg} = "Successfully reverted content.";
        $c->res->redirect($c->uri_for($self->action_for('edit_asset'), [ $site->id, $asset->id ]));
        $c->detach;
    }

    $c->stash->{historical_content} = $content;
}
1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::Assets

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 base

=head2 assets

=head2 index

=head2 upload_asset

=head2 new_asset

=head2 edit_asset

=head2 upload_assets

=head2 delete_asset

=head2 revert_content

=head2 attributes

=head2 value_link

=head2 value_chain

=head2 edit_values

=head2 construct_attribute_form

=head2 update_asset_attributes

=head1 ATTRIBUTES


=cut
