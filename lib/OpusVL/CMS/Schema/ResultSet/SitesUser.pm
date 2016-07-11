package OpusVL::CMS::Schema::ResultSet::SitesUser;

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
    while(my $site = $self->next) {
        push @pages, $site->page;
    }

    return @pages;
}

##

sub sites {
  my ($self, $user_id) = @_;
  my @sites;

  for my $site ($self->search({ user_id => $user_id })->all) {
    push @sites, $site->site;
  }

  return @sites;
}

1;
