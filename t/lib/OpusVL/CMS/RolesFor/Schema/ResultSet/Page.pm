package OpusVL::CMS::RolesFor::Schema::ResultSet::Page;

use Moose::Role;

sub initdb {
    my $self = shift;

    $self->create({
        url          => '/',
        status       => 'published',
        template_id  => 1,
        h1           => 'Home',
        breadcrumb   => 'Home',
        title        => 'Home',
        description  => '',
        priority     => 50,
        content_type => 'text/html',
        site         => 1
    });
}

1;
