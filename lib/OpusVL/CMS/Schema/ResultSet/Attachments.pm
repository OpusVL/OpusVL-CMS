package OpusVL::CMS::Schema::ResultSet::Attachments;

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Attachments -

=head1 DESCRIPTION

Accessors for the Attachments of the SimpleCMS

=head1 METHODS

published - returns all publiched (live) attachments.

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

=head2 published

Returns all published (i.e. live) attachments

=cut

sub published
{
	my $self = shift;
    
    return $self->search({ status => 'published' });
}

##
1;
