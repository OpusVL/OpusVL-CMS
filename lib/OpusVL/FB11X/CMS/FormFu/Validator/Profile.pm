package OpusVL::FB11X::CMS::FormFu::Validator::Profile;

use Moose;

extends 'HTML::FormFu::Validator';

sub validate_value {

    my ($self, $value, $params) = @_;

    return 1 unless $value;
    if($params->{is_profile} && $params->{site_profile})
    {
        die HTML::FormFu::Exception::Validator->new({message => "Site can not be a profile and use a profile at the same time."}) 
    }
    # ensure we only have 1 or the other.
    return 1;
}

1;

=head1 NAME

OpusVL::FB11X::CMS::FormFu::Validator::Profile

=head1 DESCRIPTION

=head1 METHODS

=head2 validate_value

=head1 ATTRIBUTES


=cut
