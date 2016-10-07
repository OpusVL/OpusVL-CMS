package OpusVL::CMS::Schema::ResultSet::AttachmentAttributeDetail;
our $VERSION = '35';

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
with 'OpusVL::CMS::Roles::ResultSetFilter' => { field => 'code' };
__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});

sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_

sub active
{
    my $self = shift;
    my $me = $self->current_source_alias;
    return $self->search({ "$me.active" => 1 });
}

sub get_values {
    my ($self, $code) = @_;
    my $res = $self->find({ code => $code });
    return [ $res->field_values->search_rs({ field_id => $res->id })->all ];
}

1;

