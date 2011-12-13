use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::Repository;

name 'Skype-Any';
all_from 'lib/Skype/Any.pm';

requires 'parent';

test_requires 'Test::More' => 0.98;

tests 't/*.t';
author_tests 'xt';

auto_set_repository;

WriteAll;
