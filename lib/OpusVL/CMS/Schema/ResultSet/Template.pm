package OpusVL::CMS::Schema::ResultSet::Template;

=head1 NAME

OpusVL::CMS::Schema::ResultSet::Templates -

=head1 DESCRIPTION

Accessors for the Elements of the CMS

=head1 METHODS

published - returns all published (live) assets

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

=head2 available

Returns all published, or global assets

=cut

sub available {                                                                                                                                                                                         
    my $self = shift;                                                                                                                                                                                   
    return $self->search({                                                                                                                                                                              
        -or => [                                                                                                                                                                                        
            global => 1,                                                                                                                                                                                
        ],                                                                                                                                                                                              
    });                                                                                                                                                                                                 
}

=head2 published

Returns all published (i.e. live) assets

=cut

sub published
{
    my $self = shift;
    
    return $self->search({ status => 'published' });
}

##
1;