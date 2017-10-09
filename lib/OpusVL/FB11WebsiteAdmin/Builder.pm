package OpusVL::FB11WebsiteAdmin::Builder;

use Moose;
extends 'OpusVL::FB11::Builder';

override _build_superclasses => sub
{
  return [ 'OpusVL::FB11' ]
};

override _build_plugins => sub {
    my $plugins = super(); # Get what CatalystX::AppBuilder gives you

    my @filtered = grep { !/FastMmap/ } @$plugins;
    push @filtered, qw(
        +OpusVL::FB11X::CMS
    );

    return \@filtered;
};

override _build_config => sub {
    my $self   = shift;
    my $config = super(); # Get what CatalystX::AppBuilder gives you

    # point the FB11Auth Model to the correct DB file....
    $config->{'Model::FB11AuthDB'} = 
    {
        schema_class => 'OpusVL::FB11::Schema::FB11AuthDB',
        connect_info => [
            'dbi:SQLite:' . $self->appname->path_to('root','fb11-auth.db'),
        ],
    };

    # .. add static dir into the config for Static::Simple..
    my $static_dirs = $config->{static}->{include_path};
    unshift(@$static_dirs, $self->appname->path_to('root'));
    $config->{static}->{include_path} = $static_dirs;
    
    $config->{application_name} = 'FB11 TestApp';
    $config->{application_style} = 1;
    $config->{default_view}     = 'FB11TT';
    
    return $config;
};

1;

=head1 NAME

OpusVL::FB11WebsiteAdmin::Builder - Core of the website admin application.

=head1 DESCRIPTION

=head1 METHODS

=head1 ATTRIBUTES


=cut
