package OpusVL::CMS::Schema::ResultSet::SiteAttribute;

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
with 'OpusVL::CMS::Roles::ResultSetFilter' => { field => 'code' };

sub BUILDARGS { $_[2] } # ::RS::new() expects my ($class, $rsrc, $args) = @_

__PACKAGE__->load_components(qw{Helper::ResultSet::SetOperations});

__PACKAGE__->meta->make_immutable;

1;
