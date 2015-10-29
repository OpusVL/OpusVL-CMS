use inc::Module::Install;

name     'OpusVL-CMS';
all_from 'lib/OpusVL/CMS.pm';
author   q{Jon Allen (JJ) <jj@opusvl.com>};
license  'perl';

test_requires 'Dir::Self';

requires 'DBIx::Class::Tree::AdjacencyList';
build_requires 'Test::Most';
requires 'DBIx::Class::Helper::ResultSet::SetOperations';
requires 'Email::MIME';
requires 'MooseX::NonMoose';
requires 'Email::Sender::Simple';
requires 'Sort::Naturally';
requires 'Captcha::reCAPTCHA';
requires 'DateTime::Format::Pg';
auto_install;
resources (
    repository => {
        url => 'ssh://git/srv/git/OpusVL-CMS',
        type => 'git',
    },
);


WriteAll;

