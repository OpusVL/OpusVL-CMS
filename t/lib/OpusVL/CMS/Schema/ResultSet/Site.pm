package OpusVL::CMS::Schema::ResultSet::Site;

use Moose;
extends 'DBIx::Class::ResultSet';
with "OpusVL::AppKit::RolesFor::Schema::DataInitialisation";

sub initdb {
    my $self = shift;
    $self->create({
        name => "TestApp",
        status => 'active',
    });
}

1;
