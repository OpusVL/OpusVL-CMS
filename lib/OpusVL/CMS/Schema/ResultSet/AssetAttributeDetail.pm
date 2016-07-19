package OpusVL::CMS::Schema::ResultSet::AssetAttributeDetail;
our $VERSION = '11';

use Moose;
extends 'DBIx::Class::ResultSet';
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

