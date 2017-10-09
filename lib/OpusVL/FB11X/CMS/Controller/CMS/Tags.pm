package OpusVL::FB11X::CMS::Controller::CMS::Tags;

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';
 
__PACKAGE__->config
(
    fb11_name                 => 'CMS',
    fb11_icon                 => '/static/modules/cms/cms-icon-small.png',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    # fb11_method_group         => 'Extension A',
    # fb11_method_group_order   => 2,
    fb11_shared_module        => 'CMS',
    fb11_css                  => ['/static/css/cms.css'],
);

1;
=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::Tags

=head1 DESCRIPTION

I have no idea what this is for

=head1 METHODS

=head1 ATTRIBUTES


=cut
