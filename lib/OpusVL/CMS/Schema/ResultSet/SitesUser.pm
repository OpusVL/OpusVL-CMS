package OpusVL::CMS::Schema::ResultSet::SitesUser;

=head1 NAME

OpusVL::CMS::Schema::ResultSet::SitesUser -

=head1 DESCRIPTION

Accessors for the SitesUser of the CMS

=head1 METHODS

published - returns all published (live) elements

=head1 BUGS

=head1 AUTHOR

OpusVL - JJ

=head1 COPYRIGHT & LICENSE

Copyright 2012 OpusVL.

This sofware is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut
###########################################################################################

use DBIx::Class::ResultSet;
use Moose;
extends 'DBIx::Class::ResultSet';

##
1;
