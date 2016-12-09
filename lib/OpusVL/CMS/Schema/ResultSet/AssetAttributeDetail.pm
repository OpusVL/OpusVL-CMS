package OpusVL::CMS::Schema::ResultSet::AssetAttributeDetail;
our $VERSION = '47';

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
with 'OpusVL::CMS::Roles::ResultSetFilter' => { field => 'code' };
sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});

sub active
{
    my $self = shift;
    return $self->search({ active => 1 });
}

sub get_values {
    my ($self, $code) = @_;
    my $res = $self->find({ code => $code });
    return [ $res->field_values->search_rs({ field_id => $res->id })->all ];
}

1;

