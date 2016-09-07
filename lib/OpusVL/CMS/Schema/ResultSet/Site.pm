package OpusVL::CMS::Schema::ResultSet::Site;
our $VERSION = '25';

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});

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

sub as_formfu_options
{
    my $self = shift;
    my @options = map {[ $_->id => $_->name ]} $self->all;
    return \@options;
}

sub expand_site_ids
{
    my $self = shift;
    my $site_id = shift;
    my $site = $self->find({ id => $site_id });
    my @sites;
    push @sites, $site_id;
    if($site->profile_site)
    {
        push @sites, $site->profile_site;
    }
    return \@sites;
}

1;
