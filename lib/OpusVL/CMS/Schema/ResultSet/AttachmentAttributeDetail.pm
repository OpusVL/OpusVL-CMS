package OpusVL::CMS::Schema::ResultSet::AttachmentAttributeDetail;

use Moose;
extends 'DBIx::Class::ResultSet';
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});

sub active
{
    my $self = shift;
    return $self->search({ active => 1 });
}


1;

