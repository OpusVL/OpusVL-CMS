package OpusVL::CMS::Schema::ResultSet::SitesUser;
our $VERSION = '7';

=head1 NAME

OpusVL::CMS::Schema::ResultSet::SitesUser -

=head1 DESCRIPTION

Accessors for the SitesUser of the CMS

=head1 METHODS

published - returns all published (live) elements

=head1 BUGS

=cut
###########################################################################################

use DBIx::Class::ResultSet;
use Moose;
extends 'DBIx::Class::ResultSet';

sub pages {
    # FIXME: This could be done using DBIx::Class natively..
    my $self = shift;
    my @pages;
    # WAT?
    while(my $site = $self->next) {
        push @pages, $site->page;
    }

    return @pages;
}

##

sub sites 
{
    my $self = shift;
    return $self->sites_rs(@_)->all;
}

sub sites_rs
{
    my ($self, $user_id) = @_;
    return $self->search({ user_id => $user_id })->search_related('site');
}

sub real_sites
{
    my ($self, $user_id) = @_;
    return $self->sites_rs($user_id)->real_sites;
}

sub profile_sites
{
    my ($self, $user_id) = @_;
    return $self->sites_rs($user_id)->profile_sites;
}


1;
