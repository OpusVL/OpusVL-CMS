package OpusVL::FB11X::CMS::Form::FormBuilder::NewForm;

use OpusVL::FB11::Plugin::FormHandler;
with 'HTML::FormHandler::TraitFor::Model::DBIC';

has_field name => (
    required => 1,
    element_class => [qw/ field field-name data-text /],
);
has_field redirect => (
    type => 'Select',
    required => 1,
    element_class => [qw/ field field-redirect data-text /],
    label => "Redirect to",
);
has_field mail_from => (
    type => 'Email',
    required => 1,
    element_class => [qw/ field field-mail_from data-email /],
);
has_field mail_to => (
    type => 'Email',
    required => 1,
    element_class => [qw/ field field-mail_to data-email /],
);
has_field ssl => (
    type => 'Checkbox',
    label => "Require SSL?",
    element_class => [qw/ field field-ssl data-boolean /],
);
has_field recaptcha => (
    type => 'Checkbox',
    label => "Enable reCAPTCHA?",
    element_class => [qw/ field field-recaptcha data-boolean /],
);
has_field recaptcha_public_key => (
    element_attr => {
        rel => '[name=recaptcha]',
    },
    element_class => [qw/ enabled-with field field-recaptcha_public_key data-text /],
    required_when => { recaptcha => 1 },
);
has_field recaptcha_private_key => (
    element_attr => {
        rel => '[name=recaptcha]',
    },
    element_class => [qw/ enabled-with field field-recaptcha_private_key data-text /],
    required_when => { recaptcha => 1 },
);

has_block form_data => (
    tag => 'fieldset',
    label => "Form details",
    render_list => [ qw/ name redirect mail_from mail_to ssl
        recaptcha recaptcha_public_key recaptcha_private_key
    / ],
);

has_field forms_fields => (
    type => 'Repeatable',
);
has_field 'forms_fields.id' => (
    type => 'PrimaryKey',
);
has_field 'forms_fields.label' => (
    element_class => [qw/ field field-label data-text /],
);
has_field 'forms_fields.type' => (
    type => 'Select',
    label_column => 'type',
    element_class => [qw/ field field-type data-enum /],
);
has_field 'forms_fields.constraint' => (
    type => 'Select',
    label_column => 'select_box_name',
    empty_select => '',
    element_class => [qw/ field field-constraint data-enum /],
);
has_field 'forms_fields.options' => (
    type => 'Repeatable',
    num_extra => 1,
);
has_field 'forms_fields.options.contains' => (
    do_label => 0,
    element_class => [qw/ field field-option data-text /],
);

# Provided by controller
has_field 'forms_fields.name' => (
    required=>1,
);
has_field 'forms_fields.priority' => (
);

has_field submit_button => (
    type => 'Submit',
    element_class => ['btn','btn-primary'],
);

1;
