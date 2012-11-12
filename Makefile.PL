use inc::Module::Install;

name     'OpusVL-CMS';
all_from 'lib/OpusVL/CMS.pm';
author   q{Jon Allen (JJ) <jj@opusvl.com>};
license  'perl';

requires 'DBIx::Class::Tree::AdjacencyList';
build_requires 'Test::More';
requires 'DBIx::Class::Helper::ResultSet::SetOperations';

auto_install;

WriteAll;

