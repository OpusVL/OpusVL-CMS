package OpusVL::FB11X::CMSView;
use Moose::Role;
use CatalystX::InjectComponent;
use File::ShareDir qw/module_dir/;
use namespace::autoclean;
use HTML::Entities;
use Try::Tiny;
use experimental 'smartmatch';

with 'OpusVL::FB11::RolesFor::Plugin';

our $VERSION = '0.039';

after 'setup_components' => sub {
    my $class = shift;
   
    $class->add_paths(__PACKAGE__);
    
    # .. inject your components here ..
    CatalystX::InjectComponent->inject(
        into      => $class,
        component => 'OpusVL::FB11X::CMSView::Model::CMS',
        as        => 'Model::CMS'
    );

    CatalystX::InjectComponent->inject(
        into      => $class,
        component => 'OpusVL::FB11X::CMSView::View::CMS',
        as        => 'View::CMS::Page'
    );

    CatalystX::InjectComponent->inject(
        into      => $class,
        component => 'OpusVL::FB11X::CMSView::View::CMS',
        as        => 'View::CMS::Element'
    );

    CatalystX::InjectComponent->inject(
        into      => $class,
        component => 'OpusVL::FB11X::CMSView::View::Thumbnail',
        as        => 'View::CMS::Thumbnail'
    );
    my $view = $class->view('CMS::Page');
    my $template_path = module_dir(__PACKAGE__) . '/root/templates';
    unless ($view->include_path ~~ $template_path) {
        push @{$view->include_path}, $template_path;
    }
    $class->config->{clickjack_same_origin} = 1;
};

sub finalize_error {
    my $c = shift;

    # NOTE: catalyst appears to have logged the error already by this point.
    # my $error = join '<br/> ', map { encode_entities($_) } @{ $c->error };
    # $error ||= 'No output';
    # $c->log->error($error);

	$c->response->status(500);
    $c->stash->{template} = $c->config->{custom_error_template} || '500.tt';
    try
    {
        my $host = $c->req->uri->host;
        my $root = $c->controller('Root');
        my $site = $root->_get_site($c, { host => $host });
        if($site)
        {
            my $pages = $site->pages;
            my $page = $pages->published->find({url => '/500'});
            if($page)
            {
                $root->render_page($c, $page, $host);
            }
        }
    };
    $c->view('CMS::Page')->process($c);
}

1;

=head1 NAME

OpusVL::FB11X::CMSView - CMS front end

=head1 DESCRIPTION

=head1 METHODS

=head2 finalize_error

The CMS view overrides this method to provide a custom error page.

First it looks for a page on the site with the url /500.  If that can not be found
it checks to see if there is a template file defined in the custom_error_template
config setting.  If not it reverts to using it's standard 500.tt provided with this
module.

If you provide your own template using the custom_error_template you need
to be aware that the TT is setup to look in the root directory rather than 
root/templates.  This is because the usual directory search path hookup isn't performed
since it's a different view to the usual FB11TT view.

Catalyst logs the real error as an [error] message so this hook doesn't attempt
to log the error again.

=head1 BUGS

=cut

