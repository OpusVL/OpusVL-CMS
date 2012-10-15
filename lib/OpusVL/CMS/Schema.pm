package OpusVL::CMS::Schema;

###########################################################################################

=head1 NAME

OpusVL::CMS::Schema - 

=head1 DESCRIPTION

Base CMS schema

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

Jon Allen (JJ) - jj@opusvl.com

=head1 COPYRIGHT & LICENSE

Copyright (C) 2012 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided
with the development project.

=cut

###########################################################################################

use DBIx::Class::Schema;
use Moose;
BEGIN { extends qw/DBIx::Class::Schema/; }
__PACKAGE__->load_namespaces;

with 'OpusVL::AppKit::RolesFor::Schema::AppKitAuthDB';
__PACKAGE__->merge_authdb;

=head1 METHODS
 
=head2 deploy_with_data
 
Does a deploy then populates default data from the resultsets using the initial_data method.
 
    perl -MList::API::Schema -I lib -e "List::API::Schema->connect('dbi:SQLite:t/data/test.db')->deploy_with_data"
 
=head1 AUTHOR
 
Colin Newell, C<< <colin.newell at gmail.com> >>
 
=cut

sub deploy_with_data {
    my $self = shift;
    $self->deploy;
    for my $resultset ($self->sources) {
        my $rs = $self->resultset($resultset);
        $rs->initial_data if $rs->can('initial_data');
    }
    return $self;
}

__PACKAGE__->meta->make_immutable;
##
1;
