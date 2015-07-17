package OpusVL::CMS::RolesFor::Schema::ResultSet::Template;

use Moose::Role;

sub initdb {
    my $self = shift;

    $self->create({
        name    => "TestApp Main Template",
        site    => 1,
    });
}

1;
