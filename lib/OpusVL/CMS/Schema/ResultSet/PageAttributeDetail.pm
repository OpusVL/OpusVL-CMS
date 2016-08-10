package OpusVL::CMS::Schema::ResultSet::PageAttributeDetail;
our $VERSION = '21';

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});
with 'OpusVL::CMS::Roles::ResultSetFilter' => { field => 'code' };
sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_

sub active
{
    my $self = shift;
    return $self->search({ active => 1 });
}

1;

