package OpusVL::FB11Website::Builder;

use Moose;
use File::ShareDir;
use Try::Tiny;
extends 'OpusVL::FB11::Builder';

override _build_superclasses => sub { [ 'OpusVL::FB11' ] };

override _build_plugins => sub {
    my $plugins = super();

    my @filtered = grep { !/FastMmap/ } @$plugins;
    push @filtered, qw(
        +OpusVL::FB11X::CMSView
    );

    return \@filtered;
};

override _build_config => sub {
    my $self   = shift;
    my $config = super();

    # point the FB11Auth Model to the correct DB file....
    $config->{'Model::FB11AuthDB'} ||= 
    {
        schema_class => 'OpusVL::FB11::Schema::FB11AuthDB',
        connect_info => [
          'dbi:SQLite:' . $self->appname->path_to('root','fb11-auth.db'),
        ],
    };

    my $sharedir = try {
        File::ShareDir::module_dir($self->appname);
    }
    catch {
        undef
    };

    if ($sharedir) {
        # .. add static dir into the config for Static::Simple..
        my $static_dirs = $config->{'Plugin::Static::Simple'}->{include_path} // [];
        unshift(@$static_dirs, $sharedir . '/root');
        $config->{'Plugin::Static::Simple'}->{include_path} = $static_dirs;
    }    

    # .. allow access regardless of ACL rules...
    # $config->{'fb11_can_access_actionpaths'} = ['custom/custom'];

    # DEBUGIN!!!!
    #$config->{'fb11_can_access_everything'} = 1;
    
    $config->{application_name} = 'FB11 TestApp';
    $config->{default_view}     = 'FB11TT';
    
    return $config;
};

1;

=head1 NAME

OpusVL::FB11Website::Builder

=head1 DESCRIPTION

=head1 METHODS

=head1 ATTRIBUTES


=head1 LICENSE AND COPYRIGHT

Copyright 2015 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut
