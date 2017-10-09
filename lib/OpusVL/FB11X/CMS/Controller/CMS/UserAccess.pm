package OpusVL::FB11X::CMS::Controller::CMS::UserAccess;

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with 'OpusVL::FB11::RolesFor::Controller::UI';
with "OpusVL::FB11::FormFu::RoleFor::Controller";
 
__PACKAGE__->config(
    fb11_name                 => 'User Access',
    fb11_myclass              => 'OpusVL::FB11X::CMS',
    fb11_method_group         => 'Content Management',
    fb11_method_group_order   => 1,
    fb11_shared_module        => 'CMS',
 );

#----------------------------------------------------------------------------------
# PAGES
#----------------------------------------------------------------------------------

sub page_allow_list :Action :FB11Feature('Allow users to modify pages') { }

sub page_revoke_permission :Local :Args(3) :FB11Feature('Allow users to modify pages') {
	my ($self, $c, $site_id, $page_id, $user_id) = @_;
	if (my $perm = $c->model('CMS::PageUser')->find({ page_id => $page_id, user_id => $user_id })) {
		$perm->delete;
		$c->res->redirect($c->uri_for($c->controller('Modules::CMS::Pages')->action_for('edit_page'), [ $site_id, $page_id ]) . '#tab_users');
		$c->detach;
	}
}

sub page_allow_list_multi :Local :Path('pages/allow') :Args(2) :FB11Feature('Allow users to modify pages') {
	my ($self, $c, $site_id, $user_id) = @_;

	if ($c->req->body_params->{submit}) {
		my $page_users 	= $c->model('CMS::PageUser');
		my $pages 		= $c->req->body_params->{allow_page};
		$pages    		= [ $pages ] if ref($pages) ne 'ARRAY';

		$page_users->search({ user_id => $user_id })->delete;

		for my $page_id (@$pages) {
			$page_users->find_or_create({
				user_id => $user_id,
				page_id => $page_id,
			});
		}

		$c->flash(status_msg => "Updated page permissions");
		$c->res->redirect($c->req->uri);
		$c->detach;
	}

 	if (my $site = $c->model('CMS::Site')->find($site_id)) {
 		if (my $user = $c->model('CMS::User')->find($user_id)) {
 			my $page_users = $c->model('CMS::PageUser')->search({ user_id => $user_id });
	 		$c->stash(
	 			user 		=> $user,
	 			site 		=> $site,
	 			pages   	=> [ $c->model('CMS::Page')->search({ site => $site->id })->published->all ],
	 		);
	 	}
 	}
}

#----------------------------------------------------------------------------------
# ELEMENTS
#----------------------------------------------------------------------------------

sub element_allow_list :Local :Args(0) :FB11Feature('Allow users to modify elements') {
	my ($self, $c) = @_;
}

sub element_user_list :Local :Args(2) :FB11Feature('Allow users to modify elements') {
	my ($self, $c, $site_id, $element_id) = @_;

	my $element;
	if (my $site = $c->model('CMS::Site')->find($site_id)) {
		if ($element = $c->model('CMS::Element')->find($element_id)) {
			$c->stash(
				element 	  => $element,
				element_users => [ $element->element_users->all ],
				site_users    => [ $site->sites_users->all ],
			);
		}
	}

	if ($c->req->body_params->{submit}) {
        my $user_rs = $c->model('CMS::User');
        my $users = $c->req->body_params->{allow_users};
        $users    = [ $users ] if ref($users) ne 'ARRAY';
        for my $user (@$users) {
            $user = $user_rs->find($user);
            if ($user) {
                $element->element_users->find_or_create({
                    element_id 	=> $element->id,
                    user_id 	=> $user->id,
                });
            }
        }

        $c->flash(status_msg => "Updated permissions");
        $c->res->redirect($c->req->uri);
        $c->detach;
	}
}
sub element_revoke_permission :Local :Args(3) :FB11Feature('Allow users to modify elements') {
	my ($self, $c, $element_id, $site_id, $user_id) = @_;
	if (my $perm = $c->model('CMS::ElementUser')->find({ element_id => $element_id, user_id => $user_id })) {
		$perm->delete;
		$c->flash(status_msg => "Revoked permission from element " . $perm->element->name);
		$c->res->redirect($c->uri_for($self->action_for('element_user_list'), $site_id, $element_id));
		$c->detach;
	}
}

sub element_allow_list_multi :Local :Path('elements/allow') :Args(2) :FB11Feature('Allow users to modify elements') {
	my ($self, $c, $site_id, $user_id) = @_;

	if ($c->req->body_params->{submit}) {
		my $element_users 	= $c->model('CMS::ElementUser');
		my $elements 		= $c->req->body_params->{allow_element};
		$elements    		= [ $elements ] if ref($elements) ne 'ARRAY';

		$element_users->search({ user_id => $user_id })->delete;

		for my $element_id (@$elements) {
			$element_users->find_or_create({
				user_id 	=> $user_id,
				element_id 	=> $element_id,
			});
		}

		$c->flash(status_msg => "Updated element permissions");
		$c->res->redirect($c->req->uri);
		$c->detach;
	}

 	if (my $site = $c->model('CMS::Site')->find($site_id)) {
 		if (my $user = $c->model('CMS::User')->find($user_id)) {
 			my $element_users = $c->model('CMS::ElementUser')->search({ user_id => $user_id });
	 		$c->stash(
	 			user 		=> $user,
	 			site 		=> $site,
	 			elements   	=> [ $c->model('CMS::Element')->search({ site => $site->id })->published->all ],
	 		);
	 	}
 	}
}

#----------------------------------------------------------------------------------

sub manage_users :Local :Path('users/manage') :Args(1) :FB11Feature('Manage Users') {
	my ($self, $c, $site_id) = @_;

	if (my $site = $c->model('CMS::Site')->find($site_id)) {
		$c->stash(
			site  => $site,
			users => [ $site->sites_users->all ]
		);
	}
}

1;

=head1 NAME

OpusVL::FB11X::CMS::Controller::CMS::UserAccess

=head1 DESCRIPTION

=head1 METHODS

=head2 page_allow_list

=head2 page_revoke_permission

=head2 page_allow_list_multi

=head2 element_allow_list

=head2 element_user_list

=head2 element_revoke_permission

=head2 element_allow_list_multi

=head2 manage_users

=head1 ATTRIBUTES


=cut
