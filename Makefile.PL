use inc::Module::Install;

name     'OpusVL-CMS';
all_from 'lib/OpusVL/CMS.pm';
author   q{Jon Allen (JJ) <jj@opusvl.com>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

