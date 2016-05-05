package OpusVL::CMS::Schema::ResultSet::Site;

use Moose;
extends 'DBIx::Class::ResultSet';
with "OpusVL::DBIC::Helper::RolesFor::Schema::DataInitialisation";

sub initdb {
    my $self = shift;
    $self->create({
        name => "TestApp",
        status => 'active',
    });
}

1;
