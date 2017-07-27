package OpusVL::CMS::Schema::ResultSet::PageAttributeDetail;
our $VERSION = '65';

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});
with 'OpusVL::CMS::Roles::ResultSetFilter' => { field => 'code' };
sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_

sub active
{
    my $self = shift;
    my $me = $self->current_source_alias;
    return $self->search({ "$me.active" => 1 });
}

1;

