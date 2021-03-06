use utf8;
package OpusVL::CMS::Schema::Result::Form;
our $VERSION = '68';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Form

=cut

use Moose;
use feature 'switch';
use experimental 'switch';

use Try::Tiny;
use HTML::Element;
use Switch::Plain;
use List::Gather;
use Scalar::IfDefined qw/$ifdef/;

extends 'DBIx::Class::Core';

use Sort::Naturally;
use Captcha::noCAPTCHA;
use Email::MIME;
use Email::Sender::Simple qw(sendmail);

has 'recaptcha_object' => (
    is      => 'rw',
    lazy    => 1,
    default => sub { Captcha::noCAPTCHA->new({
        site_key => $_[0]->recaptcha_public_key,
        secret_key => $_[0]->recaptcha_private_key,
    })}
);

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<forms>

=cut

__PACKAGE__->table("forms");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'forms_id_seq'

=head2 site_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 owner_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "forms_id_seq",
  },
  "site_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "owner_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "mail_to",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "mail_from",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "recaptcha",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "recaptcha_public_key",
  {
    label => "ReCAPTCHA site key",
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "recaptcha_private_key",
  {
    label => "ReCAPTCHA secret key",
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "ssl",
  {
    data_type => "boolean",
    is_nullable => 1,
  },
  redirect_id => {
    data_type => 'integer',
    is_nullable => 1,
  }
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
    form_name_site_id => [ 'name', 'site_id' ]
);

=head1 RELATIONS

=head2 forms_fields

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::FormsField>

=cut

__PACKAGE__->has_many(
  "forms_fields",
  "OpusVL::CMS::Schema::Result::FormsField",
  { "foreign.form_id" => "self.id" },
  { 
    cascade_copy => 1,
    cascade_delete => 0,
    order_by => { -asc => 'priority' }
  },
);

=head2 forms_submit_fields

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::FormsSubmitField>

=cut

__PACKAGE__->has_many(
  "forms_submit_fields",
  "OpusVL::CMS::Schema::Result::FormsSubmitField",
  { "foreign.form_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
);

=head2 owner

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "owner",
  "OpusVL::CMS::Schema::Result::User",
  { id => "owner_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 site

Type: belongs_to

Related object: L<OpusVL::CMS::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
  "site",
  "OpusVL::CMS::Schema::Result::Site",
  { id => "site_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 redirect

A L<OpusVL::CMS::Schema::Result::Page> the form should redirect to.

=cut

__PACKAGE__->belongs_to(
    redirect_page => 'OpusVL::CMS::Schema::Result::Page', 'redirect_id'
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-12-19 14:22:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZAqjnYC9B9vZhqJ99NuZAA

sub field {
    my ($self, $name, $options) = @_;
    $options //= {};
    my $build_row = '';
    if (my $field = $self->forms_fields->search({ name => $name })->first) {
        my $name;
        my $constraint = '';
        if ($field->constraint) {
            $constraint = $field->constraint->type;
        }

        my $label = $field->label; 

        for ($field->type->type) {
            $name = $field->name; 
            my $label_id = lc $label;
            $label_id =~ s/\W+/-/g;
            my $row;
            my @required;
            my %label_attr = ( for => $label_id );

            if ($constraint eq 'required') {
                @required = (required => 'required');
                $label_attr{class} = "required";
            }

            if (/Text$/) {
                $row = [
                    div => { class => 'form-group' },
                    [ label => \%label_attr, $label ],
                    [ input => {
                        class => 'form-control',
                        id => $label_id,
                        type => 'text',
                        value => '',
                        name => $name,
                        @required
                    }]
                ];
            }
            elsif (/Textarea$/) {
                $row = [
                    div => { class => 'form-group' },
                    [ label => \%label_attr, $label ],
                    [ textarea => {
                        class => 'form-control',
                        id => $label_id,
                        name => $name,
                        @required
                    }]
                ];
            }
            elsif (/Checkbox/) {
                $row = [
                    div => { class => 'checkbox' },
                    [
                        label => \%label_attr,
                        [
                            input => {
                                type => 'checkbox',
                                id => $label_id,
                                name => $name,
                                @required
                            }
                        ],
                        $label
                    ]
                ];
            }
            elsif (/Select/) {
                my $fields = $field->fields;
                $row = [
                    div => { class => 'form-group' },
                    [ label => \%label_attr, $label ],
                    [ 
                        select => {
                            class => 'form-control',
                            id => $label_id,
                            name => $name,
                            @required
                        },
                        [
                            gather {
                                for my $opt (nsort split /\*,\*/, $fields) {
                                    my ($name, $val) = split /\*!\*/, $opt;
                                    take [ option => { name => $name }, $val ];
                                }
                            }
                        ]
                    ]
                ];
            }
            elsif (/Submit/) {
                if ($self->recaptcha) {
                    try {
                        $build_row .= $self->recaptcha_object->html;
                    }
                    catch {
                        warn $_;
                    }
                }
                $row = [
                    div => { class => 'form-group' },
                    [
                        button => {
                            class => 'btn btn-primary',
                            type => 'submit',
                            name => $name,
                            value => $name,
                        },
                        $label
                    ]
                ];
            }
            
            $build_row .= HTML::Element->new_from_lol($row)->as_HTML;
        }
    }
    return $build_row;
}

sub render {
    my $self = shift;
    my $options = shift;
    my $name = $self->name;
    my $html;
    $html .= qq{
                <form method="post" id="contact-form" class="form">
    };

    $html .= '<input type="hidden" name="form_id" value="' . $self->id . '" />';
    
    $options //= {};
    for my $field ($self->forms_fields->search(undef, { order_by => { -asc => 'priority' } })->all) {
        $html .= $self->field($field->name);
    }
    $html .= "</form>";

    return $html;
}

sub save {
    my ($self, $params) = @_;
    
    foreach my $param (keys %$params) {
        # is a valid field in the form?
        # if so, then save the content
        if (my $field = $self->forms_fields->search({ name => $param })->first) {
            my $content = $field->create_related('forms_contents', { content => $params->{$param} });
        }
    }

    return $self;
}

sub email {
    my $self   = shift;
    my $body = "A new form has been submitted on " . DateTime->now->dmy('/') . "\n\n";
    for my $field ($self->forms_fields->all) {
        if (my $content = $field->forms_contents->search(undef, { order_by => { -desc => 'id' } })->first) {
            $body .= $field->label . ": " . $content->content . "\n";
        }   
    }
    my $message = Email::MIME->create(
        header_str => [
          From    => $self->mail_from||'formbuilder@example.com',
          To      =>  $self->mail_to||$self->owner->email,
          Subject => 'Form submitted',
        ],
        attributes => {
          encoding => 'quoted-printable',
          charset  => 'UTF-8',
        },
        body_str => $body,
    );

    # send the message
    sendmail($message);
}

sub validate {
  my ($self, $params, $remote_addr) = @_;
  my @errors;
  if ($self->recaptcha) {
    my $result = $self->recaptcha_object->verify(
      $params->{'g-recaptcha-response'}, $remote_addr
    );

    push @errors, "Invalid CAPTCHA. Please try again"
      unless $result;
  }
 
  for my $field ($self->forms_fields->all) {
    my $field_name  = $field->name;
    my $field_label = $field->label;
    if (my $const = $field->constraint) {
      sswitch ($const->type) {
        case'required': {
          if (not $params->{$field_name} or $params->{$field_name} eq '') {
            push @errors, "${field_label} must be filled in";
          }
        }
        case 'minimum_length': {
          my $length = $const->value;
          if (not $params->{$field_name} or length($params->{$field_name}) < $length) {
            push @errors,
              "${field_label} can only have a minimum length of $length characters";
          }
        }
      }
    }
  }

  return @errors;
}

# Hacky. We want to support the legacy way of defining redirect pages, which is
# to give the form a submit button (see FormsSubmitField) and put the redirect
# page on that. That's silly, so now the form has its own redirect_id and
# redirect_page, but if we've not saved the form recently, we fall back.

around redirect_page => sub {
    my $orig = shift;
    my $self = shift;

    my $result = $self->$orig(@_);

    return $result if $result;

    return $self->legacy_submit_field->$ifdef('redirect');
};

# Hacky. This allows the form builder form to read the value of redirect out of
# the legacy submit button stuff, but to write it to the new redirect_id that
# the form object has.
sub redirect {
    my $self = shift;
    if (my $newval = shift) {
        return $self->set_column( redirect_id => $newval );
    }

    return $self->redirect_page->$ifdef('id');
}

sub fields {
  my $self = shift;
  my @fields = $self->search_related('forms_fields', undef, { order_by => { -asc => 'priority' } })->all;
  return \@fields;
}

sub submit_button {
    my $self = shift;
    return $self->forms_fields->search(
        {
            'type.type' => 'Submit'
        },
        {
            join => 'type'
        })
        ->first;
}

sub legacy_submit_field {
  my $self = shift;
  return $self->forms_submit_fields->first;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
