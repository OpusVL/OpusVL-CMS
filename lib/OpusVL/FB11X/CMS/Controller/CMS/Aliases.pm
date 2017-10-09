package OpusVL::FB11X::CMS::Controller::CMS::Aliases;

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with "OpusVL::FB11::FormFu::RoleFor::Controller";
with 'OpusVL::FB11::RolesFor::Controller::UI';
 
__PACKAGE__->config
(
    fb11_name                 => 'Aliases',
    fb11_icon                 => '/static/modules/cms/cms-icon-small.png',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    #fb11_js                     => ['/static/js/cms.js', '/static/js/nicEdit.js', '/static/js/src/addElement/addElement.js'],
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_shared_module        => 'CMS',
    fb11_css                  => ['/static/css/cms.css'],
);

 
#-------------------------------------------------------------------------------

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{section} = 'Redirects';
 
    push @{ $c->stash->{breadcrumbs} }, {
        name    => 'Redirects',
        url     => $c->uri_for( $c->controller->action_for('index'))
    };
}


#-------------------------------------------------------------------------------

sub index :Path :Args(0) :FB11Feature('Aliases') {
    my ($self, $c) = @_;
    
    $c->stash->{aliases} = [$c->model('CMS::Aliases')->all];
}


#-------------------------------------------------------------------------------

1;
=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::Aliases

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 index

=head1 ATTRIBUTES


=cut
