requires 'Captcha::reCAPTCHA';
requires 'Catalyst::Controller::HTML::FormFu';
requires 'DBIx::Class::DeploymentHandler';
requires 'DBIx::Class::Helpers';
requires 'DBIx::Class::Report';
requires 'DBIx::Class::TimeStamp';
requires 'DBIx::Class::Tree::AdjacencyList';
requires 'Date::Manip';
requires 'DateTime::Format::Pg';
requires 'Digest::MD5';
requires 'Email::MIME';
requires 'Email::Sender::Simple';
requires 'HTML::Element';
requires 'HTML::FormFu::Model::DBIC';
requires 'List::Gather';
requires 'Moose';
requires 'MooseX::NonMoose';
requires 'MooseX::Role::Parameterized';
requires 'OpusVL::AppKit::Schema::AppKitAuthDB';
requires 'OpusVL::CMS', '39';
requires 'OpusVL::DBIC::Helper';
requires 'OpusVL::FB11', '0.026';
requires 'OpusVL::FB11::FormFu';
requires 'OpusVL::FB11X::CMSView';
requires 'Scalar::IfDefined';
requires 'Sort::Naturally';
requires 'Switch::Plain';
requires 'Template::Plugin::HTML::Strip';
requires 'Template::Plugin::MultiMarkdown';
requires 'experimental';
requires 'namespace::autoclean';

on test => sub {
    requires 'Catalyst::Runtime', '5.80015';
    requires 'Dir::Self';
    requires 'Test::DBIx::Class';
    requires 'Test::More', '0.88';
    requires 'Test::Most';
    requires 'Test::Requires';
    requires 'Test::WWW::Mechanize::Catalyst';
};

on develop => sub {
    requires 'Test::Pod', '1.14';
    requires 'Test::Pod::Coverage', '1.04';
};
