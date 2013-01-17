#!/usr/bin/env perl

use 5.010;
use lib 'lib';
use OpusVL::CMS::Schema;

if (scalar(@ARGV) < 2) {
    printf(STDERR "Usage: %s <database> <username> <password>\n", $0);
    exit(1);
}

my ($database, $username, $password) = @ARGV;
my $schema = OpusVL::CMS::Schema->connect("dbi:Pg:dbname=${database}", $username, $password);


##
# RESTRICTED USERS
##

my $users  = $schema->resultset('User');
my $params = $schema->resultset('Parameter');
my $param_defaults = $schema->resultset('ParameterDefault');

RESTRICTED: {
    my $restricted_setup = 0;
    while(not $restricted_setup) {

        if ($restricted = $params->find({ parameter => 'Restricted' })) {
            if ($param_defaults->find({ parameter_id => $restricted->id })) {
                say "Restricted all set up";
                $restricted_setup = 1;
            }
            else {
                say "Could not find any default parameters for restricted. Setting it up...";
                $param_defaults->create({
                    data    => 1,
                    parameter_id => $restricted->id
                });
            }
        }
        else {
            say "Could not find the restricted parameter. Setting it up...";
            $params->create({
                data_type => 'boolean',
                parameter => 'Restricted'
            });
        }
    }
}

##
# ATTRIBUTES
##

my $attributes = $schema->resultset('DefaultAttribute');

my %default_attributes = (
    "H1 font"                                       => "",
    "H1 colour"                                     => "",
    "H2 font",                                      => "",
    "H2 colour",                                    => "",
    "Standard button colour"                        => "",
    "Net Affinity Book Now colour"                  => "",
    "Net Affinity Best Rate Guarantee font colour"  => "",
    "Net Affinity Booking ID"                       => 0,
    "Google Analytics Account ID"                   => "",
    "Google Analytics Domain"                       => ".yourhoteldomainexample.com",
    "Vertical Response Form ID"                     => "",
    "Vertical Response Sign Up colour"              => "",
    "Meta Keywords"                                 => "business hotel, corporate rate, cheap hotel",
    "Meta Description"                              => "",
    "Facebook URL"                                  => "",
    "Twitter URL"                                   => "",
    "Quick link colour"                             => "",
    "Links panel colour"                            => "",
);

foreach my $attr (keys %default_attributes) {
    my $attr_code = lc $attr;
    $attr_code      =~ s/\s/_/g;
    $attr_code      =~ s/[^\w\d\s]//g;

    $attributes->find_or_create({
        code    => $attr_code,
        name    => $attr,
        value   => $default_attributes{$attr},
    });
}

say "Finished adding default attributes";
