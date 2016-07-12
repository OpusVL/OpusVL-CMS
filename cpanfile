requires 'Captcha::reCAPTCHA';
requires 'DateTime::Format::Pg';
requires 'DBIx::Class::Helper::ResultSet::SetOperations';
requires 'DBIx::Class::TimeStamp';
requires 'DBIx::Class::Tree::AdjacencyList';
requires 'Email::MIME';
requires 'Email::Sender::Simple';
requires 'experimental';
requires 'MooseX::NonMoose';
requires 'OpusVL::AppKit::Schema::AppKitAuthDB';
requires 'OpusVL::DBIC::Helper';
requires 'Sort::Naturally';
requires 'DBIx::Class::DeploymentHandler';

on 'test' => sub {
    requires 'Test::Most';
    requires 'Dir::Self';
};
