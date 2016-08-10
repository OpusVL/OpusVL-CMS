package OpusVL::CMS::Schema::ResultSet::Alias;
our $VERSION = '19';

use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

sub BUILDARGS { $_[2] };

sub find_redirect
{
    my $self = shift;
    my $site = shift;
    my $url = shift;
    my $alias = $self->search({
        'me.url' => '/'.$url,
        'page.site' => $site->id,
    }, {
        join => ['page'],
    })->first;
    return $alias;
}

__PACKAGE__->meta->make_immutable;

1;
