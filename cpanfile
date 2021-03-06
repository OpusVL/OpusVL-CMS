requires 'Captcha::noCAPTCHA';
requires 'DateTime::Format::Pg';
requires 'DBIx::Class::Helpers';
requires 'DBIx::Class::TimeStamp';
requires 'DBIx::Class::Tree::AdjacencyList';
requires 'Email::MIME';
requires 'Email::Sender::Simple';
requires 'experimental';
requires 'MooseX::NonMoose';
requires 'MooseX::Role::Parameterized';
requires 'OpusVL::AppKit::Schema::AppKitAuthDB';
requires 'OpusVL::DBIC::Helper';
requires 'Sort::Naturally';
requires 'Switch::Plain';
requires 'Scalar::IfDefined';
requires 'DBIx::Class::DeploymentHandler';
requires 'DBIx::Class::Report';
requires 'Digest::MD5';
requires 'List::Gather';
requires 'HTML::Element';

on 'test' => sub {
    requires 'Test::Most';
    requires 'Test::DBIx::Class';
    requires 'Dir::Self';
    requires 'Test::Requires';
};
