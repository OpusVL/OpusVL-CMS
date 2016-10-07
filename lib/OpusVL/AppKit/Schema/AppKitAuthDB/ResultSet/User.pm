package OpusVL::AppKit::Schema::AppKitAuthDB::ResultSet::User;
our $VERSION = '35';

use Moose;
extends 'DBIx::Class::ResultSet';

__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});

sub initdb
{
    my $self = shift;

}

1;

=head1 NAME

OpusVL::AppKit::Schema::AppKitAuthDB::ResultSet::User

=head1 DESCRIPTION

=head1 METHODS

=head2 initdb

=head1 ATTRIBUTES


=cut
