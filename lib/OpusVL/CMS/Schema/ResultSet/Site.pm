package OpusVL::CMS::Schema::ResultSet::Site;
our $VERSION = '2';

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

sub real_sites
{
	my $self = shift;

    return $self->search({ template => 0 });
}

sub active
{
    my $self = shift;
    return $self->search({ status => 'active' });
}

sub profile_sites
{
	my $self = shift;

    return $self->search({ template => 1 });
}

sub sort_by_name
{
    my $self = shift;
    return $self->search(undef, { order_by => 'name' });
}

1;
