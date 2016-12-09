package OpusVL::AppKit::Schema::AppKitAuthDB::ResultSet::Role;
our $VERSION = '46';

use Moose;
extends 'DBIx::Class::ResultSet';
use List::MoreUtils qw/uniq/;
with 'OpusVL::AppKit::RolesFor::UserSetupResultSet';

sub initdb
{
    my $self = shift;

    my $permissions = {
        "Aliases/Aliases" => ["Admin"],
        "AppKit/Home Page" => ["Admin"],
        "AppKit/Password Change" => ["Admin"],
        "AppKit/Role Administration" => ["Admin"],
        "AppKit/User Administration" => ["Admin"],
        "AppKit/User Password Administration" => ["Admin"],
        "Assets/Assets - Read Access" => ["Admin"],
        "Assets/Assets - Write Access" => ["Admin"],
        "CMS/Ajax calls" => ["Admin"],
        "CMS/CMS Home" => ["Admin"],
        "CMS/Portlets" => ["Admin"],
        "CMS/Redirect URL" => ["Admin"],
        "CMS/Validate Site" => ["Admin"],
        "Domains/Domains - Read Access" => ["Admin"],
        "Domains/Domains - Write Access" => ["Admin"],
        "Elements/Elements - Read Access" => ["Admin"],
        "Elements/Elements - Write Access" => ["Admin"],
        "Form Builder/Forms - Read Access" => ["Admin"],
        "Form Builder/Forms - Write Access" => ["Admin"],
        "Form Builder/Portlets" => ["Admin"],
        "Page Attributes/Attributes - Read Access" => ["Admin"],
        "Page Attributes/Attributes - Write Access" => ["Admin"],
        "Pages/Blogs" => ["Admin"],
        "Pages/Pages - Read Access" => ["Admin"],
        "Pages/Pages - Write Access" => ["Admin"],
        "Search/Search box" => ["Admin"],
        "Sites/Site - Read Access" => ["Admin"],
        "Sites/Site - Write Access" => ["Admin"],
        "Templates/Templates - Read Access" => ["Admin"],
        "Templates/Templates - Write Access" => ["Admin"],
        "User Access/Allow users to modify elements" => ["Admin"],
        "User Access/Allow users to modify pages" => ["Admin"],
        "User Access/Manage Users" => ["Admin"],
    };
    my $role_permissions = {
    };
    my $users = [
        { 
            username => 'appkitadmin',
            password => 'password',
            email => 'admin@opusvl.com',
            name => 'AppKit Admin',
            tel => '01788 550 302',
            roles => [ 'Admin' ],
        },
    ];
    $self->setup_users({
        users => $users, 
        feature_permissions => $permissions,
        role_permissions => $role_permissions,
    });
    my $admin = $self->find({ role => 'Admin' });
    $admin->can_change_any_role(1);
}

1;

=head1 NAME

OpusVL::AppKit::Schema::AppKitAuthDB::ResultSet::Role

=head1 DESCRIPTION

=head1 METHODS

=head2 initdb

=head1 ATTRIBUTES


=cut
