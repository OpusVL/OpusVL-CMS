use utf8;
package OpusVL::CMS::Schema::Result::Form;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpusVL::CMS::Schema::Result::Form

=cut

use Moose;
use feature 'switch';
use experimental 'switch';

extends 'DBIx::Class::Core';

use Sort::Naturally;
use Captcha::reCAPTCHA;
use Email::MIME;
use Email::Sender::Simple qw(sendmail);

has 'recaptcha_object' => (
    is      => 'rw',
    default => sub { Captcha::reCAPTCHA->new }
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
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "recaptcha_private_key",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "ssl",
  {
    data_type => "boolean",
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 forms_fields

Type: has_many

Related object: L<OpusVL::CMS::Schema::Result::FormsField>

=cut

__PACKAGE__->has_many(
  "forms_fields",
  "OpusVL::CMS::Schema::Result::FormsField",
  { "foreign.form_id" => "self.id" },
  { cascade_copy => 1, cascade_delete => 0 },
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


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-12-19 14:22:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZAqjnYC9B9vZhqJ99NuZAA

sub field {
    my ($self, $name, $options) = @_;
    $options //= {};
    my $build_row;
    if (my $field = $self->forms_fields->search({ name => $name })->first) {
        my $name;
        my $constraint;
        if ($field->constraint) {
            $constraint = $field->constraint->constraint->type;
        }

        my $label = $field->label; 

        for ($field->type->type) {
            $name = $field->name; 
            my $label_id = $label;
            $label_id =~ s/\W+//g;
            if (/Text$/) {
                $build_row .= q{<div class="form-group">};
                $build_row .= qq{<label for="${label_id}">${label}</label>};
                $build_row .= qq{<input class="form-control" id="${label_id} type="text" value="" name="${name}">};
                $build_row .= q{</div>};
            }
            
            elsif (/Textarea$/) {
                $build_row .= q{<div class="form-group">};
                $build_row .= qq{<label for="${label_id}">${label}</label>};
                $build_row .= qq{<textarea class="form-control" id="${label_id}" name="${name}"></textarea>};                               
                $build_row .= q{</div>};                                                                                     
            }

            elsif (/Checkbox/) {
                $build_row .= q{<div class="checkbox">};
                $build_row .= qq{<label>};
                $build_row .= qq{<input type="checkbox" name="$name"> ${label}};
                $build_row .= "</label></div>";
            }
            
            elsif (/Select/) {
                my $fields = $field->fields;
                $build_row .= q{<div class="form-group">};
                $build_row .= qq{<label for="${label_id}">${label}</label>};
                $build_row .= qq{<select id="${label_id}" name="${name}" class="form-control">};
                #my @opts    = sort { $a cmp $b } split /\*,\*/, $fields;
                my @opts    = nsort split /\*,\*/, $fields;
                for my $opt (@opts) {
                    my ($name, $val) = split /\*!\*/, $opt;
                    $build_row .= qq{<option value="$val">$name</option>};
                }
                $build_row .= q{</select></div>}; 
            }

            elsif (/Submit/) {
                if ($self->recaptcha) {
                    $self->recaptcha_object( Captcha::reCAPTCHA->new );
                    if ($self->ssl) {
                        $build_row .= $self->recaptcha_object->get_html(
                            $self->recaptcha_public_key,
                            undef,
                            1,
                            {}
                        );
                    }
                    else {
                        $build_row .= $self->recaptcha_object->get_html( $self->recaptcha_public_key );
                    }
                }
                
                $build_row .= qq{
                    <div class="form-group">
                        <button class="btn btn-primary" type="submit" name="${name}" value="${name}">${name}</button>
                    </div>
                };
            }

            return $build_row;
        }
    }
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
    $self->recaptcha_object( Captcha::reCAPTCHA->new );
    my $result = $self->recaptcha_object->check_answer(
     $self->recaptcha_private_key, $remote_addr,
      $params->{recaptcha_challenge_field}, $params->{recaptcha_response_field}
    );
   
    if ($result->{error} and $result->{error} eq "invalid-site-private-key") {
      push @errors,
        "The private key sent was invalid";
    }
    else {
      if (not $result->{is_valid}) {
        push @errors,
          "You did not enter the words in the reCAPTCHA correctly";
      }
    }
  }
 
  for my $field ($self->forms_fields->all) {
    my $field_name  = $field->name;
    my $field_label = $field->label;
    if (my $const = $field->constraint) {
      given ($const->constraint->type) {
        when ('required') {
          if (not $params->{$field_name} or $params->{$field_name} eq '') {
            push @errors,
              "${field_label} must be filled in";
          }
        }
        when ('minimum_length') {
          my $length = $const->constraint->value;
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

sub redirect_page {
  my $self   = shift;
  my $submit = $self->forms_submit_fields->first;
  return $submit ? $submit->redirect : undef;
}

sub fields {
  my $self = shift;
  my @fields = $self->search_related('forms_fields', undef, { order_by => { -asc => 'priority' } })->all;
  return \@fields;
}

sub submit_button {
  my $self = shift;
  return $self->forms_submit_fields->first;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
